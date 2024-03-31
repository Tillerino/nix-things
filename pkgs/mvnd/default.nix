{ fetchFromGitHub, maven, graalvmCEPackages }:

maven.buildMavenPackage rec {
  pname = "mvnd";
  version = "1.0-m8";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "maven-mvnd";
    rev = "${version}";
    hash = "sha256-tC1nN81aimfA0CWQAU6J/QEXO2mmSQln+dkiB2jyqfI=";
  };

  mvnHash = "sha256-duqKRgU8ubcIxYskHxZMv7sE+h3l5VgMvdIDsNu44Io=";

  buildOffline = true;
  mvnDepsParameters = "-B -Pnative";
  manualMvnArtifacts = [
    "org.codehaus.mojo:extra-enforcer-rules:1.7.0"
    "org.apache.groovy:groovy-all:4.0.13:pom"
    "org.apache.maven.shared:maven-shared-resources:5"
    "org.apache.apache.resources:apache-jar-resource-bundle:1.5"
    "org.apache.maven:maven-slf4j-wrapper:4.0.0-alpha-8:jar:sources"
    "org.slf4j:slf4j-simple:1.7.36:jar:sources"
    "com.thoughtworks.xstream:xstream:1.4.20"
    "org.apache.maven:apache-maven:3.9.5:tar.gz:bin"
    "org.apache.maven:apache-maven:4.0.0-alpha-8:tar.gz:bin"
  ];

  mvnParameters = "-B -Pnative -DskipTests=true -Dmaven.buildNumber.skip=true -Drat.skip=true -Denforcer.skip=true -Dspotless.skip=true";

  nativeBuildInputs = [ graalvmCEPackages.graalvm-ce ];

  installPhase = ''
    mkdir -p $out/mvnd
    mkdir -p $out/bin
    cp -r dist-m39/target/maven-mvnd-1.0-m8-m39-linux-amd64/. $out/mvnd
    ln -s $out/mvnd/bin/mvnd $out/bin/mvnd

    runHook postInstall
  '';
}
