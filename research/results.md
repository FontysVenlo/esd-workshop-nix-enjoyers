## Results and Discussion

This section describes the findings related to the [RQs](/research/rqs.md).

### RQ1 - How does Nix differ from other comparable solutions?


### RQ2 - In which situations Nix should be a preferred as a deployment solution?
When reproducibility, composability, and multi‑environment consistency are
decisive, Nix (and NixOS [[1]]/NixOps [[2]]/Hydra[[3]]) often out‑shine more traditional
deployment tools.

Because Nix treats the entire system state as a pure functional value, the
same declarative expression always yields the identical set of packages,
configuration files, and services regardless of the host that evaluates it.
This property eliminates “it works on my machine” bugs and makes roll‑backs
as simple as switching to a previous store path — a capability that is
hard to guarantee with ad‑hoc scripts or mutable package managers [[4]][[5]].
Large organisations that need to ship the same binary stack to developers,
CI runners [[6]], and production clusters [[7]] therefore adopt Nix to
guarantee that every node sees exactly the same dependency graph [[8]].

Nix shines in environments where many heterogeneous targets must be kept in
lock‑step.
- Hybrid cloud/multi‑cloud deployments. NixOps can describe VMs,
  containers, or bare‑metal machines in a single Nix expression and then
  materialise the same configuration on AWS, GCP, Azure, or on‑premise
  hardware with a single command [[9]]. Companies that migrate workloads
  between clouds use this to avoid divergent configuration drift.
- Continuous‑integration pipelines. Hydra, the Nix‑driven CI server, can
  rebuild every commit in a deterministic sandbox, catch build‑time
  regressions early, and publish the resulting store paths as immutable
  artefacts for later deployment [[10]]. Projects such as the Haskell compiler
  (GHC) and the Rust toolchain already rely on Hydra for reproducible releases.
- Developer workstations and reproducible dev environments. Using `nix
  develop` each contributor can spin up a sandbox that
  contains exactly the libraries, compilers, and tooling required by the
  project, regardless of the host Operating System [[11]]. This eliminates “works locally
  but not on CI” failures common in the polyglot monorepos.

When security and auditability are paramount, Nix’s immutable store also
provides tangible benefits, such as advanced rollback mechanism, easier compliance assertion,
increased integrity (simply follows from functional nature of Nix) [[12]].

### RQ3 - In which situations Nix does not bring a value to the project and may be an overkill?
Nix is engineered to provide three major benefits: **reproducibility**, **isolation**, and **declarative/atomic configuration**. However, adopting Nix introduces significant complexity that is often unnecessary when these benefits are not essential to a project [4][6][9].
* **If reproducibility is not a real-world priority**: Such as in single-developer, short-lived, or internal-only projects, where environment drift rarely causes issues, then the up-front complexity of Nix is not justified [10][4].
* **If dependency isolation and avoiding conflicts are not pain points**: For example, projects working well with language-specific managers (`pip`/`npm`/`apt`), or those with very simple dependency stacks, then Nix's approach introduces more overhead than practical improvement [11][10].
* **If atomic rollbacks and declarative configuration aren't business critical**: Such as projects with stable, rarely-changed setups, or those where rollbacks are handled through simpler means, the challenges of learning the Nix language and maintaining declarative configs outweigh the potential gains [9][4].

Additional drawbacks include a **steep learning curve**, **difficult error messages**, potential **disk space bloat** from retained environments, and **extra barriers for onboarding new developers**. For these reasons, Nix is overkill in projects that **do not actively require robust reproducibility**, **advanced dependency management**, or **infrastructure-as-code style system configuration**. In such cases, standard package managers and imperative setup will suffice and be much easier to maintain [1][6][4].

## Sources

TODO: adjust numbering
<a id="1">[1]</a> [NixOS: A purely functional Linux distribution](https://dl.acm.org/doi/10.1017/S0956796810000195) \
<a id="2">[2]</a> [NixOps](https://github.com/NixOS/nixops) \
<a id="3">[3]</a> [Hydra](https://github.com/NixOS/hydra) \
<a id="4">[4]</a> [Purely functional package manager](https://nixos.org/manual/nix/stable/#sec-purely-functional) \
<a id="5">[5]</a> [Nix: A Safe and Policy-Free System for Software Deployment](https://edolstra.github.io/pubs/nspfssd-lisa2004-final.pdf) \
<a id="6">[6]</a> [Caliptra GitHub GCP Runner Infrastructure](https://github.com/chipsalliance/caliptra-sw/tree/main/ci-tools/github-runner) \
<a id="7">[7]</a> [Docker Was Too Slow, So We Replaced It: Nix in Production](https://www.socallinuxexpo.org/scale/22x/presentations/docker-was-too-slow-so-we-replaced-it-nix-production) \
<a id="8">[8]</a> [Reproducible Builds: Increasing the Integrity of Software Supply Chains](https://doi.org/10.1109/MS.2021.3073045) \
<a id="9">[9]</a> [NixOps Documentation](https://nixops.readthedocs.io/en/latest/introduction.html) \
<a id="10">[10]</a> [Hydra: A Declarative Approach to Continuous Integration](https://edolstra.github.io/pubs/hydra-scp-submitted.pdf) \
<a id="11">[11]</a> [Per-Project Development Environments with Nix](https://mtlynch.io/notes/nix-dev-environment/) \
<a id="12">[12]</a> [Nix as a declarative solution for embedded security challenges and system administration problems](https://www.utupub.fi/bitstream/handle/10024/180653/Korte_Eino_Thesis.pdf?sequence=1) \

TODO: please make these clickable and adjust numbering (only to be done after all RQs are done)
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
