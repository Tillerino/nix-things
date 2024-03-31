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

  mvnHash = "sha256-YeFSUj12utA7dNncSa65uMqHSsrPly2aE3n2sI1D8Nk=";

  buildOffline = true;
  mvnDepsParameters = "-B -Pnative de.qaware.maven:go-offline-maven-plugin:1.2.8:resolve-dependencies -DdownloadSources";
  manualMvnArtifacts = [
    "org.apache.apache.resources:apache-jar-resource-bundle:1.5"
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
