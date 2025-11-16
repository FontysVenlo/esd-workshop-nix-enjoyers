# TypeScript Nix Flake Workshop Exercises

This mini-workshop shows how to use **Nix flakes** to get a reproducible **Node.js + pnpm + TypeScript** setup for a small web app.

You will:
- use `nix develop` to enter a ready-to-use dev environment
- use `pnpm start` to run the dev server
- see how deleting `node_modules` does not break reproducibility

> All commands below are run **inside the `typescript-exercises` folder**.

---

## Before you start

1. Go to the TypeScript exercises directory:

   ```bash
   cd /typescript-exercises
   ```

   In a real project created from this template, you would `cd` into that project’s folder instead.

2. Check that `flake.nix` is present:

   ```bash
   ls
   ```

   You should see at least:

   - `flake.nix`
   - `package.json`
   - `src/`
   - `webpack.config.js`

---

## Exercise 1 – Enter the Nix development shell

**Goal:** Get a controlled Node.js + pnpm environment provided by Nix.

1. Enter the dev shell:

   ```bash
   nix develop
   ```

   Your prompt will change (you are now “inside” the Nix environment).

2. Check what Nix gave you:

   ```bash
   which node
   which pnpm
   node --version
   pnpm --version
   ```

   You should see paths under `/nix/store/...` and concrete version numbers.

3. Install project dependencies:

   ```bash
   pnpm install
   ```

   This populates `node_modules` based on `package.json` and `pnpm-lock.yaml`.

### Useful shortcuts

- Press **↑ (Up Arrow)** to repeat the last command.
- Press **Ctrl + C** in the terminal to stop a running command (same on Windows/macOS/Linux).

---

## Exercise 2 – Start the dev server with Nix

**Goal:** Use the `pnpm start` command inside the Nix environment to run the TypeScript dev server.

You can still stay inside the dev shell from Exercise 1.

1. Start the dev server using:

   ```bash
   pnpm start
   ```

   This runs the `start` script from `package.json`, which calls `webpack serve` inside the Nix-provided Node.js environment.

2. Watch the output. You should see lines similar to:

   ```text
   [webpack-dev-server] Project is running at:
   [webpack-dev-server] Loopback: http://localhost:8080/
   ...
   webpack 5.x.x compiled successfully
   ```

3. Open a browser and visit:

   - `http://localhost:8080`

   You should see the page served from `dist/index.html` and bundled `main.js`.

4. Stop the dev server when you are done:

   - Focus the terminal window that is running webpack
   - Press **Ctrl + C**

---

## Exercise 3 – Ephemeral vs. reproducible dependencies

**Goal:** See what happens when `node_modules` is deleted and how Nix + the lockfile restore it.

1. Make sure the dev server is stopped (**Ctrl + C**).

2. Remove `node_modules`:

   ```bash
   rm -rf node_modules
   ```

3. Reinstall dependencies:

   ```bash
   pnpm install
   ```

4. Run the dev app again:

   ```bash
   pnpm start
   ```

5. Observe the output:

   - pnpm will reinstall packages based on `pnpm-lock.yaml`
   - webpack dev server will start again

6. Refresh `http://localhost:8080` in your browser – it should behave exactly as before.

### What this shows

- **Nix** pins the **tooling** (Node.js + pnpm) through `flake.nix`.
- **pnpm** pins the **JS dependencies** through `pnpm-lock.yaml`.
- Deleting `node_modules` is not a problem as long as both of these definitions are intact and you run `pnpm install` again.

---

## Exercise 4 (optional) – Changing Node.js version declaratively

**Goal:** Change the Node.js version in one place and let Nix rebuild the environment.

1. Open `flake.nix` in an editor.

2. Inside the `let` block in `flake.nix`, either **find or add** a `nodejs` binding like this:

   ```nix
   let
     pkgs = import nixpkgs { inherit system; };
     nodejs = pkgs.nodejs_20;
     pnpm = pkgs.nodePackages_latest.pnpm;
   in
   ```

   If `nodejs = pkgs.nodejs_20;` is already there, just keep it as-is for now.

3. Now change the Node.js version, for example to 18:

   ```nix
   nodejs = pkgs.nodejs_18;
   ```

4. Leave the current shell:

   ```bash
   exit
   ```

5. Enter the dev shell again:

   ```bash
   nix develop
   node --version
   ```

   You should now see a different Node.js version.

### Takeaway

- Node.js version changes are done **in code** (`flake.nix`), not via manual installers.
- Anyone pulling this flake will get **the same Node.js version**.

---

## Summary

- `nix develop` gives you a reproducible Node.js + pnpm environment.
- `pnpm start` runs the dev server inside the reproducible environment that `nix develop` provides.
- Deleting `node_modules` is safe – Nix + your lockfile allow you to recreate it exactly.
- All important details (tool versions, commands) are **declarative** and live in the repo.

This is the core idea of using Nix with TypeScript: **your environment is part of the project, not your machine.**