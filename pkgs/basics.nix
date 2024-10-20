{pkgs, unstable}:
with pkgs; [
  zoxide # nicer cd, configured in zsh init
  fzf # for fuzzy zoxide or for easy choices in shell
  ripgrep
  rdfind # for simple deduplication. run rdfind -n true -deleteduplicates true . and remove -n true (dry-run) once satisfied
  superfile
  gdu # disk utilization
  tmux
  bonnie # bonnie++ -> simple fs benchmark

  tldr
  thefuck

  curl
  wget
  magic-wormhole
  inetutils

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

  parallel

  gnupg

  trippy

  # gobang # SQL TUI -- doesn't compile currently

  # Image processing
  exiftool # view / modify exif data
  imagemagick # image converter

  gitui # TUI for git

  cloc # count lines of code

  usbutils # includes lsusb

  dive # inspect container images
  lazydocker # TUI for docker
]
