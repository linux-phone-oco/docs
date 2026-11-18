# What we carry, and what is ready for upstream (2026-11-19)

This inventory covers the surya kernel branches (linux-phone-oco/linux), the walleye lab dts and the
branches it builds, the grenudi/linux and grenudi/sxmo-utils forks, the surya-lab patches/ folder, and
the upstream-queue. The author asked for it on 2026-11-19, through the Top Coordinator.

Measured:
- checkpatch --strict on every commit;
- W=1 LLVM builds of the touched objects and dtbs;
- presence in v7.3 and next-20261118, checked by file content;
- hardware proof, from the labs' records.

Not measured: `dt_binding_check` and `dtbs_check`. dtschema is not installed, and installing it means
Python, which the guard refuses. lore.kernel.org is behind a bot check, so "never posted" was not
checked by subject.

## A gate every kernel commit fails today

No commit carries a human `Signed-off-by:`, so checkpatch reports 1 ERROR on each. Most commits are
authored by an agent identity and carry `Co-Authored-By: Claude`, which checkpatch also warns about.

At send time the author re-authors each commit and adds his own Signed-off-by. For AI disclosure:
- v7.3 `coding-assistants.rst` asks for `Assisted-by:`.
- next-20261118 has removed that tag (1e035297ffda, "docs: remove Assisted-by references").
- `generated-content.rst` still asks for the tools used to be named in the cover letter.

Safest: say it in the cover letter, and add `Assisted-by:` only while the target tree still asks for
it.

## (a) Ready

Nothing is ready yet. Every class (b) row below is ready apart from the sign-off and its listed gap.

## (b) Close

| # | Change | Where | Missing | Target |
|---|---|---|---|---|
| 1 | ASoC: tas2562: RX slot length matches the sample width in I2S | linux fix/tas2562-i2s-slot-length c2815377c; upstream-queue/linux/0001 | The author's SoB; rewrap the commit message to 75 columns; one run on a v7.3-based kernel (proven on the 7.1 base). Applies cleanly to v7.3 and next; W=1 clean. | ASoC: Mark Brown, Liam Girdwood, TI tas256x (Shenghao Ding, Kevin Lu, Baojun Xu); linux-sound |
| 2 | watchdog: pm8916_wdt: gen2 PON (PM8998/PM6150) | grenudi/linux topic/pmic-wdt-wake-in-suspend 59df2cc83 + f5bb57d27 + 8b2283da3 | The SoB. Settle the clk.c boot warning seen on surya calls2+ (open, stack being read). Walleye has only bitten 59df2cc83 (pass, z9); surya has bitten f5bb57d27 (pass, PR 276). | linux-watchdog: Guenter Roeck, Wim Van Sebroeck |
| 3 | dt-bindings: watchdog: qcom,pm8916-wdt: PM8998 | 11ca7029a, first half | Split off the wakeup-source half. Give PM6150 its own compatible with a fallback (`"qcom,pm6150-wdt", "qcom,pm8998-wdt"`): the DT maintainers ask for SoC-specific compatibles. Needs dt_binding_check. | devicetree + linux-watchdog |
| 4 | arm64: dts: qcom: pm8998 / pm6150: PMIC watchdog node | e123d3bff | Split per PMIC. The pm6150 node takes the new compatible pair. Needs dtbs_check. | linux-arm-msm: Bjorn Andersson, Konrad Dybcio |
| 5 | watchdog: pm8916_wdt: wakeup-source; keep running through suspend | 11ca7029a second half + 833162dcf | The proof pmic-wdt-wakes-in-suspend (surya); walleye does not suspend yet. Send after series 2–4. | linux-watchdog, devicetree |
| 6 | sxmo-utils: autosuspend backoff; stop profile-named services around suspend; surya profile names hexagonrpcd | grenudi/sxmo-utils topic/* 2bb2500, 1156bb6, 6432ef9 (lab-20261118.1) | Surya's attended proofs surya-sxmo-suspend-series (suspend-retry-backs-off, sensors-after-suspend). 1156bb6 changes google,b4s4-sdm670 (the daemon now restarts after suspend), which is untested on that phone: say so in the cover letter. Re-author; the commits have no SoB (sxmo applies with `git am -s`; whether it wants the author's own SoB is not known yet). | ~mil/sxmo-devel, "[PATCH sxmo-utils]", plain text |
| 7 | Walleye (Pixel 2) board dts | google-walleye-lab dt/msm8998-google-walleye.dts | Add a dt-bindings: arm: qcom patch for `google,walleye` (the 3-entry compatible needs a new items block, or drop `google,wahoo`). Strip the lab hacks (row c1). Drop `&pm8998_wdt` until series 3–4 merge. Comments in upstream style, no lab ids. dtbs_check. UFS can join after a recorded read-only lsblk proof: the z15–z20 dmesgs already show UFS enumerating on stock v7.3. Boots to a USB root shell (z14–z20). The 2021 taimen patch was never merged; no Pixel 2 dts is upstream. | linux-arm-msm + devicetree: Bjorn, Konrad, Rob Herring, Krzysztof Kozlowski, Conor Dooley |
| 8 | msm8998.dtsi: APSS watchdog node (qcom,kpss-wdt @17817000) | walleye lab dts | A SoC node: its own patch to msm8998.dtsi. Needs a bite-resets-the-phone proof. | linux-arm-msm |
| 9 | Walleye charger and battery (pmi8998_charger, simple-battery) | walleye lab dts; draft item walleye-charger-supplier-node | The proof that "online" follows the cable; the c3 restart hang resolved; no `status="disabled"` hack. | linux-arm-msm |
| 10 | ASoC: tas2562: don't list DVC_CFG1-4 as register defaults, so resume rewrites the volume | what is left of fix/tas2562-volume 2e6c6521d | Rewrite on v7.3 as one concern (mainline already has the rest), then a suspend/resume proof. Drop upstream-queue/linux/0002. | ASoC |
| 11 | pinctrl: sm7150-lpass-lpi: SoundWire data pin mux | fix/sm7150-lpass-lpi-swr-data-mux e67595401; upstream-queue sm7150-wcd/0001 | SoB. The driver is not in mainline: send to sm7150-mainline (Danila Tikhonov, Aelin Reidel) as a fixup. | sm7150-mainline |
| 12 | SM7150 LPASS SoundWire, macros, WCD9375, surya DAI links | cadeb5a68, 708930065, 12102e524, 413fc07dd, c93385cd9; upstream-queue sm7150-wcd/0002–0004 | Squash the fixups into the never-sent cadeb5a68. Split into S1 dt-bindings for the sm7150 rx/tx/va macro compatibles, S2 sm7150.dtsi LPASS, S3 xiaomi-common WCD9375 and reset, S4 surya DAI links (credit pulpoff). Mic proven (runs 20261117-044744, 20261118-232432). | sm7150-mainline first; mainline only after sm7150.dtsi lands |
| 13 | hexagonrpcd: serve a writable sns_reg_version | surya-lab patches/hexagonrpcd-sns-reg-version.patch | A commit message and the author's sign-off; rebase on hexagonrpc PR 27 once it merges. | github.com/linux-msm/hexagonrpc (PR) |

## (c) Local only

- **Walleye dtbo-overlay workarounds:** 126 stub nodes, `/delete-node/ &pcie0`, i2c5 renamed to `qup@c179000`, the disabled tps61099, `-@`.
- **Walleye:** `&adreno_smmu` disabled. Touch (RMI4) not working yet.
- **Walleye panel:** the s6e3fa5 panel driver (WIP, never built).
- **Lab tooling:** the walleye config fragments and initramfs and boot-image tooling.
- **Surya modem call audio:** q6voice, 29d92793b from pulpoff/sdm845-mainline. Its own Kconfig says "solely hacked up". It would need a real design, bindings and the original authors' SoB chain.
- **Integration branches:** test/surya-mic, test/surya-calls, keeper5/lpass-macro-idle-votes.
- **surya-lab qcom-wdt-keep-armed-in-suspend.patch:** a module-parameter workaround. Decision 2026-11-18-resume-stall-way chose the sysctl panic plus the PMIC watchdog instead.
- **UFS Hynix quirks** (topic/ufs-hynix-quirks): speculative, never run, and UFS enumerates without them.
- **The empty branch dt/surya-wcd-rx-channel-map:** no commits.

## (d) Already upstream or superseded

- **sxmo-utils deviceprofiles xiaomi,surya:** sent 2026-11-17 and applied upstream (1fd7822). The fork's branch is deleted.
- **Most of fix/tas2562-volume** (table, clamp, write order, return 1): already in v7.3.
- **LPASS macros dropping hw votes at runtime suspend** (research patch): mainline's macros already release every clock through pm_clk.
- **surya-lab pinctrl-sm7150-lpass-lpi-swr-mux.patch:** replaced by e67595401.

## Targets in brief

- **New board dts:** first a dt-bindings: arm: qcom patch adding the compatible, then the dts. Must pass `dtbs_check` with no new warnings and `dt-check-style`. Properties go compatible, reg, …, status last; nodes are sorted by unit address. Use `GPL-2.0-only OR BSD-3-Clause`. Put a changelog on every v2.
- **SoC dtsi:** neither v7.3 nor next has sm7150.dtsi. The 2025 v1 by Tikhonov got no v2. So every surya dts patch waits on the sm7150-mainline team; walleye can build on the msm8998.dtsi already in mainline.
- **Bindings:** the binding comes before its user, and the whole series goes to devicetree@vger.
- **Fixes:** fixes first, with `Fixes:`; one concern per patch; `--base=auto`; wait a week before a ping.
- **b4:** `b4 prep`, `--auto-to-cc`, `--check`, then `b4 send --reflect`. The web endpoint works for senders without SMTP but needs a patatt key. b4 is not installed here.
- **sxmo-devel:** subjectPrefix "PATCH sxmo-utils", plain text, git send-email. The setup is in ~/sxmo-send on the lab machine.
- **Nura (postmarketOS) pmaports forbids generative-AI contributions.** We carry nothing for it, and nothing made here should go there.

## Order for the author

1. **tas2562 slot length (#1):** one patch, after his SoB and a v7.3 run.
2. **sxmo suspend series (#6):** once surya's attended proofs pass.
3. **PMIC watchdog gen2:** #3 + #4 (pm8998 half) + #2, after the clk warning is cleared. The pm6150 half comes with the PM6150 compatible.
4. **Walleye dts (#7):** after the trim and a dtbs_check.
5. **Watchdog in suspend (#5),** then **msm8998 APSS wdt (#8),** **charger (#9)** and **tas2562 resume (#10),** each after its proof.
6. **sm7150-mainline (#11, #12):** a pull request or mail to that team, not to mainline.
