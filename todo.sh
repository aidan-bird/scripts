#!/bin/sh

# Aidan Bird 2021
#
# print out the todo list, date, and time 
#
# do $ todo.sh e ; to edit the todo list

todo_list_path=~/doc/TODO.txt

if [ "$1" = "e" ]
then
    $EDITOR $todo_list_path
else
    list="$(cal -3)"$'\n'
    list+=$'\t'"$(date)"$'\n'
    list+="$(cat $todo_list_path)"
    echo "$list" | less -
fi

