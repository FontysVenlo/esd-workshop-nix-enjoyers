{
  description = "Templates for ESD Nix Workshop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  {
    templates = {
      golang = {
        path = ./golang-flake-template/template;
        description = "Golang template";
      };
      default = self.templates.golang;
    };
  };
}
