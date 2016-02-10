#!/bin/bash
function get_current_pane()
{
 get_current_pane=`tmux list-panes | grep active | cut -d ':' -f 1`
}

get_current_pane
for i in $(seq 1 10); do
        if  (( $i % 2 == 0))
    then
        tmux split-window -h -t $get_current_pane;
    else 
        tmux split-window -v -t $get_current_pane
fi
done
