{ pkgs, unstable }:

{
    "jdks/openjdk8".source = "${pkgs.openjdk8}/lib/openjdk";
    "jdks/openjdk11".source = "${pkgs.openjdk11}/lib/openjdk";
    "jdks/openjdk17".source = "${pkgs.openjdk17}/lib/openjdk";
    "jdks/openjdk20".source = "${pkgs.openjdk20}/lib/openjdk";
    "jdks/openjdk21".source = "${pkgs.openjdk21}/lib/openjdk";
    "jdks/openjdk22".source = "${pkgs.openjdk22}/lib/openjdk";

    ".m2/toolchains.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?><toolchains>
        <toolchain>
          <type>jdk</type><provides><version>1.8</version></provides>
          <configuration><jdkHome>${pkgs.openjdk8}</jdkHome></configuration>
        </toolchain>
        <toolchain>
          <type>jdk</type><provides><version>11</version></provides>
          <configuration><jdkHome>${pkgs.openjdk11}</jdkHome></configuration>
        </toolchain>
        <toolchain>
          <type>jdk</type><provides><version>17</version></provides>
          <configuration><jdkHome>${pkgs.openjdk17}</jdkHome></configuration>
        </toolchain>
        <toolchain>
          <type>jdk</type><provides><version>21</version></provides>
          <configuration><jdkHome>${pkgs.openjdk21}</jdkHome></configuration>
        </toolchain>
      </toolchains>
     '';
}
