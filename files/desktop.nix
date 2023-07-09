{ pkgs, homeDirectory, config }:

{
    ".local/share/applications".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/.nix-profile/share/applications";
    ".local/share/icons".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/.nix-profile/share/icons";
}
