# Nix flake exercises for Python project

These workshop exercises cover two of Nix’s main selling points:

- **Declarative environments** — everything is defined in `flake.nix`.
- **Reproducibility** — the environment is always the same, no matter where or when you run it.

## Files

- `flake.nix` — defines the Nix dev environment and runnable apps.
- `hello_world.py` — checks the Python version (Exercise 1).
- `missing_import.py` — tries to import Flask (Exercises 2–3).

## Exercise 1: Version pinning (declarative environments)

**Goal:** Change the Python version in the environment declaratively.

1. Run the `#hello` app:

   ```bash
   nix run .#hello
   ```

   If the version doesn’t match, the script exits with an error.

2. Edit `flake.nix`:

   ```nix
   # === EDIT HERE (Exercise 1) ===
   python = pkgs.python311;   # try changing to pkgs.python310
   ```

3. Run the `#hello` app again, what does it print?

## Exercise 2A: Temporary installs

**Goal:** Show that using `pip install` inside `nix develop` only works for the current shell session.

1. Run:

   ```bash
   nix run .#import
   ```

   - fails with `ModuleNotFoundError: No module named 'flask'`.

2. Temporary fix:

   ```bash
   nix develop
   pip install flask
   python missing_import.py   # works now
   exit
   ```

3. Try running the `#import` app again, what happens? *- Follow-up on exercise 2B!*

## Exercise 2B: Make it reproducible

**Goal:** Fix the missing import the **declarative** way.

1. Edit `flake.nix`:

   ```nix
   pythonEnv = python.withPackages (ps: with ps; [
     pip
     flask   # add this
   ]);
   ```

2. Run:

   ```bash
   nix run .#import
   ```

   - works every time, even after leaving and re-entering the shell.

## Commands reference

- `nix run .#hello` — run Exercise 1 script.
- `nix run .#import` — run Exercise 2/3 script.
- `nix develop` — enter the Nix shell.

## Key lessons

- Packages installed with `pip install` inside `nix develop` are **temporary** — they vanish when you leave the shell.  
- Declaring packages in `flake.nix` makes them **persistent and reproducible** across sessions and machines.  
- With Nix, environments are **defined in code** and can be **shared reliably** with others.