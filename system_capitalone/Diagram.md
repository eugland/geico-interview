                ┌────────────┐
                │ Deposit CSV│
                └─────┬──────┘
                      │ (upload)
                      ▼
                ┌────────────┐
                │ S3 Bucket  │
                └─────┬──────┘
                      │ (trigger)
                      ▼
        ┌────────────────────────────┐
        │ Lambda: DepositProcessor   │
        └─────┬────────────┬─────────┘
              │            │
              ▼            ▼
     ┌────────────────┐   ┌────────────────────┐
     │ DynamoDB:      │   │ Aurora:             │
     │ DepositEvents  │   │ CreditBalance Table │
     └────────────────┘   └────────────────────┘
                                  ▲
                                  │ (optional nightly sync)
                                  ▼
     ┌────────────────────────────────────────────────┐
     │ Scheduled lambda batch job: Reconciliation     │
     └────────────────────────────────────────────────┘

--- Transaction Phase ---

                        ┌────────────────────────┐
                        │ EventGrid / API Gateway│
                        └────────┬───────────────┘
                                 ▼
                      ┌──────────────────────────────┐
                      │ Lambda: TransactionValidator │
                      └──────┬────────────┬──────────┘
                             │            │
                   ┌────────▼──┐      ┌───▼────────────┐
                   │ DynamoDB  │      │ Aurora         │
                   │ CreditCache│     │ Users, Funding │
                   └───────────┘      └────────────────┘
                             │
                  ┌──────────▼──────────┐
                  │ Permit / Reject     │
                  │ Decision            │
                  │ (EventBus/callback) │
                  └──────────┬──────────┘
                             ▼
                             sqs
                             ▼
                  ┌────────────────────────┐
                  │ Lambda: TransactionLog │
                  └──────────┬─────────────┘
                             ▼
                   ┌────────────────────┐
                   │ DynamoDB: Logs     │
                   └────────────────────┘
                             │
                             ▼
                   ┌────────────────────┐
                   │ Firehose → S3/Redshift│
                   └────────────────────┘

Here's your complete **system flow and component role description in Markdown**:

---
Absolutely — here's your updated **Markdown system design** with a **Design Rationale** section and annotated **metrics** (QPS, data size, throughput, storage).

---

# 💳 Credit & Transaction Authorization System Design (with Rationale & Metrics)

---

## 🟩 1. Deposit Phase (User Gets Credited)

### Step 1: File Upload to S3

* **Uploader**: Banking partner or internal batch system
* **Format**: CSV files with rows like:
  `user_id, amount, deposit_id, timestamp`
* **Design Rationale**:

  * S3 provides scalable, durable intake for batch uploads
  * Trigger-based design decouples ingestion from compute
* **Metrics**:

  * \~1–10 files/day, \~1–10MB/file ⇒ **10–100MB/day**
  * QPS: Near-zero, burst uploads nightly

### Step 2: `Lambda: DepositProcessor`

* **Triggered by**: S3 `putObject` event
* **Responsibilities**:

  * Parses each row of the CSV
  * Validates data integrity
  * Writes to:

    * `DynamoDB: DepositEvents`
    * `Aurora: CreditBalance`
    * Optional: `DynamoDB: CreditCache`
* **Design Rationale**:

  * Stateless, scalable ingestion using Lambda
  * DynamoDB gives fast writes for log-style data
  * Aurora maintains long-term relational integrity
* **Metrics**:

  * \~50,000 deposits/day
  * QPS: **\~0.5–5/sec**, bursty
  * \~200KB–1MB of DynamoDB writes/day

---

## 🟦 2. Transaction Phase (User Spends Credit)

### Step 3: Transaction Request

* **Source**: Partner API, user frontend, internal service
* **Path**: EventGrid or API Gateway
* **Payload Example**:

  ```json
  {
    "transaction_id": "txn_123",
    "user_id": "user_456",
    "amount": 25.00,
    "callback_url": "https://partner.com/txn-result"
  }
  ```
* **Design Rationale**:

  * Event-driven approach enables async fan-out, retry, and scaling
  * Callback design gives real-time feedback to caller
* **Metrics**:

  * **50,000 transactions/day**
  * QPS: **\~0.6 average**, **50–100 QPS peak**

### Step 4: `Lambda: TransactionValidator`

* **Responsibilities**:

  * Look up `user_id` in `CreditCache` (DynamoDB)
  * Fallback to `Aurora: CreditBalance` if not cached
  * Evaluate transaction against credit
  * Post result to `callback_url`
* **Design Rationale**:

  * Fast read path via DynamoDB
  * Strong fallback consistency via Aurora
  * Keeps Lambda stateless
* **Metrics**:

  * QPS: Matches transaction QPS (up to 100 peak)
  * Latency target: **<50ms avg**
  * Network I/O (callback): \~1KB/post × 50k/day = **\~50MB/day**

### Step 5: Callback to Originator

* **Action**: HTTP POST to external `callback_url`
* **Payload Example**:

  ```json
  {
    "transaction_id": "txn_123",
    "status": "PERMIT",
    "reason": "Sufficient credit",
    "remaining_credit": 75.00
  }
  ```
* **Design Rationale**:

  * Pushes result immediately to external system
  * Allows retry logic and observability on caller side
* **Metrics**:

  * **\~50,000 callbacks/day**
  * Payload size: \~1–2KB
  * Network: **\~100MB/day outbound**

---

## 🟨 3. Logging Phase

### Step 6: `Lambda: TransactionLogger`

* **Triggered by**: Successful callback or validator
* **Responsibilities**:

  * Write to `DynamoDB: TransactionLog`
  * Optionally update `Aurora: CreditBalance` (deduct credit)
  * Emit structured log to **Kinesis Firehose**
* **Design Rationale**:

  * Separates critical path from persistence
  * Supports long-term compliance, analytics
* **Metrics**:

  * Writes: \~50,000/day
  * Payload: \~1KB per log entry
  * Firehose → S3 storage: **\~50MB/day raw, 10–20MB compressed**

---

## 🟥 4. Reconciliation Phase

### Step 7: Nightly Batch Job

* **Runs Once Daily**
* **Compares**:

  * `SUM(deposits)` from `DepositEvents`
  * `SUM(spends)` from `TransactionLog`
  * Final result must equal `CreditBalance`
* **Design Rationale**:

  * Ensures data integrity between systems
  * Adds a layer of confidence for audits and reporting
* **Metrics**:

  * Affects \~20,000 users/day
  * Runs for \~5–15 minutes depending on Aurora/Dynamo scale

---

## 📊 Component Summary

| Component                        | Role                                      | Metrics                  |
| -------------------------------- | ----------------------------------------- | ------------------------ |
| **S3 Bucket**                    | Deposit intake                            | 10–100MB/day             |
| **Lambda: DepositProcessor**     | Parses deposits, updates credit           | 50K events/day           |
| **Aurora: CreditBalance**        | Source of truth for credit balances       | 20K rows, \~5–10GB total |
| **DynamoDB: DepositEvents**      | Append-only log of deposits               | \~50MB/day               |
| **EventGrid / API Gateway**      | Entry for transaction requests            | 50K requests/day         |
| **Lambda: TransactionValidator** | Validates transaction & sends callback    | 50–100 QPS peak          |
| **Callback (Webhook)**           | Sends permit/reject to originator         | \~100MB/day network      |
| **DynamoDB: CreditCache**        | Fast cache for credit values              | 20K items                |
| **Lambda: TransactionLogger**    | Logs transactions and updates balances    | 50K logs/day             |
| **DynamoDB: TransactionLog**     | Stores decision history                   | \~50MB/day               |
| **Firehose → S3/Redshift**       | Long-term audit and analytics storage     | 10–50MB/day compressed   |
| **Reconciliation Job**           | Validates credit integrity across systems | Runs daily, low compute  |

---

Let me know if you want this exported to a `.md` file, integrated into GitHub documentation, or diagrammed as a Mermaid chart.
