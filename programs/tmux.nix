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

    # Remap keys in the session tree so that they start at 1, to align with keyboard layout
    bind-key s choose-tree -ZsK '#{?#{e|<:#{line},9},#{e|+:1,#{line}},#{?#{e|<:#{line},35},M-#{a:#{e|+:97,#{e|-:#{line},9}}},}}'

    # When splitting panes, keep working directory
    bind '"' split-window -v -c "#{pane_current_path}"
    bind % split-window -h -c "#{pane_current_path}"

    # Use vi keys in copy mode.
    # <prefix> [ -> go to copy mode, space -> start selection, enter -> copy selection.
    # Also just dragging the mouse and letting go copies (by default with mouse support above)
    setw -g mode-keys vi

    # Resurrect 
    set -g @resurrect-processes '"sudo -E -s nvim" vi vim nvim emacs man less more tail top htop irssi weechat mutt k9s "kubectl logs" "kubectl port-forward" watch ssh'
    set -g @resurrect-hook-post-save-all '~/git/nix-things/programs/tmux-resurrect-post-save.sh'
    set -g @resurrect-strategy-nvim 'session'
    set -g @resurrect-capture-pane-contents 'on'

    # Plugin list. Needs to be at the bottom of the file.
    set -g @plugin 'tmux-plugins/tpm'
    set -g @plugin 'tmux-plugins/tmux-sensible'
    # navigate around panes with Ctrl-H,J,K,L - same plugin in neovim - seamless
    set -g @plugin 'christoomey/vim-tmux-navigator'

    # Save and restore sessions
    set -g @plugin 'tmux-plugins/tmux-resurrect'

    # To install any plugins, TPM needs to be installed manually:
    # git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    run '~/.tmux/plugins/tpm/tpm'
  '';
}
