#!/usr/bin/env bash

L=~/.local/share/tmux/resurrect/last

cp $L $L.bak

# NixOS requires a bunch of cleanup because of wrapper scripts.
# See https://github.com/tmux-plugins/tmux-resurrect/issues/247#issuecomment-1425917842 
sed -i "s|/run/current-system/sw/bin/||g" $L
#sed -i "s|$HOME|~|g" $L
sed -i "s|$HOME/.nix-profile/bin/||g" $L
sed -ie "s|:bash .*/tmp/nix-shell-.*/rc|:nix-shell|g" $L

# This is a special kind of hell because of the Neovim wrapper :|
sed -ie "s| --cmd .*-vim-pack-dir||g" $L
