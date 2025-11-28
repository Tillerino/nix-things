bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^H' backward-kill-word
bindkey '5~' kill-word

# Zoxide
eval "$(zoxide init --cmd cd zsh)"

# General
function wh() { readlink -f $(which $@) }


# FIO
function ,fio-randwrite() {
( set -x; fio --name TEST --eta-newline=5s --rw=randwrite --size=500m --io_size=10g --blocksize=4k --ioengine=libaio --fsync=1 --iodepth=1 --direct=1 --numjobs=1 --runtime=60 --group_reporting --filename=$1 )
}

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
  MVN=$(if command -v mvnd > /dev/null; then echo mvnd; else echo mvn; fi)
  M2_REPO=$($MVN help:evaluate -Dexpression=settings.localRepository -q -DforceStdout)
  for f in $(find . -maxdepth 3 -name ".classpath"); do
    echo $f
    perl -pi -e 's,excluding="\*\*",,g' $f
    dir=$(dirname $f)
    fp=$dir/.factorypath
    if [ -f $fp ]; then
      echo FACTORYPATH $fp
      DEPS=$($MVN -N dependency:build-classpath -DincludeScope=compile -f $dir | grep -P "^/")
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

function ,mvn-install-spotless-pre-commit-hook() {
  if [ -f .git/hooks/pre-commit ]; then
    echo "pre-commit hook already exists:"

    diff -q ~/git/nix-things/files/git-mvn-spotless-pre-commit-hook .git/hooks/pre-commit
    if [ $? -eq 0 ]; then
      echo "pre-commit hook is already installed"
      return
    fi

    cat .git/hooks/pre-commit
    echo "Do you want to override it? (y/n)"
    read -r answer
    if [ "$answer" != "y" ]; then
      echo "Aborting"
      return
    fi
    rm .git/hooks/pre-commit
  fi
}

function github-keys() {
  curl https://github.com/$@.keys;
}

function ,ssh-impatient() {
  while ! ssh $@ ; do sleep 1; done
}
