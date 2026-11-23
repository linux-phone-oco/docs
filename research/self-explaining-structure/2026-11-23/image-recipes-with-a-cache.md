# Image recipes with a cache - material (research image-recipes-how-it-stands)

Question (backlog image-recipes-with-a-cache, lab-tools, the author's words 2026-11-23): an image is a pure
function of its inputs; a procedure names a recipe; `ensure RECIPE` takes the image from a cache keyed by
its hash or builds it, on any machine. What is the best existing way, without inventing what exists?

## What is (read 2026-11-23, google-walleye-lab and lab-tools at origin/main)

- `device.toml [images.NAME]`: `path` under `[images] dir`, `sha256`, optional `kernel_tag` (an `int/` tag,
  checked by lab-tools `manifest/src/images.rs`). About 30 rows. lpoco-attended boots `[images.NAME]` by path
  and refuses a sha256 miss (`attended/src/steps.rs`, tests image-sum-ok/bad/missing/dry).
- The files live outside git in `~/Projects/walleye-build/images-*/` (MAP.md, "The lab machine"), on one host.
- ~85 `build/build-*.sh`. Most images are **derived from an earlier image**: z21 = z20 with three dtb
  statuses changed (`build-z21.sh`: unpack, fdtput, mkbootimg with the control's header, avbtool
  add_hash_footer with the control's salt and properties). The images form a DAG, rooted in a few hand-built
  kernels (`build-kernel.sh`: a worktree of the kernel clone + the lab's dts copied in + walleye*.config,
  `make LLVM=1 O=...`).
- lab-tools `lpoco bringup` already has the deterministic steps in Rust: `image pack` (header v0, byte for
  byte as mkbootimg), `image swap` (control + parts, header kept, AVB footer rebuilt - **by calling Python
  avbtool**), `image bisect SERIES` (a TOML of control + per-image swapped parts: half a recipe format already),
  `initramfs build` (reproducible newc cpio). `kernel assemble/publish` makes and pushes `int/` tags.
- `int/DEVICE/LIST/BASE/N` tags are immutable, their message records base and every branch's commit (MAP.md,
  "The kernel's branches"): a good recipe input (tag name + its commit).
- Nix 2.35.6 on the host from Arch's package (lab-machine `setup/nix.sh`: no channel, no flakes); nix.conf:
  sandbox = true, require-sigs = true, substituters = cache.nixos.org, trusted-users = root,
  trusted-substituters empty. lab-tools `shell.nix` pins nixpkgs by commit and hash (nixos-26.05).
- The walleye build scripts call Python `mkbootimg`, `unpack_bootimg`, `avbtool` (Arch android-tools).

## Measured (2026-11-23, lab host, read-only or in $AGENT_BUILD)

1. **z21 rebuilt from a recipe-shaped input, byte for byte.**
   `lpoco bringup image swap images-z20/boot-z20.img --dtb images-z21/msm8998-google-walleye-z21.dtb`
   -> sha256 `bdc0a891...c7ff`, equal to `device.toml [images.z21] sha256`. Inputs: z20 (sha256 fe9e0cce...,
   SHA256SUMS-z20) and the z21 dtb (f9f2ca5d..., SHA256SUMS-z21). The swap's footer is avbtool's (Python).
2. **The image as a Nix fixed-output path, keyed by its declared sha256.**
   `nix-store --print-fixed-path sha256 bdc0a891... boot-z21.img` predicts
   `/nix/store/6vmx4fp4hbhsfam89mfa8ixks7rlj2n0-boot-z21.img`; `nix-store --add-fixed` gives that path;
   `nix copy --to file://$AGENT_BUILD/nixcache` writes a narinfo with `CA: fixed:sha256:...` and no signature;
   after `nix-store --delete`, `nix copy --from file://...` as the normal (untrusted) user restores it (0.3 s):
   a content-addressed path needs no signing key. A derivation with `outputHash` = the declared sha256 and a
   builder that does not exist then resolves to that path **without running the builder** (served from the
   cache); with the path absent it runs the builder (a build).
3. **`--option extra-substituters file://...` is ignored for an untrusted user** (trusted-substituters is
   empty): sharing works by `nix copy --from` before the build, or by one line in the host's nix.conf
   (`trusted-substituters`), which is lab-machine's keeper's to change.
4. **The hand-built kernels are not reproducible as they stand.** z21's kernel (= out-z20/Image.gz, sha256
   455fa721...) says `Linux version 7.3.0-00004-ge123d3bff47d-dirty (mll@grig) (clang version 23.1.5, LLD
   23.1.5) #1 SMP PREEMPT Thu Nov 19 00:11:57 CET 2026`: timestamp, user, host, a -dirty tree (the lab's dts
   and a Makefile line copied in) and the host's rolling Arch clang are all in the bytes.
   Rebuild with those knobs set (KBUILD_BUILD_TIMESTAMP/USER/HOST, the same .config, the same commit):
   **Not equal, and every difference is a named, unrecorded input.** Run 1 (`git clone --shared` of the
   kernel clone at e123d3bff, the same Makefile line, out-z20/.config - `olddefconfig` left it the same -,
   KBUILD_BUILD_TIMESTAMP="Thu Nov 19 00:11:57 CET 2026", USER mll, HOST grig, clang 23.1.5, 5.5 min on 12
   cores): Image.gz ab02ca9b..., 6,747,133 of 43,391,488 uncompressed bytes differ. Cause 1: build-kernel.sh
   runs make with `DTC_FLAGS=-@`, which also gives the built-in imx8mp hdmi overlay its __symbols__ - an
   environment variable, not in any record of the image. Run 2 (incremental, DTC_FLAGS=-@ added): Image.gz
   cd1b3ce0..., 19,720 bytes differ, all from (a) the built-in initramfs cpio's mtime: 00:05:15, the moment
   `usr/` was built, since the original build set no KBUILD_BUILD_TIMESTAMP; (b) one banner copy with and one
   without the timestamp, the same cause; (c) the build counter (#1 vs #2 on a relink; KBUILD_BUILD_VERSION
   fixes it). So: a hand-built kernel cannot be rebuilt byte for byte from what was recorded (a time of day
   and an environment were never recorded), while with the knobs fixed (timestamp, version, user, host,
   DTC_FLAGS, a clean tree, the toolchain pinned) the same build gives the same bytes - Nix's sandbox and a
   pinned nixpkgs record exactly these; `nix-build --check` is the proof for each new kernel.
5. Nix `file://` binary cache of a local store path: works with `nix-command` enabled per call
   (`--extra-experimental-features nix-command`), no config change.

## Outside (researchers, 2026-11-23; every claim with its URL in the sources)

- Mobile NixOS: google-walleye dropped 2023-09-14 ("devices: Drop vendor-based systems"); no taimen, no surya,
  no sm7150; boot.img by osm0sis mkbootimg (C), dtb appended, no AVB/vbmeta handling found.
- Nix: input-addressed store; CA derivations still experimental (Lix proposed removing them) - not needed:
  fixed-output paths are enough; file:// binary cache, harmonia (Rust) to serve over HTTP; nixpkgs kernel
  build sets KBUILD_BUILD_TIMESTAMP from SOURCE_DATE_EPOCH, pulls python3Minimal; `mkbootimg-osm0sis` (C) in
  nixpkgs, avbtool only in Python `android-tools`; Rust: avbroot (vbmeta/AVB), abootcrafter (no footer).
- pmbootstrap (Nura, ex-postmarketOS): Python, Alpine chroots, distfiles cache only; boot-deploy (shell) calls
  AOSP mkbootimg (Python); pmOS surya moved to an sm7150 generic package with U-Boot in boot - not our shape.
- Yocto sstate: signature = hash of inputs + dependencies, hash-equivalence server, SSTATE_MIRRORS over HTTP;
  BitBake is Python, a whole distribution builder.
- Buildroot: ccache only; no binary package or output cache by design; BR2_REPRODUCIBLE.
- mkosi: Python; UKIs and disk images, no Android boot image, no input-keyed output cache.
- Bazel/Buck2: REAPI action cache (/ac) + CAS (/cas), bazel-remote (Go), NativeLink (Rust, FSL);
  Kleaf (Android kernels on Bazel) not fully hermetic, Python in its rules; heavy for one image step.
- BuildStream: CAS + remote asset; Python.
- sccache/ccache: per-object compiler caches; cacache (Rust, local); ORAS (OCI registry as artifact store).
- Kernel reproducible builds: KBUILD_BUILD_TIMESTAMP, _USER, _HOST, prefix maps, no per-build module key,
  setlocalversion's -dirty (docs.kernel.org/kbuild/reproducible-builds.html).

## Vectors weighed

A. Nix as store + sandbox + toolchain pin, recipes as TOML read by lpoco (chosen).
B. Nix whole: recipes written as Nix expressions per image (Mobile NixOS style).
C. Thin Rust tool with its own hash-keyed directory store (the do-it-ourselves baseline).
D. A build system with a remote cache (Bazel/Buck2 + REAPI, Kleaf).
E. A distribution builder (pmbootstrap, Yocto, Buildroot, mkosi, BuildStream).
