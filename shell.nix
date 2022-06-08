{ nixpkgs ? import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) {} }:
with nixpkgs;
mkShell {
  inputsFrom = [ rubyPackages.github-pages ];
  nativeBuildInputs = [ bash cacert curl ghostscript gnumake imagemagick libarchive poppler_utils sile yq ];
}
