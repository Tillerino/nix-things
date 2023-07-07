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
      pkgs.vimPlugins.copilot-vim # set up with :Copilot setup
    ];

    extraPackages = [
      pkgs.dhall-lsp-server
      pkgs.nil
      pkgs.java-language-server
    ];

    extraConfig = ''
      '';

    extraLuaConfig = "dofile('${./neovim.lua}')";
}

