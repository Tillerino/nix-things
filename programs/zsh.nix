{ pkgs, append ? { } }:

let finalAppend = { shellAliases = { }; initExtra = ""; } // append;

in

{
    enable = true;

    shellAliases = {
      # General
      l = "ls -la";
      uuid = "cat /proc/sys/kernel/random/uuid";

      # Nix
      edit-home-manager-config-and-reload = "home-manager edit && home-manager switch";
      update-nix-packages = "nix-channel --update && home-manager switch";

      # Java
      java8 = "export JAVA_HOME=$HOME/jdks/openjdk8";
      java11 = "export JAVA_HOME=$HOME/jdks/openjdk11";
      java17 = "export JAVA_HOME=$HOME/jdks/openjdk17";
      java19 = "export JAVA_HOME=$HOME/jdks/openjdk19";
      java21 = "export JAVA_HOME=$HOME/jdks/openjdk21";
      mcis = "mvn clean javadoc:jar source:jar install -DskipTests -Djacoco.skip=true";

      # Git
      gt = "git log --graph --all --oneline";
      gpo = "git push origin";
      gcd = "git checkout --detach";

      # Docker
      docker-remove-testcontainers = "docker rmi $(docker images | grep testcontainers | awk '{ print $3; }')";

      dump-gnome = "dconf dump / > ~/git/nix-things/files/gnome.conf";
      setup-gnome = "dconf load / < ~/git/nix-things/files/gnome.conf";

      dump-cinnamon = "dconf dump /org/cinnamon/ > ~/git/nix-things/files/cinnamon.conf";
      setup-cinnamon = "dconf load /org/cinnamon/ < ~/git/nix-things/files/cinnamon.conf";
      restart-cinnamon = ''pkill -HUP -f "cinnamon --replace"; echo run cinnamon --replace if this did not work. Go Ctrl-Alt-Esc to restart Cinnamon while you are in the UI.'';

      dump-eclipse-workspace = ''clear; for f in $(find -name "*.prefs"); do echo; echo mkdir -p $(dirname $f); echo cat "<<EOT >> $f"; cat $f; echo "EOT"; echo; done'';
      setup-eclipse-workspace = ''${../scripts/setup-eclipse-workspace.sh}'';
    } // finalAppend.shellAliases;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "robbyrussell";
    };

    initExtra = (builtins.readFile ./zsh-init-extra.sh) + finalAppend.initExtra;
}
