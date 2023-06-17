{ stdenv, docker-compose }:
stdenv.mkDerivation rec {
  name = "podmandocker-${version}";
  version = "0.1.0";
  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    echo '#!/usr/bin/env bash
    set -eo pipefail
    if [[ $1 == "compose" ]]; then
        shift
        exec ${docker-compose}/bin/docker-compose "$@"
    else
        exec podman "$@"
    fi' > $out/bin/docker
    chmod +x $out/bin/docker
  '';
}
