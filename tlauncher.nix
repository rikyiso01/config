{ stdenv, fetchzip, jdk17, steam-run }:
stdenv.mkDerivation rec {
  name    = "tlauncher-${version}";
  version = "2.86";

  src = fetchzip {
    url = "https://dl2.tlauncher.org/f.php?f=files%2FTLauncher-${version}.zip";
    sha256 = "sha256-Tpia/GtPfeO8/Tca0fE7z387FRpkXfS1CtvX/oNJDag=";
    stripRoot=false;
  };

  installPhase = ''
    mkdir -p $out/bin
    echo "
    #!/bin/bash
    exec ${steam-run}/bin/steam-run ${jdk17}/bin/java -jar ${src}/TLauncher-${version}.jar
    " > $out/bin/tlauncher
    chmod 555 $out/bin/tlauncher
  '';
}