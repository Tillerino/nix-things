{pkgs, unstable}:
with pkgs; [
    # General GUI
    dmenu # for X
    bemenu # for Wayland
    libnotify

    # Sound
    pulseaudio
    playerctl

    # Fonts
    ibm-plex
    nerdfonts

    # Other
    stretchly
]
