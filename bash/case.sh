#!/bin/bash


# case "$1" in 
#     yes ) echo "glad you agree" ;;
#     no ) 
#         echo "sorry, bye"
#         exit
#     ;;
#     * ) echo "invalid, try again"
# esac
# echo 'Case ended'

var='empty'
until [[ $var == 'exit' ]]; do
    read var
    case "$var" in
        [Nn][Oo]* )
            echo "Fine. Leave then."
            exit
        ;;
        [Yy]?? | [Ss]ure | [Oo][Kk]* )
            echo "OK. Glad we agree."
        ;;
        * ) echo 'Try again.'
            echo "$var"
            continue
        ;;
    esac
done