{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "nixgl-alacritty";
  version = pkgs.alacritty.version;
  src = pkgs.alacritty;
  buildPhase = ''
    mkdir -p $out 
    cp -r * $out
  '';
  patches = [ ./nixGL.patch ];
  postPatch = "env; cat $src/share/applications/Alacritty.desktop; cat share/applications/Alacritty.desktop; ";
}
