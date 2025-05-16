## SRE Questions
1. project deep dive

## 如果刚入职，oncall的时候，碰到了一个新的问题，完全没思路。咋办？
1. 


3. 一个服务需要定义哪些指标来表示服务是健康的？
4. 在一个机器上，用什么命令来收集CPU的指标？
5. SLA & SLO是什么？

6. 如何做release？如何保证release的可靠性？如果发现bug，如何进行修补？应该revert还是patch？如果bug是跟特定的region有关的，有没有什么办法快速恢复（想问的应该是region failover）。


## SRE skills ranking
面试问题非常practical，先会问对一些方面的自我打分（0-10）然后根据你的打分给你出题：
network 4
linux 6
bash 6
python 10
docker 7


我docker bash 和python 打分比较高，所以会问一些shell 的问题，docker 的话会问一些实际操作的问题，如何debug等，python就是给一道题直接做一下。
shell是给了一些问题来问：
grep "Name\|Age" data.txt | sed 's/Name: //; s/Age: //' | awk 'BEGIN { FS = "\n"; RS = "" } { print "Name: " $1 ", Age: " $2 } 类似这样的命令让你解释


还有询问如何 debug 以下方面：
log:            journalctl service
DNS:            cat etc/hosts, /etc/resolv.conf then nslookup
TCP/IP          ss -tulp, telnet,L 
Http            ping, then curl

以及一些实际的问题：
报错端口被占用怎么办
机器log满了怎么办
## 如果无法reach 一个指定机器怎么办:
- ping          physica
- telnet        network
- tracerouete   get packets find out where losss


## SRE
上来先对几个方面的了解程度打分(0-5)
Linux
Python
Hadoop
Kubernetes
Distribution systems
Machine Learning infra

## 有没有分布式系统的经验 Distributed Systems：
- Yes talk about the test resolver Microsoft Swarm at Edge (show diagram)
- machines as tester
- stateless app as processor get test info and file.
- message queue to async send between apps.
- message queue on machine to be processed.
- reddis for in memory access.
- Talk about using lambda at capital One.
**Emphasize: Scalability, fault-tolerant/reliability, availibility**

## 怎么进入到linux服务器，怎么查看服务器系统健康（cpu memory disk）
- ssh -i username@hostname.ip of the linux server then provide either password or certificate
- top           CPU   
- free -h       memory
- df -h         file system
- du            file Usage
- netstat       get network port usage
- lsof, netstat, ss       network connection

## Linux Signals:
A signal is a software interrupt sent to a process to notify it of an event or to control its behavior. 
- kill -9 <pid>         to kill a process sends SIGKILL
- SIGINTER              ctrl + z
- SIGTERM (15)          Exit gracefully



## Python Garbage Collection
1. Reference Counting: every object reference if ref = 0, object deletes right away
2. cycle detector: uneachable cycles, delete right away

## 数组除我乘机 Product of array except self element
Algorithm 给一个nums数组，输出一个products数组，products[i] = 除了nums[i]之外其他数字的和，不能用除法

- 从左往右乘起来 arrleft，
- 从右往左乘起来 arrright，
- 然后从左往右，把arrleft[i - 1] * arrright[i + 1]

```python
def productExceptSelf(nums: List[int]) -> List[int]:
    n = len(nums)
    products = [1] * n

    prefix = 1
    for i in range(n):
        products[i] = prefix
        prefix *= nums[i]
    
    suffix = 1
    for i in range(n-1, -1, -1):
        products[i] *= suffix
        suffix *= nums[i]
    
    return products
```





## SLO  vs SLA  分别是什么 Notes
- SLO (Service Level Objective) is an objective that interanlly the SRE team and Dev team agree on not legally binding. IT should be ambitious and achievable
- SLA (Service Level Agreeement) is a contractrual agreement between the service provider and its customers. Violation will lead to compensation and lawsuits. SLA are usually set lower than SLO. for example 99.5 for a machine, 99.99 for availability zone service. and 99.0 has 3% compensation, 97% 50% and 95% 100%.
- in reality twist definition, and SLA does not guarantee, it is a calculation of earnings - compensation > break even?


## 测量产品可靠的关键数据： Metrics for reliability， avalaiblity: 
## 1 between and 4 Rs: 4 Rs: respond, recover, repair, resolve
Reliability = mean time to failure to mean time to repair 
MTBF, MTTR, MTTA, and MTTF
MTBF = mean time between failures: track availability and reliability
MTTR = mean time to repair: repair + testing time (only spent time)
MTTR = mean time to recovery: time between fail to recover = all down time / incidents count
MTTR = man time to resolve: resolution time / incidents: (business hours )
MTTR = mean Time to Respond 

SRE: MTTR, MTTA
hardware:MTBF, MTTF
incident manage: MTTA, MTTR
SERVICE: MTBF, MTTR


## Alert, tickets, Logging 怎么用？ When should Machine be involved?
SRE should be automatic and little code written;
Human invovlment:
- Alerts: human action needed immediate
- Tickets: human action needed not so immediate
- Logging: diagnostic or foreinsic purpose
- record a playbook produce 3x improvement in MTTR as opposed to winging it.

## 怎么部署？ How to deploy？ 
Change:
- progressive, 
- detec plans 
- roll back safely

## 预测的原则？ Demand forcasting principals?
demand forcasting: organic vs inorganic growth
- accurate organic demand forecast
- accurate incorporation of inorganic demand
- regular load test
- 
