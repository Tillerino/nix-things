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

      export-gnome-settings = "dconf dump / > ~/git/nix-things/files/gnome.conf";
      import-gnome-settings = "dconf load / < ~/git/nix-things/files/gnome.conf";
    } // finalAppend.shellAliases;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "robbyrussell";
    };

    initExtra = (builtins.readFile ./zsh-init-extra.sh) + finalAppend.initExtra;
}
