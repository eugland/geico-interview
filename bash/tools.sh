#!/usr/bin/env bash

grep "Name:" student.txt # give me the line 
grep -i "Name" student.txt  #give me name and Name line case insensitive
grep -n "Name" student.txt  #give me the line and line number labeled

echo "grep -v"
grep -v "Name" student.txt # all other lines 

echo "Get alice or Bob"
grep -i "Alice\|Bob" student.txt

grep -A2 'Alice\|Bob' student.txt