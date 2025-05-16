names=("John Smith" "Jay dobble" "Joe Hoyer")

# Array
for person in "${names[@]}" ; do 
    echo $person
done
echo $person # trickle down
echo ${names[1]}



declare -A hash
key=one
val=1
hash[$key]="$val"

for key in "${!hash[@]}"; do
    echo "key $key ==> value ${hash[$key]}"
done


i=0
while ((i < 3)); do 
    echo "$i"
    ((i++))
done;

i=0
until ((i == 3)); do 
    echo "$i"
    ((i++))
done;