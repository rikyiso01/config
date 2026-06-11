#!/usr/bin/env fish

hyprctl dispatch workspace 2
sleep 1
hyprctl dispatch killactive
hyprctl dispatch killactive

tmux select-window -t 0 \; select-pane -t 0 \; send-keys 'q'
tmux select-window -t 1 \; select-pane -t 0 \; send-keys ':q'
tmux select-window -t 2 \; select-pane -t 0 \; send-keys ':q'
tmux select-window -t 3 \; select-pane -t 0 \; send-keys ':q'
tmux select-window -t 4 \; select-pane -t 0 \; send-keys ':q'
tmux kill-window 0
tmux kill-window 1
tmux kill-window 2
tmux kill-window 3
tmux kill-window 4
tmux kill-window 5

systemctl poweroff
