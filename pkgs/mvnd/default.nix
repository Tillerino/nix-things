{ fetchFromGitHub, maven, graalvmCEPackages }:

maven.buildMavenPackage rec {
  pname = "mvnd";
  version = "mvnd-1.x";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "maven-mvnd";
    rev = "42e5786701308968e312e335354deffa17f3ce4b";
    hash = "sha256-61dYN9jhxOYbyGWD8n6Gm7hLX5I8P8BbURBs5HvuBRk=";
  };

  mvnHash = "sha256-5UAk5YDczKqV2OLbkF6buIp2LwW0ye9yH/S+PMN40cM=";

  buildOffline = true;
  mvnDepsParameters = "-B -Pnative de.qaware.maven:go-offline-maven-plugin:1.2.8:resolve-dependencies -DdownloadSources";
  manualMvnArtifacts = [
    "org.apache.apache.resources:apache-jar-resource-bundle:1.5"
    "org.apache.maven:apache-maven:3.9.7:tar.gz:bin"
    "org.apache.maven:maven-slf4j-provider:3.9.7:jar:sources"
  ];

  mvnParameters = "-B -Pnative -DskipTests=true -Dmaven.buildNumber.skip=true -Drat.skip=true -Denforcer.skip=true -Dspotless.skip=true";

  nativeBuildInputs = [ graalvmCEPackages.graalvm-ce ];

  installPhase = ''
    mkdir -p $out/mvnd
    mkdir -p $out/bin
    cp -r dist/target/maven-mvnd-1.0-m9-SNAPSHOT-linux-amd64/. $out/mvnd
    ln -s $out/mvnd/bin/mvnd $out/bin/mvnd

    runHook postInstall
  '';
}
