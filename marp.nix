{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
  name = "marp-${version}";
  version = "2.3.0";

  src = fetchzip {
    url = "https://github.com/marp-team/marp-cli/releases/download/v${version}/marp-cli-v${version}-linux.tar.gz";
    sha256 = "sha256-cA3rV8c52GRNnjM7T3BBnnRvajK4XFlfIicvUWJRcZ0=";
  };

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${src}/marp $out/bin
  '';
}
