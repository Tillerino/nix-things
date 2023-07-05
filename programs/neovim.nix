{ pkgs }:

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
    ];

    extraPackages = [
      pkgs.dhall-lsp-server
      pkgs.nil
    ];

    extraConfig = ''
      '';

    extraLuaConfig = "dofile('${./neovim.lua}')";
}

