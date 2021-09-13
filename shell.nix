with import <nixpkgs> {};
mkShell {
  inputsFrom = [ rubyPackages.github-pages ];
  nativeBuildInputs = [ bash gentium ghostscript gnumake imagemagick sile ];
}
