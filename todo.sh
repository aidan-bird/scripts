#!/bin/sh

# Aidan Bird 2021
#
# print out the todo list, date, and time 
#
# do $ todo.sh e ; to edit the todo list

todo_list_path=~/doc/TODO.txt

[ "$1" = "e" ] && $EDITOR "$todo_list_path" || \
    echo -e "$(cal -3)\n\t$(date)\n$(cat "$todo_list_path")" | less -
