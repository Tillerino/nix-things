#!/usr/bin/env bash
set -euo pipefail

# if in terminal, use alternatives
if [ "$XDG_SESSION_TYPE" = "tty" ]; then
  DMENU=(fzf --no-sort --layout reverse --header)
  NOTIFY=(echo)
else
  DMENU=(dmenu "-l" 20 "-i" "-fn" 'DejaVu Sans Mono-19' "-nf" '#b6b7b8' "-sf" '#262626' "-nb" '#262626' "-sb" '#b6b7b8' "-p")
  NOTIFY=(notify-send -e -t 500)
fi

function error() {
  "${NOTIFY[@]}" "Error"
  exit 1
}

trap error ERR

# so we can go `kill -INT $$` in subshells. That will exit the script
trap 'exit 0' INT

l1=$(echo "Sound" | "${DMENU[@]}" "Level 1" || kill -INT $$)

case $l1 in
  "Sound")
    if [ "$XDG_SESSION_TYPE" = "tty" ]; then
      eq="(in terminal)"
      output="(in terminal)"
    else
      if pgrep easyeffects; then
        if easyeffects -b 3 | grep 0; then
          eq="Bypass EQ";
        else
          eq="Enable EQ";
        fi
      else
        eq="(Easyeffects not running)"
      fi
      output="Output ($(pactl info | rg "Default Sink: (.*)" -or '$1'))"
    fi

    l2=$(echo "$eq"'
'"$output" | "${DMENU[@]}" "Level 2" || kill -INT $$)
    case $l2 in
      "$eq")
        if easyeffects -b 3 | grep 0; then
          easyeffects -b 1 && "${NOTIFY[@]}" "EasyEffects: Bypassed";
        else
          easyeffects -b 2 && "${NOTIFY[@]}" "EasyEffects: Enabled";
        fi;
        ;;
      "$output")
        device=$(pactl list sinks | rg "Name: (.*)" -or '$1' | rg -v easyeffects | "${DMENU[@]}" "Choose Device" || kill -INT $$)
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
