#!/bin/sh
if easyeffects -b 3 | grep 0; then
  easyeffects -b 1;
else
  easyeffects -b 2;
fi;

