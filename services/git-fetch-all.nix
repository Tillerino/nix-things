{ pkgs } :
{
  service = {
    Service = {
      ExecStart = pkgs.writeShellScript "git-fetch-all.sh" ''
        #!/usr/bin/env bash
        for f in $(find ~/git -maxdepth 3 -name .git -type d); do
          cd $f/..
          pwd
          git fetch --all
          if git branch --no-color | grep "HEAD detached"; then
            git merge-base --is-ancestor HEAD origin/master && git checkout --detach origin/master
          else
            git pull -q --ff-only
          fi
        done
      '';
    };
  };

  timer = {
    Install = { WantedBy = [ "timers.target" ]; };
    Timer = {
      OnBootSec = "5m";
      OnUnitInactiveSec = "5m";
      Unit = "git-fetch-all.service";
    };
  };
}
