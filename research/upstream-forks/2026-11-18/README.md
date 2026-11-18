# Upstream forks, 2026-11-18: the material

The patches and the phone test behind research upstream-forks-landscape, sxmo-suspend-fixes and
pmic-wdt-way-back, and decision 2026-11-18-upstream-forks. Nothing here was sent anywhere; every mail is
the author's, from his clone, signed off by him.

## What is here

- `patches/sxmo-utils/` - `[PATCH sxmo-utils 1/3..3/3]` with cover letter, from the branch `lab` of
  `~/Projects/linux-phone-oco/sxmo-utils-topics` (a worktree of the local `linux-phone-oco/sxmo-utils`
  clone), on upstream master 1fd7822. Topics: `topic/sxmo-autosuspend-backoff` (2bb2500),
  `topic/sxmo-suspend-stop-by-profile` (1156bb6), `topic/sxmo-surya-sensors-suspend` (6432ef9).
  Test: `spec/scripts/core/sxmo_autosuspend_spec.sh` in the series (6 examples; all fail on master's
  script, all pass with the series). Run: `nix-shell -p shellspec --run 'shellspec spec/scripts/core/sxmo_autosuspend_spec.sh'`.
- `patches/linux/` - `[RFC PATCH 1/4..4/4]` with cover letter, from `topic/pmic-wdt-wake-in-suspend`
  (e123d3bff) of `~/Projects/linux-phone-oco/linux-topics` (a worktree of the local `linux-phone-oco/linux`
  clone), on v7.3. Built with LLVM W=1 clean; `checkpatch.pl --strict` clean but the Co-Authored-By
  trailer (the kernel wants `Assisted-by: LLM` and the sender's Signed-off-by instead); the binding passes
  dt-doc-validate and yamllint. Untested on hardware: RFC until the phone proofs pass.
- `tests/pmic-wdt-way-back.sh` - the phone proof of the kernel series (verbs check, bite, wake), for the
  keepers: tests pmic-wdt-bites and pmic-wdt-wakes-in-suspend.

## Forks

The forks already exist under the organisation (decision 2026-11-18-upstream-forks): no command is needed.
If the author wants them under his user account instead, these make them (each public, each his act):

    gh repo fork sm7150-mainline/linux --clone=false             # grenudi/linux, a GitHub fork
    gh repo create grenudi/sxmo-utils --public \
      --description "sxmo-utils (git.sr.ht/~mil/sxmo-utils) carrying linux-phone-oco's patches"
    git -C ~/Projects/linux-phone-oco/sxmo-utils push https://github.com/grenudi/sxmo-utils.git \
      origin/master:refs/heads/master                            # sourcehut cannot be forked on GitHub: a mirror

## Sending, on the author's word

    # sxmo (after surya's proof): from a clone with the series applied, signed off by him
    git config format.subjectPrefix "PATCH sxmo-utils"
    git send-email --to "~mil/sxmo-devel@lists.sr.ht" patches/sxmo-utils/*.patch
    # kernel (after both phones' proofs): b4 prep in his tree, Assisted-by: LLM, his Signed-off-by
    b4 prep --auto-to-cc && b4 prep --check && b4 send --reflect && b4 send
