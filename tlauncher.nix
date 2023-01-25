{ stdenv, fetchurl, jre }:
stdenv.mkDerivation rec {
  name = "tlauncher-${version}";
  version = "2.873";

  src = fetchurl {
    url = "https://securerepository.net/client/TLauncher-${version}_pre.jar";
    sha256 = "sha256-OLQ0M2uWh6M3/82ciJ7OZr8PS7WgWmu8sT6KqNcj3dE=";
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

# https://repo.tlauncher.org/update/lch/update_2.0.json
