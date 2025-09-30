## Background

Over the last couple of decades we could have observe lots of efforts in easing up deployment of
software projects at scale, such as Docker [[1]](#1), GNU Guix [[2]](#2), or Ansible [[3]](#3).
A recurring difficulty in modern software development is reproducibility:
the guarantee that a project that builds and runs on a developer’s
workstation will behave identically on a customer’s system, a CI runner, or
a production server [[4]](#4)[[5]](#5)[[6]](#6).

One of the tools that has gained noticeable traction over the past decade
for tackling reproducibility is the Nix package manager. Nix treats package
builds as pure functions: the output store path is a cryptographic hash of
all inputs (source code, compiler version, build flags, environment
variables, etc.). Consequently, if two developers invoke the same Nix
expression on different machines, the resulting store path (and thus the
binary) will be identical [[7]](#7).

These properties have led several large organisations to adopt Nix in
production. For example, Google uses Nix internally for the Caliptra
project’s CI infrastructure, ensuring that firmware generated in the cloud matches
exactly what runs on the target hardware [[8]](#8).

## Nix

The idea behind Nix emerged from the PhD research of Eelco Dolstra at the
University of Utrecht. In his 2004 dissertation “The Nix Packages
Collection – A Functional Package Manager” [[7]](#7), he proposed treating
package management as a purely functional transformation: a package is built
by a function whose result is immutable and identified by a hash of all its
inputs. The first prototype, released in 2003, was a command‑line tool for
GNU/Linux that stored each built package in a global `/nix/store` directory
under a name derived from that hash. Because the store was read‑only,
multiple versions of the same package could coexist without conflict, and
upgrades could be performed atomically.
In 2006, three years after initial proposal of Nix by Eelco Dolstra, Armijn Hemel in his Master thesis,
introduced NixOS - a GNU/Linux distribution based on Nix as a package manager and a configuration tool [[9]](#9).
Couple of years later, and hundreds of thousand packages later, in 2015, the NixOS foundation was founded [[10]](#10).
Since 2003, Nix has been a subject of many scientific work, the full collection of these can be found on the dedicated website [[11]](#11).

## Nix Flakes
Flakes are an experimental feature [[12]](#12), introduced with Nix 2.4 release in 2021 [[13]](#13). While still technically "unstable" [[14]](#14), flakes
are currently used in most of the Nix projects [[15]](#15). They aim to uniform a structure for Nix projects, pin a specific versions of each dependencies,
and sharing dependencies via lock files. This allows to improve reproductibility of Nix installations. At its core, what we call a "flake" is a source tree (usually a git repository), with `flake.nix` and `flake.lock`
files in the root directory of a source tree. Additionally, the official NixOS documentation [[16]](#16) specifies following properties of the Flakes:
- An (Nix) installation may contain any number of flakes, independent of each other or even call each other.
- The contents of `flake.nix` file follow the uniform naming schema for expressing packages and dependencies on Nix.
- Flakes use the standard Nix protocols, including the URL-like syntax [[17]](#17) for specifying repositories and package names.
- To simplify the long URL syntax with shorter names, flakes uses a registry of symbolic identifiers.
- Flakes also allow for locking references and versions that can then be easily queried and updated programmatically.
- Nix command-line interface [[18]](#18) accepts flake references for expressions that build, run, and deploy packages.

## References

<a id="1">[1]</a> [An Introduction to Docker and Analysis of its Performance](https://www.researchgate.net/profile/Harrison-Bhatti/publication/318816158_An_Introduction_to_Docker_and_Analysis_of_its_Performance/links/61facc0c007fb504472fd6c7/An-Introduction-to-Docker-and-Analysis-of-its-Performance.pdf) \
<a id="2">[2]</a> [Building a Secure Software Supply Chain with GNU Guix](https://arxiv.org/pdf/2206.14606) \
<a id="3">[3]</a> [Unleashing Full Potential of Ansible Framework: University Labs Administration](https://doi.org/10.23919/FRUCT.2018.8468270) \
<a id="4">[4]</a> [Reproducibility of Build Environments through Space and Time](https://arxiv.org/abs/2402.00424) \
<a id="5">[5]</a> [Reproducibility in Software Engineering](https://zenodo.org/records/15315531) \
<a id="6">[6]</a> [Reproducible Builds: Increasing the Integrity of Software Supply Chains](https://doi.org/10.1109/MS.2021.3073045) \
<a id="7">[7]</a> [Nix: A Safe and Policy-Free System for Software Deployment](https://edolstra.github.io/pubs/nspfssd-lisa2004-final.pdf) \
<a id="8">[8]</a> [Caliptra GitHub GCP Runner Infrastructure](https://github.com/chipsalliance/caliptra-sw/tree/main/ci-tools/github-runner) \
<a id="9">[9]</a> [Purely Functional System Configuration Management](https://www.usenix.org/legacy/event/hotos07/tech/full_papers/dolstra/dolstra_html/) \
<a id="10">[10]</a> [NixOS Foundation](https://github.com/NixOS/foundation) \
<a id="11">[11]</a> [NixOS - Research and Scientific Publications](https://nixos.org/research/) \
<a id="12">[12]</a> [Experimental Features](https://nix.dev/manual/nix/stable/development/experimental-features.html#xp-feature-flakes) \
<a id="13">[13]</a> [Release 2.4 (2021-11-01)](https://nix.dev/manual/nix/2.31/release-notes/rl-2.4.html) \
<a id="14">[14]</a> [flakes stabilisation](https://github.com/NixOS/nix/milestone/27) \
<a id="15">[15]</a> [Nix for simplified configuration management in in an enterprise environment](https://oda.oslomet.no/oda-xmlui/bitstream/handle/11250/3212253/no.oslomet:inspera:348177680:185530073.pdf?sequence=1) \
<a id="16">[16]</a> [Flakes - NixOS Wiki](https://nixos.wiki/wiki/flakes) \
<a id="17">[17]</a> [URL-like syntax](https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-flake#url-like-syntax) \
<a id="18">[18]</a> [nix registry](https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-registry) \
<a id="19">[19]</a> [nix cli](https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix.html)
