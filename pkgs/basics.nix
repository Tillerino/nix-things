{pkgs, unstable}:
with pkgs; [
  zoxide # nicer cd, configured in zsh init
  fzf # for fuzzy zoxide
  ripgrep
  rdfind # for simple deduplication. run rdfind -n true -deleteduplicates true . and remove -n true (dry-run) once satisfied

  tldr
  thefuck

  curl
  wget

  jq

  unstable.just
  tup

  ibm-plex
  nerdfonts

  hyperfine # benchmark from CLI

  p7zip
  unzip
  zip

  b3sum # BLAKE3 hash function

  magic-wormhole

  parallel

  gnupg

  trippy

  gobang # SQL TUI
]
