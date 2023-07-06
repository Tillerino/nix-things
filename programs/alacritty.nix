# https://github.com/nix-community/home-manager/blob/master/modules/programs/alacritty.nix

{ pkgs, package ? pkgs.alacritty } :

let melange = pkgs.fetchFromGitHub {
  owner = "savq";
  repo = "melange-nvim";
  rev = "f15922543dd70b360335effb61411c05c710b99c";
  hash = "sha256-Ad6PuVhQY4T5wcW6jV9MkSNRlcOitlfZOrfT38GuXKc=";
};

in {
  enable = true;
  package = package;

  settings = {
    import = [ "${melange}/term/alacritty/melange_light.yml" ];
    font =  {
      normal = { family = "IBM Plex Mono"; weight = 150; }; # weight not working?
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
