{
  description = "General Python project template with Nix flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = builtins.currentSystem;
      pkgs = import nixpkgs { inherit system; };

      # Pick the Python version you want
      python = pkgs.python311;

      # Define your Python environment with deps
      pythonEnv = python.withPackages (ps: with ps; [
        requests
        numpy
        # flask
        # fastapi
        # jinja2
        # add more here as needed
      ]);
    in {
      # Development environment
      devShells.default = pkgs.mkShell {
        buildInputs = [ pythonEnv ];
      };

      # Package definition
      packages.default = pkgs.buildPythonApplication {
        pname = "my-python-app";
        version = "0.1.0";
        src = ./.;
        propagatedBuildInputs = [
          requests
          numpy
        ];
      };

      # Run your app via `nix run`
      apps.default = {
        type = "app";
        program = "${pythonEnv}/bin/python ./main.py";
      };
    };
}