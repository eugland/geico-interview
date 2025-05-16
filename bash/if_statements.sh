#!/usr/bin/env bash
var=''
if [[ -z $var ]]; then
    echo empty
fi

var='notempty'

read -p "guess a number from 1 - 10:" var
if [[ -z $var ]]; then
    echo "Oh no, you did not enter anything."; exit;


# elif [[ "$var" < 1 || "$var" > 10 ]]; then 
# holy shit the above do not work cause they eval string


elif (( "$var" < 1 || "$var" > 10 )); then
    echo "Oh no, your answer $var is out of the bound!"; exit;
else
    echo "Your number is $var"
fi

echo "End Reached"