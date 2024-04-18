bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^H' backward-kill-word
bindkey '5~' kill-word

# Zoxide
eval "$(zoxide init --cmd cd zsh)"

# General
function wh() { readlink -f $(which $@) }

# Desktop
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

# Git
function gitFetchDetachOriginMaster() { git fetch origin; git checkout --detach origin/master; }

# Eclipse
function fixEclipse() {
  M2_REPO=$(mvn help:evaluate -Dexpression=settings.localRepository -q -DforceStdout)
  for f in $(find . -maxdepth 3 -name ".classpath"); do
    echo $f
    perl -pi -e 's,excluding="\*\*",,g' $f
    dir=$(dirname $f)
    fp=$dir/.factorypath
    if [ -f $fp ]; then
      echo FACTORYPATH $fp
      DEPS=$(mvn -N dependency:build-classpath -DincludeScope=compile -f $dir | grep -P "^/")
      echo '<factorypath>' > $fp
      for jar in ${(@s/:/)DEPS}; do
        rel=$(realpath --relative-to=$M2_REPO $jar)
        echo '<factorypathentry kind="VARJAR"' id=\"M2_REPO/$rel\" 'enabled="true" runInBatchMode="false"/>' >> $fp
      done
      echo '</factorypath>' >> $fp
    fi
  done;
}

# Nix
function nix-grep() { grep -R $@ ~/git/nixpkgs/pkgs }

# Maven
function mgo() { mvn dependency:go-offline $@ && mvn dependency:sources; mvn dependency:resolve -Dclassifier=javadoc $@ }
function mgo-all() { for f in */; do echo $f; mgo -f $f; done }
function grep-pom() { grep -R --include "pom.xml" $@ }

function mt() {
  # -DfailIfNoTests=false because of multi-module projects
  mvn test -DfailIfNoTests=false -Dsurefire.failIfNoSpecifiedTests=false -Djacoco.skip=true -Dtest=$@
}
function _mt() {
  compadd $(find . -name "*Test.java" | grep -o -P "[A-Z][^\.]+")
}
compdef _mt mt

function github-keys() {
  curl https://github.com/$@.keys;
}
