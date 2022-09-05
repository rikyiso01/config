{ stdenv }:
stdenv.mkDerivation rec {
  name    = "downloadhelper-${version}";
  version = "1.6.3";

  src = fetchTarball {
    url = "https://github.com/mi-g/vdhcoapp/releases/download/v${version}/net.downloadhelper.coapp-${version}-1_amd64.tar.gz";
    sha256 = "sha256:0kjwagwql3b6im4hmr83jjyx8ngwg0rc49xx47vkvislbfybby18";
  };

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    install -Dm555 -t $out/bin bin/net.downloadhelper.coapp-linux-64
  '';
}