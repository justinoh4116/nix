# ~/.config/niri/scratch-term.sh
#!/bin/bash
APP_ID="scratch-term"
TERMINAL_CMD="wezterm start --class $APP_ID"
STASH_WS=99
WIN_W=1300
WIN_H=700

WIN_DATA=$(niri msg --json windows | jq -r ".[] | select(.app_id == \"$APP_ID\") | \"\(.id) \(.is_focused)\"")

if [ -z "$WIN_DATA" ]; then
  $TERMINAL_CMD &
  exit 0
fi

read -r WIN_ID IS_FOCUSED <<<"$WIN_DATA"
CURRENT_WS=$(niri msg --json workspaces | jq -r '.[] | select(.is_focused == true) | .idx')

if [ "$IS_FOCUSED" == "true" ]; then
  # Move to stash, then explicitly stay on current workspace
  niri msg action move-window-to-workspace --window-id "$WIN_ID" "$STASH_WS" --focus=false
  niri msg action focus-workspace "$CURRENT_WS"
else
  # Bring to current workspace
  niri msg action move-window-to-workspace --window-id "$WIN_ID" "$CURRENT_WS"
  niri msg action focus-workspace "$CURRENT_WS"
  niri msg action move-window-to-floating --id "$WIN_ID"

  # Manually center based on output size
  OUTPUT=$(niri msg --json focused-output)
  SCREEN_W=$(echo "$OUTPUT" | jq '.logical.width')
  SCREEN_H=$(echo "$OUTPUT" | jq '.logical.height')
  X=$(((SCREEN_W - WIN_W) / 2))
  Y=$(((SCREEN_H - WIN_H) / 2))

  niri msg action set-window-width --id "$WIN_ID" "$WIN_W"
  niri msg action set-window-height --id "$WIN_ID" "$WIN_H"
  niri msg action move-floating-window --id "$WIN_ID" -x "$X" -y "$Y"
  niri msg action focus-window --id "$WIN_ID"
fi
