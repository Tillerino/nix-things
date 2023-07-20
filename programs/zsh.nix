{ pkgs, append ? { } }:

let finalAppend = { shellAliases = { }; initExtra = ""; } // append;

in

{
    enable = true;

    shellAliases = {
      # General
      l = "ls -la";

      # Nix
      edit-home-manager-config-and-reload = "home-manager edit && home-manager switch";
      update-nix-packages = "nix-channel --update && home-manager switch";

      # Java
      java8 = "export JAVA_HOME=$HOME/jdks/openjdk8";
      java11 = "export JAVA_HOME=$HOME/jdks/openjdk11";
      java17 = "export JAVA_HOME=$HOME/jdks/openjdk17";
      java19 = "export JAVA_HOME=$HOME/jdks/openjdk19";
      mcis = "mvn clean javadoc:jar source:jar install -DskipTests -Djacoco.skip=true";

      # Git
      gt = "git log --graph --all --oneline";
      gpo = "git push origin";
      gcd = "git checkout --detach";
    } // finalAppend.shellAliases;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "robbyrussell";
    };

    initExtra = ''
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^H' backward-kill-word
      bindkey '5~' kill-word

      function wh() { readlink -f $(which $@) }

      function checkMouseWakeup() {
        (
          cd /sys/bus/usb/devices
          for i in $(grep Mouse */product | grep -o -P "^[^/]+"); do
            grep enabled $i/power/wakeup && \
              echo WARNING Can wake up from sleep from mouse. \
                Run sudo sh -c '"' echo disabled '>' /sys/bus/usb/devices/$i/power/wakeup '"'
          done
        )
      }

      function gitFetchDetachOriginMaster() { git fetch origin; git checkout --detach origin/master; }
      function fixEclipse() { for f in $(find . -maxdepth 3 -name ".classpath"); do echo $f; perl -pi -e 's,excluding="\*\*",,g' $f; done; }
      function nix-grep() { grep -R $@ ~/git/nixpkgs/pkgs }
      function grep-pom() { grep -R --include "pom.xml" $@ }
      function ssh() { echo -e '\e]11;rgb:33/00/00\a'; command ssh $@; echo -e '\e]11;rgb:00/00/00\a'; }

      # Maven
      function mgo() { mvn dependency:go-offline $@ && mvn dependency:sources; mvn dependency:resolve -Dclassifier=javadoc $@ }
      function mgo-all() { for f in *; do echo $f; mgo -f $f; done }
      function mt() {
        # -DfailIfNoTests=false because of multi-module projects
        mvn test -DfailIfNoTests=false -Dsurefire.failIfNoSpecifiedTests=false -Djacoco.skip=true -Dtest=$@
      }
      function _mt() {
        compadd $(find . -name "*Test.java" | grep -o -P "[A-Z][^\.]+")
      }
      compdef _mt mt
    '' + finalAppend.initExtra;
}
