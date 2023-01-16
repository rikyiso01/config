{ stdenv, fetchurl, jre }:
stdenv.mkDerivation rec {
  name = "tlauncher-${version}";
  version = "2.871";

  src = fetchurl {
    url = "https://securerepository.net/client/TLauncher-${version}.jar";
    sha256 = "sha256-NEPJ5yjtHUGwyOUornkGsOBzo2tOodjQwkjYJxBzC7o=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/applications
    echo '[Desktop Entry]
    Encoding=UTF-8
    Version=1.0
    Type=Application
    Terminal=false
    Exec=${jre}/bin/java -jar ${src}
    Name=TLauncher
    Icon=${fetchurl {url = "https://tlauncher.org/favicon-196x196.png"; sha256 = "sha256-9z68qIwp/UhWKkDF+vv8wUm01PAvr+SkvKj9prPjWyw=";}}
    ' > $out/share/applications/org.tlauncher.TLauncher.desktop
  '';
}
