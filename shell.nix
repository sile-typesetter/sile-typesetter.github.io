with import <nixpkgs> {};
mkShell {
  inputsFrom = [ rubyPackages.github-pages ];
  nativeBuildInputs = [ bash gentium gnumake sile ];
}
