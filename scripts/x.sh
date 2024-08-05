#!/usr/bin/env bash
set -euo pipefail

# if in terminal, use alternatives
if [ "$XDG_SESSION_TYPE" = "tty" ]; then
  DMENU=(fzf --no-sort --layout reverse --header)
  NOTIFY=(echo)

  eq="(in terminal)"
else
  DMENU=(dmenu "-l" 20 "-i" "-fn" 'DejaVu Sans Mono-19' "-nf" '#b6b7b8' "-sf" '#262626' "-nb" '#262626' "-sb" '#b6b7b8' "-p")
  NOTIFY=(notify-send -e -t 500)

  if pgrep easyeffects; then
    if easyeffects -b 3 | grep 0; then
      eq="Bypass EQ";
    else
      eq="Enable EQ";
    fi
  else
    eq="(Easyeffects not running)"
  fi
fi

function error() {
  "${NOTIFY[@]}" "Error"
  exit 1
}

trap error ERR

l1=$(echo "Sound" | "${DMENU[@]}" "Level 1" || exit 0)

case $l1 in
  "Sound")
    l2=$(echo "$eq"'
Output' | "${DMENU[@]}" "Level 2" || exit 0)
    case $l2 in
      "$eq")
        if easyeffects -b 3 | grep 0; then
          easyeffects -b 1 && "${NOTIFY[@]}" "EasyEffects: Bypassed";
        else
          easyeffects -b 2 && "${NOTIFY[@]}" "EasyEffects: Enabled";
        fi;
        ;;
      "Output")
        device=$(pactl list sinks | rg "Name: (.*)" -or '$1' | "${DMENU[@]}" "Choose Device")
        pactl set-default-sink "$device"
        ;;
      *)
        echo "Invalid option"
        exit 1
        ;;
    esac
    ;;
  *)
    echo "Invalid option"
    exit 1
    ;;
esac
