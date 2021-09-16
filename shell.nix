with import <nixpkgs> {};
mkShell {
  inputsFrom = [ rubyPackages.github-pages ];
  nativeBuildInputs = [ bash cacert curl ghostscript gnumake imagemagick libarchive poppler_utils sile yq ];
}
