# These go into .nix-profile/etc/profile.d/hm-session-vars.sh
# Log back in to reload!
{ config } : {
  EDITOR = "nvim";
  MAVEN_OPTS = "-Daether.dependencyCollector.impl=bf";
  LESS = "--mouse";
}
