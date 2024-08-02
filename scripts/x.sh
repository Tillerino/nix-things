#!/usr/bin/env bash
set -euo pipefail

trap "notify-send Error" ERR

l1=$(echo "Sound" | dmenu -p "Level 1")

case $l1 in
  "Sound")
    l2=$(echo 'Bypass EQ
Output' | dmenu -p "Level 2")
    case $l2 in
      "Bypass EQ")
        if easyeffects -b 3 | grep 0; then
          easyeffects -b 1 && notify-send -e -t 500 "EasyEffects: Bypassed";
        else
          easyeffects -b 2 && notify-send -e -t 500 "EasyEffects: Enabled";
        fi;
        ;;
      "Output")
        device=$(pactl list sinks | rg "Name: (.*)" -or '$1' | dmenu -p "Choose Device")
        pactl set-default-sink $device
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
