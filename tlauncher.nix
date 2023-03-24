{ stdenv, fetchurl, jre }:
stdenv.mkDerivation rec {
  name = "tlauncher-${version}";
  version = "2.879";

  src = fetchurl {
    url = "https://securerepository.net/client/TLauncher-${version}_pre.jar";
    sha256 = "efa9101cf30d0ea26336a2b54ea5e03b3df1f04525f28d1ea0655961ae279c8b";
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

# https://repo.tlauncher.org/update/lch/update_test_master_2.0.json
