for ((i=0; i<10; i++)); do 
    # printf '%d\n' "$i"
    echo "$i"
done

i=0 
for ((;;)); do
    echo "i=$i"
    ((i=i+1))
    if ((i==10)); then
        break;
    fi
done

printf "%-10s | %3s | %6s | %s\n" "Name" "Age" "GPA" "Grade"
printf "%-10s | %3d | %6.2f | %c\n" "Alice" 30 3.85 A
printf "%-10s | %3d | %6.2f | %c\n" "Bob" 24 2.70 B

for num in 1 2 3 4 5; do
    echo "$num"
done

for value in "$@"; do # = $@
    echo "$value"
done

for arg in $(
    for person in Sue Neil Pat Harry; do
        echo "$person is coming to the party"
    done
); do
    echo "Let's welcome $arg"
done # notice each word is used 

for person in Sue Neil Pat Harry; do
    echo "$person is coming to the party"
done | while IFS="" read -r line; do
    echo "Lets welcome $line"
done

for i in $(seq 1 10); do 
    echo "Seq $i of 10"
done

for i in {100..0..-2}; do 
    printf '%d ' "$i"
done
printf '\n'

# for i in $(seq a d); do 
#     printf '%d ' "$i"
# done
# printf '\n'

for i in {1..26}; do
    letter=$(printf "\\$(printf '%o' $((i + 96)))")
    printf '%s' "$letter"
done
printf '\n'
for i in {1..26..2}; do
    letter=$(printf "\\$(printf '%o' $((i + 64)))")
    printf '%s' "$letter"
done
printf '\n'

for filename in log{01..5}.txt ; do
    # do something with the filenames here
    echo $filename
done