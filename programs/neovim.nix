{ lib, pkgs, append ? { }, lsps ? true }:

let finalAppend = { plugins = [ ]; extraPackages = [ ]; extraConfig = ""; extraLuaConfig = ""; extraLazy = "{}"; } // append;

in

{
    enable = true;

    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: with p; [ bash c cpp css csv dhall dockerfile dot git_config git_rebase gitattributes gitcommit gitignore go gomod gpg haskell helm html java javascript jq json ledger lua make markdown nginx nix perl php python rust scala sql tmux toml typescript xml yaml zig ]))
      pkgs.vimPlugins.lazy-nvim # for everything not in nixpkgs
    ] ++ finalAppend.plugins;

    extraPackages = (if lsps then [
      pkgs.nil
      pkgs.java-language-server
      pkgs.ripgrep
      pkgs.pyright
      pkgs.vscode-langservers-extracted
      pkgs.nodePackages.bash-language-server
      pkgs.gopls
    ] else []) ++ finalAppend.extraPackages;

    extraConfig = ''
      " https://vi.stackexchange.com/a/4175
      " tabstop:          Width of tab character
      " softtabstop:      Fine tunes the amount of white space to be added
      " shiftwidth        Determines the amount of whitespace to add in normal mode
      " expandtab:        When this option is enabled, vi will use spaces instead of tabs
      set tabstop     =2
      set softtabstop =2
      set shiftwidth  =2
      set expandtab

      " load .nvim.lua, .nvimrc, and .exrc file from current directory on open
      set exrc
    '' + finalAppend.extraConfig;

    extraLuaConfig = ''
      extraLazy = ${finalAppend.extraLazy}
      dofile('${./neovim.lua}')
    '' + finalAppend.extraLuaConfig;
}

