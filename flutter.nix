#https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.3.0-stable.tar.xz

{ stdenv }:

stdenv.mkDerivation rec {
  name    = "flutter-${version}";
  version = "3.3.0";

  src = fetchTarball {
    url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${version}-stable.tar.xz";
    sha256 = "610c5fc08d0137c5270cefd14623120ab10cd81b9f48e43093893ac8d00484c9";
  };

  phases = "installPhase";

  installPhase = ''
  '';
}