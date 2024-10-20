{ pkgs, append ? { } }:

let finalAppend = { shellAliases = { }; initExtra = ""; } // append;

in

{
    enable = true;

    shellAliases = {
      # General
      l = "ls -lA";
      uuid = "cat /proc/sys/kernel/random/uuid";
      powertop = "nix-shell -p powertop --run 'sudo powertop'";
      s-tui = "nix-shell -p s-tui --run 'sudo s-tui'";
      bandwhich = "nix-shell -p bandwhich --run 'sudo bandwhich'";
      geekbench = "nix-shell -p geekbench --run geekbench6";
      resurrect-history = ''{ l=""; for f in ~/.local/share/tmux/resurrect/*.txt.post; do if [[ "$l" != "" ]]; then echo; echo ------------; echo $(basename $l) $(basename $f); echo ------------; diff $l $f; fi; l=$f; done } | less'';
      resurrect-diff = ''for f in ~/.local/share/tmux/resurrect/*.txt.post; do f1=$f2; f2=$f; done; nvim -d $f1 ~/.local/share/tmux/resurrect/last'';

      # Nix
      edit-home-manager-config-and-reload = "home-manager edit && home-manager switch";
      update-nix-packages = "nix-channel --update && home-manager switch";

      # Java
      java8 = "export JAVA_HOME=$HOME/jdks/openjdk8";
      java11 = "export JAVA_HOME=$HOME/jdks/openjdk11";
      java17 = "export JAVA_HOME=$HOME/jdks/openjdk17";
      java19 = "export JAVA_HOME=$HOME/jdks/openjdk19";
      java21 = "export JAVA_HOME=$HOME/jdks/openjdk21";

      # Maven
      mcis = "mvn clean javadoc:jar source:jar install -DskipTests -Djacoco.skip=true";
      mvn-next-patch-snapshot = "mvn build-helper:parse-version versions:set -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion}-SNAPSHOT versions:commit";
      mvn-next-minor-snapshot = "mvn build-helper:parse-version versions:set -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.nextMinorVersion}.0-SNAPSHOT versions:commit";

      # Python
      venv = ''if [ ! -d .venv ]; then
          python3 -m venv .venv
          echo 'export PYTHONPATH=""' >> .venv/bin/activate
        fi
        source .venv/bin/activate
        if [ -f requirements.txt ]; then
          pip3 install -r requirements.txt
        fi
        '';

      # Git
      gt = "git log --graph --all --oneline";
      gpo = "git push origin";
      gcd = "git checkout --detach";

      # Docker
      docker-remove-testcontainers = "docker rmi $(docker images | grep testcontainers | awk '{ print $3; }')";

      # Sound
      scarlett-mixer = ''nix-shell -p alsa-scarlett-gui --run "alsa-scarlett-gui"'';

      dump-gnome = "dconf dump / > ~/git/nix-things/files/gnome.conf";
      setup-gnome = "dconf load / < ~/git/nix-things/files/gnome.conf";

      dump-cinnamon = "dconf dump /org/cinnamon/ > ~/git/nix-things/files/cinnamon.conf";
      setup-cinnamon = "dconf load /org/cinnamon/ < ~/git/nix-things/files/cinnamon.conf";
      restart-cinnamon = ''pkill -HUP -f "cinnamon --replace"; echo run cinnamon --replace if this did not work. Go Ctrl-Alt-Esc to restart Cinnamon while you are in the UI.'';

      restart-kde-plasma = "systemctl --user restart plasma-plasmashell";

      dump-eclipse-workspace = ''clear; for f in $(find -name "*.prefs"); do echo; echo mkdir -p $(dirname $f); echo cat "<<EOT >> $f"; cat $f; echo "EOT"; echo; done'';
      setup-eclipse-workspace = ''${../scripts/setup-eclipse-workspace.sh}'';
    } // finalAppend.shellAliases;

    plugins = [
      {
        name = "powerlevel10k";
        src = ./p10k;
        file = "p10k.zsh";
      }
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
    ];

    oh-my-zsh = {
      enable = true;
      # if the git thing is slow for a repo, disable it selectively with
      # git config oh-my-zsh.hide-dirty 1
      plugins = [
        "git"
        "thefuck"
      ];
      extraConfig = ''
        # Display red dots whilst waiting for completion.
        COMPLETION_WAITING_DOTS="true"
      '';
    };

    initExtra = (builtins.readFile ./zsh-init-extra.sh) + finalAppend.initExtra;
}
