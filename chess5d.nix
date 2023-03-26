{ stdenv }:
stdenv.mkDerivation rec {
  name = "5dchesswithmultiversetimetravel-${version}";
  version = "1.1.0";

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/share/applications
    echo '[Desktop Entry]
    Encoding=UTF-8
    Version=1.0
    Type=Application
    Terminal=false
    Exec=/home/riky/Games/5dchesswithmultiversetimetravel/5dchesswithmultiversetimetravel
    Name=5D Chess With Multiverse Time Travel
    Icon=/home/riky/Games/5dchesswithmultiversetimetravel/5dchesswithmultiversetimetravel.png
    ' > $out/share/applications/net.chessin5d.desktop
  '';
}
