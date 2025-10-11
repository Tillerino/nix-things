{ pkgs, append ? { } }:

let finalAppend = { shellAliases = { }; initExtra = ""; } // append;

in

{
    enable = true;

    dotDir = ".config/zsh";

    shellAliases = {
      # General
      l = "ls -lA";
      ",uuid" = "cat /proc/sys/kernel/random/uuid";
      ",powertop" = "nix-shell -p powertop --run 'sudo powertop'";
      ",s-tui" = "nix-shell -p s-tui --run 'sudo s-tui'";
      ",geekbench" = "nix-shell -p geekbench --run geekbench6";
      ",tmux-resurrect-history" = ''{ l=""; for f in ~/.local/share/tmux/resurrect/*.txt.post; do if [[ "$l" != "" ]]; then echo; echo ------------; echo $(basename $l) $(basename $f); echo ------------; diff $l $f; fi; l=$f; done } | less'';
      ",tmux-resurrect-diff" = ''for f in ~/.local/share/tmux/resurrect/*.txt.post; do f1=$f2; f2=$f; done; nvim -d $f1 ~/.local/share/tmux/resurrect/last'';
      ",xdg-ninja" = "nix --experimental-features 'nix-command flakes' run github:b3nj5m1n/xdg-ninja";

      # systemd
      ",systemctl-deps" = "systemctl show -p Requires,Wants,Requisite,BindsTo,PartOf,Before,After";
      ",journalctl-since-boot" = "sudo journalctl --boot --lines=all --output with-unit";
      ",journalctl-previous-boot" = "sudo journalctl -b-1 --lines=all --output with-unit";
      ",systemd-fix-rootless-docker" = "rm ~/.config/systemd/user/docker.service && systemctl --user enable docker.service && systemctl --user start docker.service";

      # Network
      ",net-list-connections" = "sudo lsof -i -P -n";
      ",net-bandwhich" = "nix-shell -p bandwhich --run 'sudo bandwhich'";

      # Disks
      ",disk-power-status" = "sudo hdparm -C /dev/sd[a-z]";
      ",disk-power-standby" = "sudo hdparm -y /dev/sd[a-z]";

      # Java
      ",java8" = "export JAVA_HOME=$HOME/jdks/openjdk8";
      ",java11" = "export JAVA_HOME=$HOME/jdks/openjdk11";
      ",java17" = "export JAVA_HOME=$HOME/jdks/openjdk17";
      ",java19" = "export JAVA_HOME=$HOME/jdks/openjdk19";
      ",java21" = "export JAVA_HOME=$HOME/jdks/openjdk21";
      ",java23" = "export JAVA_HOME=$HOME/jdks/openjdk23";

      # Maven
      ",mcis" = "mvn clean javadoc:jar source:jar install -DskipTests -Djacoco.skip=true";
      ",mvn-next-patch-snapshot" = "mvn build-helper:parse-version versions:set -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion}-SNAPSHOT versions:commit";
      ",mvn-next-minor-snapshot" = "mvn build-helper:parse-version versions:set -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.nextMinorVersion}.0-SNAPSHOT versions:commit";

      # Python
      ",venv" = ''if [ ! -d .venv ]; then
          python3 -m venv .venv
          echo 'export PYTHONPATH=""' >> .venv/bin/activate
        fi
        source .venv/bin/activate
        if [ -f requirements.txt ]; then
          pip3 install -r requirements.txt
        fi
        '';

      # Git
      ",gt" = "git log --graph --all --oneline";
      ",gpo" = "git push origin";
      ",gcd" = "git checkout --detach";
      ",setup-git" = "${../scripts/setup-git.sh}";

      # Docker
      ",docker-remove-testcontainers" = "docker rmi $(docker images | grep testcontainers | awk '{ print $3; }')";

      # Sound
      ",scarlett-mixer" = ''nix-shell -p alsa-scarlett-gui --run "alsa-scarlett-gui"'';

      # LLMs
      ",llama-cpp-code-server" = ''llama-server \
        -hf ggml-org/Qwen2.5-Coder-3B-Q8_0-GGUF \
        --port 8012 -ngl 99 -fa -ub 1024 -b 1024 \
        --ctx-size 0 --cache-reuse 256'';

      ",dump-gnome" = "dconf dump / > ~/git/nix-things/files/gnome.conf";
      ",setup-gnome" = "dconf load / < ~/git/nix-things/files/gnome.conf";

      ",dump-cinnamon" = "dconf dump /org/cinnamon/ > ~/git/nix-things/files/cinnamon.conf";
      ",setup-cinnamon" = "dconf load /org/cinnamon/ < ~/git/nix-things/files/cinnamon.conf";
      ",restart-cinnamon" = ''pkill -HUP -f "cinnamon --replace"; echo run cinnamon --replace if this did not work. Go Ctrl-Alt-Esc to restart Cinnamon while you are in the UI.'';

      # KDE
      ",restart-kde-plasma" = "systemctl --user restart plasma-plasmashell";
      ",kde-diff-globalshortcuts" = "nvim -d ~/.config/kglobalshortcutsrc ~/git/nix-things/files/kglobalshortcutsrc";

      ",dump-eclipse-workspace" = ''clear; for f in $(find -name "*.prefs"); do echo; echo mkdir -p $(dirname $f); echo cat "<<EOT >> $f"; cat $f; echo "EOT"; echo; done'';
      ",setup-eclipse-workspace" = ''${../scripts/setup-eclipse-workspace.sh}'';
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

    initContent = (builtins.readFile ./zsh-init-extra.sh) + finalAppend.initExtra;
}
