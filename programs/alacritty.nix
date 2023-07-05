{ pkgs, package ? pkgs.alacritty } :

{
  enable = true;
  package = package;

  settings = {
    font =  {
      normal = { family = "IBM Plex Mono"; weight = 150; }; # weight not working?
      bold.family = "IBM Plex Mono";
      italic.family = "IBM Plex Mono";
      size = 16.0;
    };
    window.dimensions = {
      columns = 120;
      lines = 40;
    };
  };
}
