# https://github.com/nix-community/home-manager/blob/master/modules/programs/alacritty.nix

{ pkgs, package ? pkgs.alacritty } :

let melange = pkgs.fetchFromGitHub {
  owner = "savq";
  repo = "melange-nvim";
  rev = "e84f8bc2abc5d6edaa7bd48a16c3078504ecb713";
  hash = "sha256-/i5gKjsAv/k6E9zF3+JwfF/4p+eat8z7b00SFSPoumQ=";
};

in {
  enable = true;
  package = package;

  settings = {
    import = [ "${melange}/term/alacritty/melange_light.toml" ];
    font =  {
      normal = { family = "IBM Plex Mono"; }; # weight not working?
      bold.family = "IBM Plex Mono";
      italic.family = "IBM Plex Mono";
      size = 14.0;
    };
    window.dimensions = {
      columns = 120;
      lines = 40;
    };
  };
}
