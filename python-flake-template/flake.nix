{
  # -------------------------------------------------------------
  # Python flake for shell and script running
  #
  # STUDENT NOTES:
  # - Exercise 1: edit the Python version (e.g., pkgs.python310 → pkgs.python311)
  # - Do NOT edit anything else unless instructed
  # -------------------------------------------------------------

  description = "Python flake for shell and script running";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # === EDIT HERE (Exercise 1) ===
        python = pkgs.python311;

        pythonEnv = python.withPackages (ps: with ps; [
          pip
        # === EDIT HERE (Exercise 2) ===

        ]);

        # Wrapper for hello_world.py (keeps LF line endings)
        helloBin = pkgs.writeShellScriptBin "hello"
          (builtins.replaceStrings ["\r\n"] ["\n"] ''
            exec ${pythonEnv}/bin/python ${./hello_world.py} "$@"
          '');

          importBin = pkgs.writeShellScriptBin "import"
            (builtins.replaceStrings ["\r\n"] ["\n"] ''
              exec ${pythonEnv}/bin/python ${./missing_import.py} "$@"
            '');
      in {
        # Development shell (provides python + packages)
        devShells.default = pkgs.mkShell {
          buildInputs = [ pythonEnv ];
        };

        # Runnable app: `nix run .#hello`
        apps.hello = {
          type = "app";
          program = "${helloBin}/bin/hello";
        };

        apps.import = {
          type = "app";
          program = "${importBin}/bin/import";
        };
      }
    );
}