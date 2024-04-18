{pkgs, unstable}:
with pkgs; [
  zoxide # nicer cd, configured in zsh init
  fzf # for fuzzy zoxide
  ripgrep

  tldr
  thefuck

  curl
  wget

  jq

  unstable.just

  ibm-plex
  nerdfonts

  hyperfine # benchmark from CLI

  p7zip
  unzip
  zip

  b3sum # BLAKE3 hash function

  magic-wormhole

  parallel
]
