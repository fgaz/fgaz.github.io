with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "fgaz.me";
  src = ./.;
  nativeBuildInputs = [ zola ];
  buildPhase = "zola build";
  installPhase = "cp -r public $out";
}
