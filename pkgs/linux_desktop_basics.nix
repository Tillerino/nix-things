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
    nerd-fonts.blex-mono

    # Other
    stretchly
]
