{ pkgs, append ? { } }:

let finalAppend = { plugins = [ ]; extraPackages = [ ]; extraConfig = ""; extraLuaConfig = ""; extraLazy = "{}"; } // append;

in

{
    enable = true;

    plugins = [
#     pkgs.vimPlugins.wildfire-vim
      pkgs.vimPlugins.lazy-nvim # for everything not in nixpkgs
    ] ++ finalAppend.plugins;

    extraPackages = [
      # pkgs.dhall-lsp-server broken
      pkgs.nil
      pkgs.java-language-server
      pkgs.ripgrep
      pkgs.pyright
      pkgs.vscode-langservers-extracted
      pkgs.nodePackages.bash-language-server
    ] ++ finalAppend.extraPackages;

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

