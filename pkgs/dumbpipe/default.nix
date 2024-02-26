{ lib, fetchFromGitHub, rustPlatform }:

let v = "0.4.0";

in

rustPlatform.buildRustPackage rec {
  pname = "dumbpipe";
  version = v;

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "v" + version;
    hash = "sha256-5smJ7dRYmok1LxQQRsnET8GIeKXBqnUAraqxorHDxKI=";
  };

#  cargoHash = "sha256-iV2LvimETUBkyNV5gn5cysr10JpwhDW7TE154dh0WKs=";
# hash is not working until this has propagated:
# https://github.com/khonsulabs/watchable/issues/1
  cargoLock = {
    lockFile = ./Cargo.lock;
  };
  doCheck = false;

  meta = with lib; {
    description = "This is an example to use iroh-net to create a dumb pipe to connect two machines with a QUIC connection.";
    homepage = "https://www.dumbpipe.dev/";
    license = licenses.asl20;
    maintainers = [];
  };
}

