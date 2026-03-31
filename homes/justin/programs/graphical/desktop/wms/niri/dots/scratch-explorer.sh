# ~/.config/niri/scratch-term.sh
#!/bin/bash
APP_ID="org.kde.dolphin"
TERMINAL_CMD="dolphin"
STASH_WS=98
WIN_W=1300
WIN_H=700

# Capture focused state upfront, before any window manipulation
FOCUSED_OUTPUT=$(niri msg --json focused-output)
CURRENT_WS=$(niri msg --json workspaces | jq -r '.[] | select(.is_focused == true) | .idx')
OUTPUT_NAME=$(echo "$FOCUSED_OUTPUT" | jq -r '.name')

WIN_DATA=$(niri msg --json windows | jq -r ".[] | select(.app_id == \"$APP_ID\") | \"\(.id) \(.is_focused)\"")

if [ -z "$WIN_DATA" ]; then
  # Launch, then wait for the window to appear and move it to the correct output/workspace
  $TERMINAL_CMD &
  for i in $(seq 1 20); do
    sleep 0.15
    NEW_WIN_ID=$(niri msg --json windows | jq -r ".[] | select(.app_id == \"$APP_ID\") | .id")
    if [ -n "$NEW_WIN_ID" ]; then
      niri msg action move-window-to-monitor --id "$NEW_WIN_ID" "$OUTPUT_NAME"
      niri msg action move-window-to-workspace --window-id "$NEW_WIN_ID" "$CURRENT_WS"
      niri msg action move-window-to-floating --id "$NEW_WIN_ID"
      SCREEN_W=$(echo "$FOCUSED_OUTPUT" | jq '.logical.width')
      SCREEN_H=$(echo "$FOCUSED_OUTPUT" | jq '.logical.height')
      X=$(((SCREEN_W - WIN_W) / 2))
      Y=$(((SCREEN_H - WIN_H) / 2))
      niri msg action set-window-width --id "$NEW_WIN_ID" "$WIN_W"
      niri msg action set-window-height --id "$NEW_WIN_ID" "$WIN_H"
      niri msg action move-floating-window --id "$NEW_WIN_ID" -x "$X" -y "$Y"
      niri msg action focus-window --id "$NEW_WIN_ID"
      break
    fi
  done
  exit 0
fi

read -r WIN_ID IS_FOCUSED <<<"$WIN_DATA"

if [ "$IS_FOCUSED" == "true" ]; then
  niri msg action move-window-to-workspace --window-id "$WIN_ID" "$STASH_WS" --focus=false
  niri msg action focus-workspace "$CURRENT_WS"
else
  # Move to correct output first, then workspace
  niri msg action move-window-to-monitor --id "$WIN_ID" "$OUTPUT_NAME"
  niri msg action move-window-to-workspace --window-id "$WIN_ID" "$CURRENT_WS"
  niri msg action focus-workspace "$CURRENT_WS"
  niri msg action move-window-to-floating --id "$WIN_ID"
  SCREEN_W=$(echo "$FOCUSED_OUTPUT" | jq '.logical.width')
  SCREEN_H=$(echo "$FOCUSED_OUTPUT" | jq '.logical.height')
  X=$(((SCREEN_W - WIN_W) / 2))
  Y=$(((SCREEN_H - WIN_H) / 2))
  niri msg action set-window-width --id "$WIN_ID" "$WIN_W"
  niri msg action set-window-height --id "$WIN_ID" "$WIN_H"
  niri msg action move-floating-window --id "$WIN_ID" -x "$X" -y "$Y"
  niri msg action focus-window --id "$WIN_ID"
fi
