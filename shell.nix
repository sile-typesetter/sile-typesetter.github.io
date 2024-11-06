{
  nixpkgs ? import (fetchTarball "https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz") { },
}:
with nixpkgs;
mkShell {
  nativeBuildInputs = [
    bash
    cacert
    curl
    ghostscript
    git
    gnumake
    imagemagick
    libarchive
    nix
    poppler_utils
    rsync
    sile
    yq
    zola
  ];
}
