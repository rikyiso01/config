{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
  name = "carbonyl-${version}";
  version = "0.0.3";

  src = fetchzip {
    url = "https://registry.npmjs.org/@fathyb/carbonyl-linux-amd64/-/carbonyl-linux-amd64-0.0.3-next.ab80a27.tgz";
    sha256 = "sha256-TUE7r3pV3pgBJs3H5CbdsTShHWi5KbF1/zZVJex3B7M=";
  };

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${src}/build/carbonyl $out/bin
  '';
}

# npm view @fathyb/carbonyl-linux-amd64@next dist.tarball

