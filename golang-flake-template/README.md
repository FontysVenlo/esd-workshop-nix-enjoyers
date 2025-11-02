# Packaging Golang projects with Nix

Writing our own Flake from scratch is quite of a task, but fortunately, there are tools such as [gomod2nix](https://github.com/nix-community/gomod2nix). 
Of course there are other possible ways of packaging Go with Nix - such as native [buildGoModule](https://nixos.org/manual/nixpkgs/stable/#sec-go-modules), which,
however has a major issue: it produces fixed-output derivations [[1]](#1), [[2]](#2). This basically means that the each single
derivation (can be seen as a build "receipe") contains **every** Go module the program needs. All of those modules are fetched ahead of time,
placed into a `vendor/` directory, and the whole directory is given a single hash. The derivation’s `sha256` attribute stores that hash, and there is
a second attribute called `vendorSha256` that must be updated whenever the vendored code changes. Now, if two different Go packages depend on the same third‑party module,
each package gets its own copy of that module in its own  vendor/  directory. Nix can’t share the
module between the two builds, so you end up downloading and compiling the same code multiple times. Additionally, whenever the source of any dependency changes you have to update both
`sha256` (the hash of the main source) and `vendorSha256` (the hash of the vendored dependencies). If you forget to update `vendorSha256`, the build will fail.
The failure is often discovered only after a long compile, forcing you to start the whole process over again. A more detailed (and technical) info on this issues may be accessed on the
blog of the `gomod2nix` authors [[3]](#3). `gomod2nix`, which we are going to use in this workshop, follows the same vendoring strategy that  buildGoModule  uses, but rather than copying
all of the source files into a single derivation, it creates symbolic links to those files. Because the dependencies are linked instead of embedded, each dependency can be downloaded once
and stored as a separate derivation. Identical dependency trees are then shared automatically across any number of Go packages in the Nix store, avoiding duplicate copies. So, enough theory,
let's get our hands dirty!

## Study case: u-root
u‑root is a lightweight, Go‑based initramfs and early‑boot framework that lets you build and run a fully functional Linux userspace directly from a
single Go binary (built from a small set of Go‑compiled tools). Thanks to Go’s static linking and cross‑compilation capabilities, u‑root eliminates the
need for traditional shell scripts, busybox, and complex build chains. Now, its `go.sum` file is ca. 550 lines long - lots of dependencies. Thus it is a perfect project to Nix-ify!
</br>
Please make sure that you have followed steps described in [bootstrap](../bootstrap/README.md) section!

### 1. Entering a development shell
Once in a container's shell, navigate to the `/u-root` directory.

From here you should be able to enter the Nix development shell (see `/u-root/shell.nix` and play around if you want):

```bash
nix develop

# now from within the shell run gomod2nix
gomod2nix generate

# before building u-root, exit the development shell (bonus question: why building inside of development shell will fail?)
exit
```

### 2. Building u-root
Let's see whether the "generic" flake works for u-root without any modifications - run `nix build .#` and see what happens :)

Hint: the shell inside the container is very very minimal - you will need to use some text editor to modify flake.nix inside of the container [see `nix-env` manual](https://nixos.org/manual/nixpkgs/stable/#sec-building-environment)

When the build fails, follow the logs and see what is wrong: `nix log /nix/store/<hash>-u-root-v0.14.0.drv`. You should see something like:
```
ERROR mkuimage error: couldn't add "/bin/bash:bin/bash" to archive: adding "/bin/bash" to archive failed because Lstat failed: lstat /bin/bash: no such file or directory
```

Your task now is to find out, based on what you have learned about Nix properties so far, why this error is occurs, and think about possible ways to fix it (HINT: there are at least two solutions).

Have fun!

## References
<a id="1">[1]</a> [buildNodeModules - The dumbest node to nix packaging tool yet!](https://discourse.nixos.org/t/buildnodemodules-the-dumbest-node-to-nix-packaging-tool-yet/35733) \
<a id="2">[2]</a> [Restrict fixed-output derivations](https://github.com/NixOS/nix/issues/2270) \
<a id="3">[3]</a> [Announcing gomod2nix](https://www.tweag.io/blog/2021-03-04-gomod2nix/)
