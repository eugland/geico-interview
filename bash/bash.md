# Bash Notes
- mac zsh is not bash, but almost equivalent
- shbang tells the system what interpreter to use:
`#!/bin/bash`
- bash may not exists in containers, so use /bin/sh
- sh could be bash could be ash, dash, or even something else
- /etc/ stores system wide config files
- [] and [[ ]] are test statements they are used to execute a binary expression and return results.

# Expressions:
| Operator             | Meaning                                      | Example                             |
|----------------------|----------------------------------------------|-------------------------------------|
| `-n STRING`          | String is not empty                          | `[ -n "$str" ]`                     |
| `-z STRING`          | String is empty                              | `[ -z "$str" ]`                     |
| `STRING1 = STRING2`  | Strings are equal                            | `[ "$a" = "$b" ]`                   |
| `STRING1 != STRING2` | Strings are not equal                        | `[ "$a" != "$b" ]`                  |
| `INT1 -eq INT2`      | Equal (integers)                             | `[ "$x" -eq "$y" ]`                 |
| `INT1 -ne INT2`      | Not equal                                    | `[ "$x" -ne "$y" ]`                 |
| `INT1 -lt INT2`      | Less than                                    | `[ "$x" -lt 10 ]`                   |
| `INT1 -le INT2`      | Less than or equal                           | `[ "$x" -le 10 ]`                   |
| `INT1 -gt INT2`      | Greater than                                 | `[ "$x" -gt 5 ]`                    |
| `INT1 -ge INT2`      | Greater than or equal                        | `[ "$x" -ge 5 ]`                    |
| `-e FILE`            | File exists                                  | `[ -e "file.txt" ]`                 |
| `-f FILE`            | Is a regular file                            | `[ -f "data.txt" ]`                 |
| `-d FILE`            | Is a directory                               | `[ -d "/etc" ]`                     |
| `-s FILE`            | File exists and is not empty                 | `[ -s "log.txt" ]`                  |
| `-r FILE`            | File is readable                             | `[ -r "config.ini" ]`               |
| `-w FILE`            | File is writable                             | `[ -w "temp.txt" ]`                 |
| `-x FILE`            | File is executable                           | `[ -x "/usr/bin/ls" ]`              |
| `! EXPRESSION`       | Logical NOT                                  | `[ ! -f "badfile" ]`                |
| `EXPR1 -a EXPR2`     | Logical AND (POSIX `[ ]` style)              | `[ -f a -a -r a ]`                  |
| `EXPR1 -o EXPR2`     | Logical OR (POSIX `[ ]` style)               | `[ -f a -o -f b ]`                  |
| `EXPR1 && EXPR2`     | Logical AND (shell-level)                    | `[ -f a ] && echo "exists"`         |
| `EXPR1 || EXPR2`     | Logical OR (shell-level)                     | `[ -f a ] || echo "not found"`      |

