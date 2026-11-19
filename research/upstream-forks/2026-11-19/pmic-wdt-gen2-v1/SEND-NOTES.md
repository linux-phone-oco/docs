# PMIC watchdog gen2, v1: what to check and how to send (prepared 2026-11-19)

These are the six patches and cover letter in this folder, made on next-20261118 (base e8017d290).
Nothing has been sent. Sending is the author's decision, from his own clone, with his own
Signed-off-by.

## The series

1. watchdog: pm8916_wdt: Set the reset type with S2 disabled, and check it. A fix, with
   `Fixes: 066951ca33ce`.
2. watchdog: pm8916_wdt: Stop the watchdog on reboot and unregister.
3. dt-bindings: watchdog: qcom,pm8916-wdt: Add PM8998 and PM6150. The PM6150 compatible is
   "qcom,pm6150-wdt", "qcom,pm8998-wdt".
4. watchdog: pm8916_wdt: Support the second generation PON.
5. arm64: dts: qcom: pm8998: Describe the PMIC watchdog.
6. arm64: dts: qcom: pm6150: Describe the PMIC watchdog.

This is the single-concern first series of the inventory (upstream-readiness.md, item 2 with 3 and 4).
"Keep running through suspend" and wakeup-source stay out. They go later, after
pmic-wdt-wakes-in-suspend is proven.

## Measured on next-20261118

- LLVM W=1 build of pm8916_wdt.o: clean.
- `checkpatch --strict`: each patch's only error is the missing Signed-off-by, which is his to add. On
  patch 1 it also warns that the Fixes id is unknown; that's because the clone is shallow. The commit
  exists upstream: 066951ca33ce, "watchdog: pm8916_wdt: Handle watchdog enabled by bootloader".
- `dt_binding_check` for qcom,pm8916-wdt.yaml: clean.
- CHECK_DTBS W=1 on cheeseburger (pm8998), joyeuse and acer-aspire1 (pm6150), with both new nodes
  set to okay for the check: no warnings from our nodes. There are existing W=1 warnings in
  pm8005, msm8998 and sc7180, and none of them are ours.

## Before sending

1. **Re-author and sign off.** Every commit is authored by an agent identity. Set each author to
   himself and add `Signed-off-by:`, then regenerate:
   `git rebase --exec 'git commit --amend --no-edit --reset-author -s' BASE`, then
   `git format-patch --cover-letter --base=auto`.
2. **AI disclosure.** linux-next removed `Assisted-by:` (1e035297ffda), and its checkpatch rejects the
   tag. generated-content.rst asks for transparency in cover letters and changelogs instead. So each
   commit message says "Written with an AI coding assistant (Claude); reviewed and tested as described
   in the cover letter", and the cover letter says it too. If he prefers a different wording, or the
   v7.3-style trailer, it's his call.
3. **"reviewed by me".** The cover letter says this, so it's only true once he has read the patches.
4. **Rebase.** Rebase onto the newest linux-next, or watchdog-next, on the day of sending, and re-run
   build, checkpatch and the dt checks. dt checks: `lpoco-bringup dt-check` once its image is
   published. Until then, the container one-liner in research/upstream-forks/2026-11-19/
   dt-checks-in-a-container.md; read its output, and remember disabled nodes are skipped.

## Open on hardware

- Patch 1 on a PM8998 (walleye): the case it is meant for, not yet tested (parked in the walleye
  lane). The cover letter says so.
- Patch 2's stop-on-reboot path: not exercised explicitly on a phone.

## Recipients (scripts/get_maintainer.pl)

    To: Wim Van Sebroeck <wim@linux-watchdog.org>
    To: Guenter Roeck <linux@roeck-us.net>
    Cc: Rob Herring <robh@kernel.org>
    Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
    Cc: Conor Dooley <conor+dt@kernel.org>
    Cc: Bjorn Andersson <andersson@kernel.org>
    Cc: Konrad Dybcio <konradybcio@kernel.org>
    Cc: Abel Vesa <abelvesa@kernel.org>
    Cc: linux-watchdog@vger.kernel.org
    Cc: devicetree@vger.kernel.org
    Cc: linux-arm-msm@vger.kernel.org

Patches 5–6 go through the Qualcomm tree (Bjorn). The rest go through watchdog (Guenter/Wim).
Sending them as one series is common; the cover letter can say which tree takes which.

## Send (his clone, after the steps above)

    git send-email --to=wim@linux-watchdog.org --to=linux@roeck-us.net \
      --cc=robh@kernel.org --cc=krzk+dt@kernel.org --cc=conor+dt@kernel.org \
      --cc=andersson@kernel.org --cc=konradybcio@kernel.org --cc=abelvesa@kernel.org \
      --cc=linux-watchdog@vger.kernel.org --cc=devicetree@vger.kernel.org \
      --cc=linux-arm-msm@vger.kernel.org 00*.patch

Or use b4: `b4 prep`, then `--auto-to-cc`, `--check`, and `b4 send --reflect` first.

## Re-checked with the baked dt-check image (2026-11-19, later)

`lpoco-bringup dt-check` 0.22.2, image lpoco-dt-check@sha256:632e25f8b283… (local, docs #606), on the
v1 tree:
- `binding` (qcom,pm8916-wdt.yaml): clean.
- `dtbs` on cheeseburger, joyeuse and acer-aspire1, with the new nodes set to okay: clean, exit 0.
  This verb fails on violations: a bogus property gives 3 violations and exit 1 (orchestration's
  run).

## Not proven, in full

- **Patch 1 on a PM8998.** walleye's bite at 8b2283da3 hasn't run. walleye's earlier bite, without
  patch 1, powered the phone off.
- **Patch 2's stop-on-reboot path:** not exercised explicitly.
- **Testing base.** All hardware runs were on backported trees: sm7150-mainline 7.1 on surya, v7.3 on
  walleye. The surya runs also carried the suspend patch, which this v1 leaves out. The next-based v1
  itself is built and checked only, never booted.
- **pmic-wdt-wakes-in-suspend:** not run. It belongs to the later suspend series, not to this v1.
