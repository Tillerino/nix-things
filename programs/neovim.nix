{ pkgs, append ? { } }:

let finalAppend = { plugins = [ ]; extraPackages = [ ]; extraConfig = ""; extraLuaConfig = ""; } // append;

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
      pkgs.vimPlugins.undotree
      pkgs.vimPlugins.fugitive
      pkgs.vimPlugins.guess-indent-nvim
      pkgs.vimPlugins.luasnip
    ] ++ finalAppend.plugins;

    extraPackages = [
      # pkgs.dhall-lsp-server broken
      pkgs.nil
      pkgs.java-language-server
      pkgs.ripgrep
      pkgs.nodePackages.pyright
      pkgs.vscode-langservers-extracted
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
      dofile('${./neovim.lua}')
    '' + finalAppend.extraLuaConfig;
}

