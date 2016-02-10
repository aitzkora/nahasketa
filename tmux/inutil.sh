#!/bin/bash
function get_current_pane()
{
 get_current_pane=`tmux list-panes | grep active | cut -d ':' -f 1`
}

function number_of_panes()
{
  number_of_panes=`tmux list-panes | wc -l` 
}

get_current_pane
for i in $(seq 1 4); do
        if  (( $i % 2 == 0))
    then
        tmux split-window -h -t $get_current_pane;
    else 
        tmux split-window -v -t $get_current_pane
fi
done
number_of_panes
for i in $(seq 1 $number_of_panes); do
        tmux send-keys -t:.$i 'echo COUCOU' C-m
done
tours=$((30 * $number_of_panes))
for i in $(seq 1 $tours); do
        p=$(($i % $number_of_panes)) 
        tmux select-pane -t:.$p 
done
