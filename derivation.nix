{ pkgs
, stdenv
, flags ? ["-O2"]}:
let
in
stdenv.mkDerivation {
  name = "test";
  src = ./.;

  buildInputs = [ ];
  buildPhase = "${pkgs.bash}/bin/bash ./builder.sh ${flags}";

  installPhase = ''
    mkdir -p $out/bin
  '';
}
