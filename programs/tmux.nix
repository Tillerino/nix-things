{ } :

{
  enable = true;

  # To reload the config after running home-manager, go <prefix> I
  extraConfig = ''
    # See https://www.youtube.com/watch?v=DzNmUNvnB04
    # Cheat sheet for key combos: https://tmuxcheatsheet.com/

    # 24 bit color
    set-option -sa terminal-overrides ",xterm*:Tc"

    # Click around with the mouse to activate windows, panes.
    # Simply drag to copy
    set -g mouse on

    # Rebind prefix to Ctrl-Space
    unbind C-b
    set -g prefix C-Space
    bind C-Space send-prefix

    # Start windows and panes at 1, not 0, so it aligns with the keyboard layout
    set -g base-index 1
    set -g pane-base-index 1
    set-window-option -g pane-base-index 1
    set-option -g renumber-windows on

    bind -n M-H previous-window # alt-shift-H
    bind -n M-L next-window     # alt-shift-L

    # When splitting panes, keep working directory
    bind '"' split-window -v -c "#{pane_current_path}"
    bind % split-window -h -c "#{pane_current_path}"

    # Use vi keys in copy mode.
    # <prefix> [ -> go to copy mode, space -> start selection, enter copy selection
    setw -g mode-keys vi

    set -g @plugin 'tmux-plugins/tpm'
    set -g @plugin 'tmux-plugins/tmux-sensible'
    # navigate around panes with Ctrl-H,J,K,L - same plugin in neovim - seamless
    set -g @plugin 'christoomey/vim-tmux-navigator'

    run '~/.tmux/plugins/tpm/tpm'
  '';
}
