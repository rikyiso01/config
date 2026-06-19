#!/usr/bin/env fish

hyprctl dispatch workspace 2
sleep 1
hyprctl dispatch killactive
sleep 3
hyprctl dispatch killactive

tmux select-window -t 1 \; select-pane -t 0 \; send-keys ':q' 'Enter'
tmux select-window -t 2 \; select-pane -t 0 \; send-keys ':q' 'Enter'
tmux select-window -t 3 \; select-pane -t 0 \; send-keys ':q' 'Enter'
tmux select-window -t 4 \; select-pane -t 0 \; send-keys ':q' 'Enter'
tmux kill-window -t 1
tmux kill-window -t 2
tmux kill-window -t 3
tmux kill-window -t 4
tmux kill-window -t 5

#systemctl poweroff
