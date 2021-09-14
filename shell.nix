with import <nixpkgs> {};
mkShell {
  inputsFrom = [ rubyPackages.github-pages ];
  nativeBuildInputs = [ bash cacert curl ghostscript gnumake imagemagick libarachive sile yq ];
}
