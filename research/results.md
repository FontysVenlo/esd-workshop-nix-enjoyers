## Results and Discussion

This section describes the findings related to the [RQs](/research/rqs.md).

### RQ1 - How does Nix differ from other comparable solutions?

**Nix** is a *purely functional package manager* and build system that emphasizes reproducible builds and declarative system configuration. It differs significantly from other tools that solve similar problems. Below we compare Nix with two notable solutions: **Docker** (containerization for reproducible environments) and **GNU Guix** (another functional package manager inspired by Nix).

#### **RQ1-SQ1: Nix vs. Docker**

Both Nix and Docker can provide reproducible software environments, but they use fundamentally different approaches [[1]](#1)[[2]](#2):

- **Scope and Purpose:** Nix is a package manager and build tool for installing software and configuring systems, whereas Docker is a container platform for bundling applications with their environment and running them in isolated processes [[2]](#2).
- **Reproducibility Guarantees:** Nix builds packages in a *hermetic, deterministic environment*. Each build’s inputs are fully specified, and Nix hashes all inputs to ensure the output is the same given the same inputs [[1]](#1)[[3]](#3). Docker can encapsulate an environment in an image, but building that image is not inherently deterministic. Running docker build twice might produce different results if external package sources have changed [[1]](#1).
- **Isolation vs. Integration:** Docker provides **OS-level isolation** using kernel namespaces and cgroups, essentially running processes in a separate containerized filesystem and process space. This makes Docker great for deployment [[2]](#2). Nix, on the other hand, operates within the host OS. It installs packages into the Nix store and can set up isolated development shells, but processes run on the host [[1]](#1).
- **Dependency Management:** Nix has **first-class package management** via the nixpkgs repository, whereas Docker relies on whatever package manager is inside the container (e.g., apt, apk) [[2]](#2).
- **Storage Model:** Nix stores packages in the *Nix store* with unique hashes, ensuring isolation between builds [[4]](#4). Docker uses layered filesystem images meaning each Dockerfile command creates a new layer identified by a content hash [[2]](#2).
- **Composability of Environments:** Nix allows easy combination of dependencies in one environment. In Docker, images are built from one base image, so you cannot merge two bases directly [[1]](#1).
- **Resource Efficiency:** Nix environments share binaries through the store. Docker images can become large due to duplicated libraries [[5]](#5).
- **Use Cases and Deployment:** Docker is ideal for *deploying isolated services*. Nix excels at *development environments* and reproducible builds [[1]](#1)[[2]](#2).
- **Learning Curve and Popularity:** Docker is easier for beginners and widely adopted. Nix has a steeper learning curve but offers stronger reproducibility [[1]](#1)[[2]](#2).

**Summary:** Nix provides *fine-grained reproducibility and package management*, while Docker provides *runtime isolation*. They can complement each other: Nix can build Docker images without Dockerfiles [[2]](#2).

#### **RQ1-SQ2: Nix vs. GNU Guix**

**GNU Guix** is directly inspired by Nix and shares much of its design. But they differ in key ways:

- **Philosophy and Governance:** Guix is a GNU project and strictly includes only free software by policy [[6]](#6). Nix is more pragmatic: it allows non-free software[[8]](#8) if enabled via allowUnfree [[6]](#6).
- **Implementation Language:** Nix uses its own DSL (Domain-Specific Language) for packages and is implemented in C++ [[4]](#4). Guix uses **Guile Scheme** [[8]](#8), providing a general-purpose Lisp environment for package definitions and configuration [[6]](#6).
- **System Integration:** NixOS uses **systemd** as its init system, while Guix System uses **GNU Shepherd**, keeping everything in Scheme [[6]](#6).
- **Package Repositories:** Nixpkgs is much larger than Guix’s repository, as Guix excludes non-free software and has a smaller contributor base [[6]](#6)[[7]](#7).
- **Platform Support:** Guix supports both Linux and GNU Hurd, while Nix supports Linux, macOS, and *BSD (Unix-like operating systems) [[6]](#6).
- **Community:** Nix has broader adoption and a large community [[8]](#8), while Guix’s smaller community emphasizes GNU philosophy and Scheme tooling [[6]](#6)[[7]](#7).

**Summary:** Both Nix and Guix are *functional package managers* with reproducibility at their core. Nix is larger, older, and more pragmatic, while Guix is philosophically strict and Scheme-based. They are similar in goals but differ in ecosystem and implementation.


### RQ2 - In which situations Nix should be a preferred as a deployment solution?
When reproducibility, composability, and multi‑environment consistency are
decisive, Nix (and NixOS [[9]](#9)/NixOps [[10]](#10)/Hydra[[11]](#11)) often out‑shine more traditional
deployment tools.

Because Nix treats the entire system state as a pure functional value, the
same declarative expression always yields the identical set of packages,
configuration files, and services regardless of the host that evaluates it.
This property eliminates “it works on my machine” bugs and makes roll‑backs
as simple as switching to a previous store path — a capability that is
hard to guarantee with ad‑hoc scripts or mutable package managers [[12]](#12)[[13]](#13).
Large organisations that need to ship the same binary stack to developers,
CI runners [[14]](#14), and production clusters [[15]](#15) therefore adopt Nix to
guarantee that every node sees exactly the same dependency graph [[16]](#16).

Nix shines in environments where many heterogeneous targets must be kept in
lock‑step.
- Hybrid cloud/multi‑cloud deployments. NixOps can describe VMs,
  containers, or bare‑metal machines in a single Nix expression and then
  materialise the same configuration on AWS, GCP, Azure, or on‑premise
  hardware with a single command [[17]](#17). Companies that migrate workloads
  between clouds use this to avoid divergent configuration drift.
- Continuous‑integration pipelines. Hydra, the Nix‑driven CI server, can
  rebuild every commit in a deterministic sandbox, catch build‑time
  regressions early, and publish the resulting store paths as immutable
  artefacts for later deployment [[18]](#18). Projects such as the Haskell compiler
  (GHC) and the Rust toolchain already rely on Hydra for reproducible releases.
- Developer workstations and reproducible dev environments. Using `nix
  develop` each contributor can spin up a sandbox that
  contains exactly the libraries, compilers, and tooling required by the
  project, regardless of the host Operating System [[19]](#19). This eliminates “works locally
  but not on CI” failures common in the polyglot monorepos.

When security and auditability are paramount, Nix’s immutable store also
provides tangible benefits, such as advanced rollback mechanism, easier compliance assertion,
increased integrity (simply follows from functional nature of Nix) [[20]](#20).

### RQ3 - In which situations Nix does not bring a value to the project and may be an overkill?
Nix is engineered to provide three major benefits: **reproducibility**, **isolation**, and **declarative/atomic configuration**. However, adopting Nix introduces significant complexity that is often unnecessary when these benefits are not essential to a project [4][6][9].
* **If reproducibility is not a real-world priority**: Such as in single-developer, short-lived, or internal-only projects, where environment drift rarely causes issues, then the up-front complexity of Nix is not justified [10][4].
* **If dependency isolation and avoiding conflicts are not pain points**: For example, projects working well with language-specific managers (`pip`/`npm`/`apt`), or those with very simple dependency stacks, then Nix's approach introduces more overhead than practical improvement [11][10].
* **If atomic rollbacks and declarative configuration aren't business critical**: Such as projects with stable, rarely-changed setups, or those where rollbacks are handled through simpler means, the challenges of learning the Nix language and maintaining declarative configs outweigh the potential gains [9][4].

Additional drawbacks include a **steep learning curve**, **difficult error messages**, potential **disk space bloat** from retained environments, and **extra barriers for onboarding new developers**. For these reasons, Nix is overkill in projects that **do not actively require robust reproducibility**, **advanced dependency management**, or **infrastructure-as-code style system configuration**. In such cases, standard package managers and imperative setup will suffice and be much easier to maintain [1][6][4].

## References
<a id="1">[1]</a> [Connor Brewster: “Will Nix Overtake Docker?” (Replit Blog)](https://replit.com/site/blog/nix-vs-docker)  
<a id="2">[2]</a> [Sander van der Burg: *On using Nix and Docker as deployment automation solutions: similarities and differences*](https://sandervanderburg.blogspot.com/2020/07/on-using-nix-and-docker-as-deployment.html)  
<a id="3">[3]</a> [Reproducible Builds Project: Increasing the Integrity of Software Supply Chains](https://reproducible-builds.org/)  
<a id="4">[4]</a> [Eelco Dolstra et al.: *Nix: A Safe and Policy-Free System for Software Deployment* (JFP Paper)](https://edolstra.github.io/pubs/nixos-jfp-final.pdf)  
<a id="5">[5]</a> [HashBlock Blog: “Why I Ditched Docker for Nix: Reproducible Builds Without the Bloat”](https://medium.com/@connect.hashblock/why-i-ditched-docker-for-nix-reproducible-builds-without-the-bloat-d21f44250181)  
<a id="6">[6]</a> [Loïc Reynier: “Do GUIX and NixOS differ architecturally?” (Unix StackExchange Answer)](https://unix.stackexchange.com/questions/754491/do-guix-and-nixos-differ-architecturally)  
<a id="7">[7]</a> [System Crafters Forum: “NixOS vs Guix: A non-programmer’s perspective”](https://forum.systemcrafters.net/t/nixos-vs-guix-a-non-programmers-novice-perspective/875)  
<a id="8">[8]</a> [Benoît Jacolin: “How Guix compares to Nix and vice versa” (Personal Blog)](https://blog.benoitj.ca/2023-10-20-how-guix-compare-to-nix-and-vice-versa/)  

<a id="9">[9]</a> [NixOS: A purely functional Linux distribution](https://dl.acm.org/doi/10.1017/S0956796810000195) \
<a id="10">[10]</a> [NixOps](https://github.com/NixOS/nixops) \
<a id="11">[11]</a> [Hydra](https://github.com/NixOS/hydra) \
<a id="12">[12]</a> [Purely functional package manager](https://nixos.org/manual/nix/stable/#sec-purely-functional) \
<a id="13">[13]</a> [Nix: A Safe and Policy-Free System for Software Deployment](https://edolstra.github.io/pubs/nspfssd-lisa2004-final.pdf) \
<a id="14">[14]</a> [Caliptra GitHub GCP Runner Infrastructure](https://github.com/chipsalliance/caliptra-sw/tree/main/ci-tools/github-runner) \
<a id="15">[15]</a> [Docker Was Too Slow, So We Replaced It: Nix in Production](https://www.socallinuxexpo.org/scale/22x/presentations/docker-was-too-slow-so-we-replaced-it-nix-production) \
<a id="16">[16]</a> [Reproducible Builds: Increasing the Integrity of Software Supply Chains](https://doi.org/10.1109/MS.2021.3073045) \
<a id="17">[17]</a> [NixOps Documentation](https://nixops.readthedocs.io/en/latest/introduction.html) \
<a id="18">[18]</a> [Hydra: A Declarative Approach to Continuous Integration](https://edolstra.github.io/pubs/hydra-scp-submitted.pdf) \
<a id="19">[19]</a> [Per-Project Development Environments with Nix](https://mtlynch.io/notes/nix-dev-environment/) \
<a id="20">[20]</a> [Nix as a declarative solution for embedded security challenges and system administration problems](https://www.utupub.fi/bitstream/handle/10024/180653/Korte_Eino_Thesis.pdf?sequence=1) \

TODO: please make these clickable and adjust numbering (only to be done after all RQs are done) \
[1] https://www.reddit.com/r/NixOS/comments/1ej6xu9/what_are_some_downsides_of_nix/  
[2] https://jvns.ca/blog/2023/02/28/some-notes-on-using-nix/  
[3] https://discourse.nixos.org/t/market-nix-not-as-a-package-manager-but-as-a-build-tool-and-dependency-management-tool/47432  
[4] https://nixos-and-flakes.thiscute.world/introduction/advantages-and-disadvantages  
[5] https://dev.to/arnu515/the-one-thing-i-do-not-like-about-the-nix-package-manager-and-a-fix-for-it-33ln  
[6] https://blog.graysonhead.net/posts/nixos-hype/  
[7] https://discourse.haskell.org/t/whats-all-the-hype-with-nix/2593  
[8] https://news.ycombinator.com/item?id=29081826  
[9] https://nixos.org/guides/how-nix-works/  
[10] https://news.ycombinator.com/item?id=30060895  
[11] https://www.zenoix.com/posts/get-started-with-nix-and-home-manager/
