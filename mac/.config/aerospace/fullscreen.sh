#!/bin/bash

# Aerospace Fullscreen Toggle - Hide All Non-Focused Windows
# Moves ALL other windows to temp workspaces when fullscreening

# Function to get focused window info
get_focused_window() {
    aerospace list-windows --focused --format "%{window-id}:%{app-name}:%{workspace}:%{window-is-fullscreen}"
}

# Function to move other windows away
move_windows_away() {
    local focused_window_id="$1"
    local current_workspace="$2"
    local temp_workspace="temp$current_workspace"
    
    echo "Moving other windows from workspace $current_workspace to workspace $temp_workspace"
    
    local windows=$(aerospace list-windows --workspace "$current_workspace" --format "%{window-id}")
    local moved_count=0
    
    for window_id in $windows; do
        if [ "$window_id" = "$focused_window_id" ]; then
            continue
        fi
        echo "Moving window $window_id to workspace $temp_workspace"
        aerospace move-node-to-workspace --window-id "$window_id" "$temp_workspace"
        ((moved_count++))
    done
    
    # Save state for restoration
    echo "Moved $moved_count windows to workspace $temp_workspace"
}

# Function to restore windows
restore_windows() {
    local current_workspace="$1"
    local temp_workspace="temp$current_workspace"
    local moved_windows=$(aerospace list-windows --workspace "$temp_workspace" --format "%{window-id}")
    
    echo "Restoring windows from $temp_workspace to workspace $current_workspace"
    
    local restored_count=0
    for window_id in $moved_windows; do
        echo "Restoring window $window_id to workspace $current_workspace"
        aerospace move-node-to-workspace --window-id "$window_id" "$current_workspace"
        ((restored_count++))
    done
    
    echo "Restored $restored_count windows to workspace $current_workspace"
}

# Main toggle function
toggle_fullscreen() {
    local focused_info=$(get_focused_window)
    local window_id=$(echo "$focused_info" | cut -d':' -f1)
    local app_name=$(echo "$focused_info" | cut -d':' -f2)
    local workspace=$(echo "$focused_info" | cut -d':' -f3)
    local is_fullscreen=$(echo "$focused_info" | cut -d':' -f4)
    
    if [ "$is_fullscreen" = "false" ]; then
        echo "Entering fullscreen mode for $app_name (workspace $workspace)"
        if [ "$app_name"="Alacritty" ]; then
            move_windows_away "$window_id" "$workspace"
        fi
        aerospace fullscreen
    else
        echo "Exiting fullscreen mode for $app_name"
        aerospace fullscreen
        if [ $app_name="Alacritty" ]; then
            restore_windows "$workspace"
        fi
    fi
}

# Run the toggle function
toggle_fullscreen