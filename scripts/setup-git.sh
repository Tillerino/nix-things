#!/usr/bin/env bash

set -euo pipefail

# https://blog.gitbutler.com/how-git-core-devs-configure-git/

git config --global column.ui auto

git config --global branch.sort -committerdate

git config --global tag.sort version:refname

git config --global diff.algorithm histogram
git config --global diff.colorMoved plain
git config --global diff.mnemonicPrefix true
git config --global diff.renames true

git config --global fetch.prune true

git config --global help.autocorrect prompt

git config --global rerere.enabled true
git config --global rerere.autoupdate true

git config --global rebase.autoStash true
git config --global rebase.updateRefs true

git config --global pull.rebase true

git config --global merge.conflictStyle zdiff3
