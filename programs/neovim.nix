{ pkgs, append ? { } }:

let finalAppend = { plugins = [ ]; extraPackages = [ ]; extraConfig = ""; extraLuaConfig = ""; };

in

{
    enable = true;

    plugins = [
#     pkgs.vimPlugins.wildfire-vim
      pkgs.vimPlugins.lsp-format-nvim
      pkgs.vimPlugins.nvim-lspconfig
      pkgs.vimPlugins.nvim-treesitter
      pkgs.vimPlugins.gruvbox-nvim
      pkgs.vimPlugins.melange-nvim
      pkgs.vimPlugins.telescope-nvim
    ] ++ finalAppend.plugins;

    extraPackages = [
      pkgs.dhall-lsp-server
      pkgs.nil
      pkgs.java-language-server
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
    '' + finalAppend.extraConfig;

    extraLuaConfig = ''
      dofile('${./neovim.lua}')
    '' + finalAppend.extraLuaConfig;
}

