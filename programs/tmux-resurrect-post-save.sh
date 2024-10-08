#!/usr/bin/env bash

cd ~/.local/share/tmux/resurrect

cp last last.bak

# NixOS requires a bunch of cleanup because of wrapper scripts.
# See https://github.com/tmux-plugins/tmux-resurrect/issues/247#issuecomment-1425917842 
sed -i "s|/run/current-system/sw/bin/||g" last
sed -i "s|$HOME/.nix-profile/bin/||g" last
sed -ie "s|:bash .*/tmp/nix-shell-.*/rc|:nix-shell|g" last

# This is a special kind of hell because of the Neovim wrapper :|
sed -ie "s| --cmd .*-vim-pack-dir||g" last

for f in ~/.local/share/tmux/resurrect/*.txt; do f1=$f2; f2=$f; done
cp last $f.post
diff $f1.post last
