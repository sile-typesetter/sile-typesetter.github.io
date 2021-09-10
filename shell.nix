with import <nixpkgs> {};

let
  env = bundlerEnv {
    name = "sile-typesetter.org";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

in stdenvNoCC.mkDerivation {
  name = "sile-typesetter.org";
  buildInputs = [ env ruby ];
  nativeBuildInputs = [ bash sile ];
}
