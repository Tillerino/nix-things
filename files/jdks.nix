{ pkgs }:

{
    "jdks/openjdk8".source = "${pkgs.openjdk8}/lib/openjdk";
    "jdks/openjdk11".source = "${pkgs.openjdk11}/lib/openjdk";
    "jdks/openjdk17".source = "${pkgs.openjdk17}/lib/openjdk";

    ".m2/toolchains.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?><toolchains>
        <toolchain>
          <type>jdk</type><provides><version>1.8</version></provides>
          <configuration><jdkHome>${pkgs.openjdk8}</jdkHome></configuration>
        </toolchain>
      </toolchains>
     '';
}
