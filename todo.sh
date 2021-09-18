#!/bin/sh

# Aidan Bird 2021
#
# print out the todo list, date, and time 
#
# do $ todo.sh e ; to edit the todo list

todo_list_path=~/doc/TODO.txt

case "$1" in
    "e")
        # edit the todo list
        $EDITOR "$todo_list_path"
        ;;
    "i")
        # only display marked lines 
        grep '^#' "$todo_list_path" | sed 's/##//;s/#/\t/'
        ;;
    *)
        # display the todo list and calendar 
        echo -e "$(cal -3)\n\t$(date)\n$(cat "$todo_list_path")" | less -
        ;;
esac
exit 0
