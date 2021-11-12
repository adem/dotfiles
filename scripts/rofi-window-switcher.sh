#!/usr/bin/env bash

set -euo pipefail

tree=$(swaymsg -t get_tree)
readarray -t win_ids <<< "$(jq -r '.. | objects | select(has("app_id")) | .id' <<< "$tree")"
readarray -t win_names <<< "$(jq -r '.. | objects | select(has("app_id")) | .name' <<< "$tree")"
readarray -t win_types <<< "$(jq -r '.. | objects | select(has("app_id")) | .app_id // .window_properties.class' <<< "$tree")"

switch () {
        local k
            read -r k
                swaymsg "[con_id=${win_ids[$k]}] focus"
}

for k in $(seq 0 $((${#win_ids[@]} - 1))); do
        echo -e "<span weight=\"bold\">${win_types[$k]}</span> - ${win_names[$k]}"
        done | rofi -dmenu -markup-rows -i -p window -format i | switch
