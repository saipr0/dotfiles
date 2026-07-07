#!/usr/bin/env bash

selected=$(tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}  #{window_name}  [#{pane_current_command}]  #{pane_current_path}' | \
    fzf -m \
    --color fg:dim,fg+:regular \
    --style full \
    --list-border --list-label ' tmux panes ')

if [[ -n $selected ]]; then
    target_pane=$(echo "$selected" | awk '{print $1}')
    tmux switch-client -t "$target_pane"
fi
