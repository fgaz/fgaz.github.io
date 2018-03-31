with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "fgaz.me";
  src = ./.;
  nativeBuildInputs = [ (jekyll.override (old: { withOptionalDependencies = true; }) ) ];
  buildPhase = "jekyll build";
  installPhase = "cp -r _site $out";
}
