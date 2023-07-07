{ pkgs } :
{
  service = {
    Service = {
      ExecStart = pkgs.writeShellScript "git-fetch-all.sh" ''
        #!/usr/bin/env bash
        for f in $(find ~/git -maxdepth 3 -name .git -type d); do
	  echo $f
	  cd $f/..
	  pwd
	  git fetch --all
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
