let
  nixpkgs-src = (import ./nixpkgs-src.nix).stable;
  pkgs = import nixpkgs-src {};
in
pkgs.mkShell {
  buildInputs = [
    pkgs.nixops
    pkgs.nix
  ];
  shellHook = ''
    export NIX_PATH="nixpkgs=${nixpkgs-src}:."
    export SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt
  '';
}