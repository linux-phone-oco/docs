# PMIC watchdog gen2, v1: what to check and how to send (prepared 2026-11-19)

These are the six patches and cover letter in this folder (upstream/linux-watchdog/pmic-wdt-gen2-v1/; until 2026-11-20 in research/upstream-forks/2026-11-19/). They were made on next-20261118 and
rebased on 2026-11-20 onto next-20261119 (base adcad7f4e), where they apply unchanged. Nothing has
been sent. Sending is the author's decision, from his own clone, with his own
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

## Tested on the Pixel 2 (2026-11-20)

walleye-try-pmic-wdt-v1 (google-walleye-lab PR 624), with the author at the phone: image A, which is
this series on next-20261118. The run log is ~/lab-material/walleye/pmic-wdt-v1-run-1795130247.log
(26 steps, all passed).
- **Probe (patch 1):** the firmware left the S2 type at 0x1; the driver set 0x7 and the read-back
  passed.
- **Reboot (patch 2): PASS.** Armed with type 0x07, then a clean reboot. Android came up and stayed
  up for 180 s with no loop. When the image was booted again, S2 read as off.
- **Bite: PASS.** Armed and not pinged, the PMIC reset the phone about 20 s after arming. Android's
  boot reason was [reboot], and it stayed up 60 s with no loop.
- **Caveat, carried in the cover letter:** after the bite, with USB connected, the bootloader
  stopped in its off-mode charging screen, and Android needed a press of the power button (the
  author's report, through the Top Coordinator). The run's automatic check saw Android back 112 s
  after arming, so it can't tell this from a restart on its own. A hard reset (type 0x07) with a
  charger attached is booted as a charger power-on by this bootloader. That is the bootloader's
  choice, not the driver's. Not read: the watchdog's bootstatus (WDIOF_CARDRESET).

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

- **A restart with no charger attached** on the Pixel 2: the bite ran with USB in only, and ended in
  the bootloader's charging screen.
- **bootstatus** after a bite: not read on either phone.
- **The rebased tree** (next-20261119): built and checked, not booted. The phone ran the same six
  patches on next-20261118, and they apply unchanged.
- **Surya** ran a 7.1 backport that also carried the suspend patch, which this v1 leaves out.
- **pmic-wdt-wakes-in-suspend:** not run. It belongs to the later suspend series, not to this v1.

## Re-checked on next-20261119 (2026-11-20)

The six patches applied unchanged with `git am`.
- LLVM W=1 build of pm8916_wdt.o and of the cheeseburger, joyeuse and acer-aspire1 dtbs: exit 0, no
  warnings from our files.
- `checkpatch --strict`: the same as on next-20261118. The only problems are the missing
  Signed-off-by on each patch, and the unknown Fixes id on patch 1, which is unknown only because the
  clone is shallow.
- `lpoco-bringup dt-check binding` (qcom,pm8916-wdt.yaml): clean, exit 0.
- `lpoco-bringup dt-check dtbs` on the same three boards, with both new nodes set to okay: clean,
  exit 0.

## On hold (2026-11-20)

The author, through the Top Coordinator: "lets hold on them for now, good thing they are prepared. just
in case we stumble upon something more while working on walleye that is relative to those patches".
The series stays prepared and unsent. When one of the items below lands, re-check the series against it
and tell the Top Coordinator whether it changes:

| Open item | Where | What it could change |
|---|---|---|
| walleye-wdt-reset-boots-charger-mode | google-walleye-lab | If a warm-reset type or a PON setting is the answer, patch 1's reset type (0x07) may change, as a property or a later patch |
| bootstatus (WDIOF_CARDRESET) after a bite | not read on either phone | Perhaps a driver addition, if the gen2 POFF reason does not read as a card reset |
| surya's PM6150 bite: attended-keep-calls4-for-bite (way-back.sh fuse-pmic) | surya-lab | The PM6150 half of the testing paragraph. Until then the cover letter claims only the probe and read-back on PM6150 |
| A restart with no charger attached: walleye-wdt-bite-cable-out | google-walleye-lab | The Pixel 2 testing sentence: whether it reads as a plain restart |

**Correction (2026-11-20):** the earlier cover letter said a bite restarts the POCO X3 NFC, and that a
bite before patch 2 looped. That came from surya-lab PR 276. Surya's research
bite-pon-and-calls4-choice shows that the fuse armed the APSS watchdog, never the PMIC's. POFF read
0x00, with no PMIC_WD bit. So no PM6150 bite is proven. The cover letter now says only that the driver
probes there and that the type read-back passes. Patch 2's reason stands on the Pixel 2's reboot test
and on the PON's design (S2 is not reset by a SoC reset), not on a surya observation.
