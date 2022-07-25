{ lib, stdenv, fetchurl, unzip, makeWrapper
, cairo, fontconfig, freetype, gdk-pixbuf, glib
, glibc, gtk2, libX11, nspr, nss, pango
, libxcb, libXi, libXrender, libXext, dbus
, testers, chromedriver, brave
}:

let
  libs = lib.makeLibraryPath [
    stdenv.cc.cc.lib
    cairo fontconfig freetype
    gdk-pixbuf glib gtk2
    libX11 nspr nss pango libXrender
    libxcb libXext libXi
    dbus
  ];

in stdenv.mkDerivation rec {
  pname = "chromedriver";
  version = "1.0";

  src = fetchurl {
    url = "https://chromedriver.storage.googleapis.com/101.0.4951.41/chromedriver_linux64.zip";
    sha256 = "sha256-mVEbVBAs9SqyK/XcxaRsSnXZ7UyisdBrmaAGeCozUH8=";
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  unpackPhase = "unzip $src";

  installPhase = ''
    install -m755 -D chromedriver $out/bin/chromedriver
  '' + lib.optionalString (!stdenv.isDarwin) ''
    patchelf --set-interpreter ${glibc.out}/lib/ld-linux-x86-64.so.2 $out/bin/chromedriver
    wrapProgram "$out/bin/chromedriver" --prefix LD_LIBRARY_PATH : "${libs}"
  '';
}