{
  description = "TypeScript Nix flake workshop template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        nodejs = pkgs.nodejs_20;
        pnpm = pkgs.nodePackages_latest.pnpm;
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            nodejs
            pnpm
          ];
        };
      });
}