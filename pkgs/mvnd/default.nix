{ fetchFromGitHub, maven, graalvmCEPackages, lib }:

maven.buildMavenPackage rec {
  pname = "mvnd";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "maven-mvnd";
    rev = version;
    hash = "sha256-c1jD7m4cOdPWQEoaUMcNap2zvvX7H9VaWQv8JSgAnRU=";
  };

  mvnHash = "sha256-Bx0XSnpHNxNX07uVPc18py9qbnG5b3b7J4vs44ty034=";

  #buildOffline = true;
  mvnJdk = graalvmCEPackages.graalvm-ce;
  mvnDepsParameters = mvnParameters;

  mvnParameters = lib.concatStringsSep " " [
    "-Dmaven.buildNumber.skip=true" # skip build number generation; requires a git repository
    "-Drat.skip=true" # skip license checks; they require manaul approval and should have already been run upstream
    "-Dspotless.skip=true" # skip formatting checks

    # skip tests that fail in the sandbox
    "-pl"
    "!integration-tests"
    "-Dtest=!org.mvndaemon.mvnd.client.OsUtilsTest,!org.mvndaemon.mvnd.cache.impl.CacheFactoryTest"
    "-Dsurefire.failIfNoSpecifiedTests=false"

    "-Pnative"
    # propagate linker args required by the darwin build
    # see `buildGraalvmNativeImage`
    ''-Dgraalvm-native-static-opt="-H:-CheckToolchain $(export -p | sed -n 's/^declare -x \([^=]\+\)=.*$/ -E\1/p' | tr -d \\n)"''
  ];

  nativeBuildInputs = [ graalvmCEPackages.graalvm-ce ];

  installPhase = ''
    mkdir -p $out/mvnd
    mkdir -p $out/bin
    cp -r dist/target/maven-mvnd-$version-linux-amd64/. $out/mvnd
    ln -s $out/mvnd/bin/mvnd $out/bin/mvnd

    runHook postInstall
  '';
}
