#!/usr/bin/env bash

empty=''
space=' '
greet='Hello'
name='Eugene'
sentence='hi there'
int_small=1
int_large=2


# short if statements
[[ -n 'a' ]] && echo " {greet:'$greet'} is not empty"
[[ -z '' ]] && echo " {empty:'$empty'} is empty"
[[ 'a' == 'a' ]] && echo "'a' == 'a'"
[[ a == a ]] && echo a == a 

# but:
[ a = a ] && echo single bracket works a=a

# notice the error below
# but no exception thrown
[ $sentence = hi there ] && echo "N\A" || echo "word spliting not working" 
[ $sentence = "hi there" ] && echo "N\A" || echo "word spliting not working"
[ "$sentence" = "hi there" ] && echo "word splitting working in quotes" || echo "word spliting not working"

[[ $sentence = "hi there" ]] && echo "word splitting working in double brackets" || echo "N/A"
[[ "$sentence" = "hi there" ]] && echo "word splitting working in double brackets" || echo "N/A"


# if else
[[ $int_small -eq $int_large ]] && { echo "2 ints equal" ; } || { echo "2 ints not equal" "cool"; }

[[ "a" < "b" ]] && echo "a < b "
[[ "c" > "b" ]] && echo "c < b "
[[ "a" != "b" ]] && echo "a != b "
[[ 1 -eq 1 ]] && echo "1 -eq 1 "
[[ 1 -le 1 ]] && echo "1 -le 1 "
[[ 0 -lt 1 ]] && echo "0 -lt 1"
[[ 1 -gt 0 ]] && echo "1 -gt 0"

pwd
cd $DIR || echo "cd to $DIR failed." ; exit ;
pwd
echo "did not exit"
# notice the exit must be in side the {}

