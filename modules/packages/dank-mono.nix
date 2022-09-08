{ lib
, pkgs
, fetchzip
, filePath
}:
let
  version = "1.0";
in
pkgs.stdenvNoCC.mkDerivation {
  name = "dank-mono-${version}";
  dontConfigure = true;
  src = filePath;

  nativeBuildInputs = with pkgs; [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp DankMono/OpenType-PS/*.otf $out/share/fonts/opentype
  '';

  meta = {
    description = "Dank Mono fontface";
  };
}
