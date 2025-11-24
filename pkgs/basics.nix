{pkgs, unstable}:
with pkgs; [
  zoxide # nicer cd, configured in zsh init
  tmux
  neofetch
  zsh-completions
  btop
  killall

  # files
  fzf # for fuzzy zoxide or for easy choices in shell
  ripgrep
  rdfind # for simple deduplication. run rdfind -n true -deleteduplicates true . and remove -n true (dry-run) once satisfied
  nnn
  czkawka # for image, video deduplication

  # disk stuff
  hdparm # check power
  bonnie # bonnie++ -> simple fs benchmark
  fio # more complex fs benchmark, see ',fio-' aliases
  gdu # disk utilization
  pv # "pipe view". pipe through this and it will show speed in stderr. can also limit speed.
  smartmontools # sudo smartctl -a /dev/sda

  tealdeer # alternative tldr implementation
  thefuck

  # Network
  curl
  wget
  magic-wormhole
  inetutils
  tcpdump
  lsof
  gupnp-tools # run gssdp-discover -i <interface> to discover UPnP/SSDP services
  netcat-gnu
  nebula
  knot-dns # kdig -> like dig but diggier
  nmap # port scanner

  jq

  unstable.just
  tup

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

  # Video processing
  ffmpeg

  gitui # TUI for git

  cloc # count lines of code

  usbutils # includes lsusb

  dive # inspect container images
  lazydocker # TUI for docker
]
