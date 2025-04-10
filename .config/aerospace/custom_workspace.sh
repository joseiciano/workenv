#!/bin/bash

set -eu -o pipefail

WORKSPACE_SETUP="${1:-"coding-with-browser"}"

open_and_sleep() {
  app_name="$1"
  open -a "$app_name"
  sleep 0.25
}

open_new_and_sleep() {
  app_name="$1"
  open -a -n "$app_name"
  sleep 0.25
}

# Function to get the window ID of an app
get_window_id() {
  app_name="$1"
  open_new="$2"

  if [ -z "$open_new" ]; then
    open_and_sleep "$app_name"
  else
    open_new_and_sleep "$app_name"
  fi

  windows=$(aerospace list-windows --monitor focused --json)
  window_id=$(echo "$windows" | jq -r --arg app "$app_name" '.[] | select(.["app-name"] == $app) | .["window-id"]')
  echo "$window_id"
}


# Function to move an app to the current workspace
move_to_workspace() {
  app_name="$1"
  open_new="$2"
  window_id=$(get_window_id "$app_name" "$open_new")

  # Try to focus the app first, then move it to the current workspace
  aerospace focus --window-id "$window_id"
  aerospace move-node-to-workspace --window-id "$window_id" "$WORKSPACE_SETUP"

  echo $window_id
}

if [ "$WORKSPACE_SETUP" == "coding-with-browser" ]; then
  edge_window_id=$(move_to_workspace "Microsoft Edge")
  cursor_window_id=$(move_to_workspace "Cursor")

  aerospace move --window-id "$edge_window_id" left 
  aerospace move --window-id "$cursor_window_id" right 
  aerospace resize --window-id "$cursor_window_id" width +150
elif [ "$WORKSPACE_SETUP" == "coding-fullscreen" ]; then
  cursor_window_id=$(move_to_workspace "Cursor")
  aerospace fullscreen --window-id "$cursor_window_id"  
elif [ "$WORKSPACE_SETUP" == "browsing-fullscreen" ]; then
  edge_window_id=$(move_to_workspace "Microsoft Edge")
  aerospace fullscreen --window-id "$edge_window_id"
elif [ "$WORKSPACE_SETUP" == "browsing-dual-edge" ]; then
  edge_window_id_1=$(move_to_workspace "Microsoft Edge")
  edge_window_id_2=$(move_to_workspace "Microsoft Edge" "new")

  aerospace move --window-id "$edge_window_id_1" left
  aerospace move --window-id "$edge_window_id_2" right
  aerospace resize --window-id "$edge_window_id_2" width +150
elif [ "$WORKSPACE_SETUP" == "stocks-research" ]; then
  webull_window_id=$(move_to_workspace "Webull")
  edge_window_id_1=$(move_to_workspace "Microsoft Edge")
  edge_window_id_2=$(move_to_workspace "Microsoft Edge" "new")

  aerospace move --window-id "$webull_window_id" left
  aerospace move --window-id "$edge_window_id_1" left
  aerospace move --window-id "$edge_window_id_2" left
  aerospace join-with --window-id "$edge_window_id_1" left
  aerospace move --window-id "$webull_window_id" bottom
elif [ "$WORKSPACE_SETUP" == "stocks-fullscreen" ]; then
  webull_window_id=$(move_to_workspace "Webull")
  aerospace fullscreen --window-id "$webull_window_id"
fi
