{
  description = "General Python project template with Nix flakes";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Select the Python version (edit for required Python version)
        python = pkgs.python310; # Example: pkgs.python311 for Python 3.11

        # Select dependencies for both shell and app/package
        pythonPackages = [
          # pkgs.python310Packages.requests
          # pkgs.python310Packages.numpy
          # pkgs.python310Packages.flask
          # pkgs.python310Packages.fastapi
          # pkgs.python310Packages.jinja2
          # Add more as needed
        ];

        pythonEnv = python.withPackages (ps: pythonPackages);

      in {
        # Development shell: Editable Python code, dependencies available
        devShells.default = pkgs.mkShell {
          buildInputs = [ pythonEnv ];
        };

        # Package output: Makes 'nix build' work
        packages.default = pkgs.python310Packages.buildPythonPackage {
          pname = "my-python-app";
          version = "0.1.0";
          src = ./.;
          format = "pyproject";
          propagatedBuildInputs = pythonPackages;
          doCheck = false; # Prevents test failures if package isn't tested
        };

        # App output: Makes 'nix run .#hello' work; add more as needed
        apps = {
          hello = {
            type = "app";
            program = "${pythonEnv.interpreter}/bin/python ./hello_world.py";
          };
          # Add more scripts/apps:
          # another = {
          #   type = "app";
          #   program = "${pythonEnv.interpreter}/bin/python ./another_script.py";
          # };
        };
      }
    );
}