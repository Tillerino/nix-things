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
    general.import = [ "${melange}/term/alacritty/melange_light.toml" ];
    font =  {
      normal = { family = "IBM Plex Mono"; }; # weight not working?
      bold.family = "IBM Plex Mono";
      italic.family = "IBM Plex Mono";
      size = 12.0;
    };
    window.dimensions = {
      columns = 120;
      lines = 40;
    };
    hints.enabled = [
      {
        # from https://youtu.be/6iHgfXzjx9M?t=491
        command = "xdg-open";
        hyperlinks = true;
        post_processing = true;
        persist = false;
        mouse.enabled = true;
        binding = { key = "1"; mods = "Control"; };
        regex = "(ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\\u0000-\\u001F\\u007F-\\u009F<>\"\\\\s{-}\\\\^⟨⟩`]+";
      }
      {
        # from https://youtu.be/6iHgfXzjx9M?t=491
        regex = "[^ ]+(?:\\\\s*)$";
        command = {
          program = "${pkgs.tmux}/bin/tmux";
          args = ["split-window" "-h" "-c" "#{pane_current_path}" "sh" "-c" "nvim \"$0\"" ]; 
        };
        binding = { key = "2"; mods = "Control"; };
      }
    ];
  };
}
