# What is held before a sleep cycle on surya - floor-read-holders (keeper surya-keeper-9, 2026-11-17)

Read only (decision 2026-11-17-floor-research-path, step 1). Kept kernel 7.1.0-sm7150-calls+, stock initramfs,
swmo shell, no SIM, USB gadget up (devlab), Bluetooth on. Taken on the phone twice: at idle (`idle-first-read.txt`)
and by a transient unit seconds before `way-back.sh cycle 15 bt-on` (`*-before-cycle.txt`; the cycle's own output
is quoted below). Each file is the debugfs file as the kernel printed it.

**Not known yet:** what is held *inside* the late-suspend phase. The kernel has no hook there and debugfs cannot
be read while the phone sleeps, so every holder below is "on before the suspend"; what the device suspend callbacks
drop is not read. The screen was on at both reads (dsi, mdp, dispcc_pll0 are therefore on in the files).

## The cycle this is measured against (baseline for the subtractions)

`way-back.sh cycle 15 bt-on`: real s2idle (suspend entry ... suspend exit, asleep 17 s by the RTC for 15 asked), hci0
present after. qcom_stats before and after: cxsd 0 / 0, aosd 0 / 0, ddr 0 / 0, adsp 0 / 0; cdsp 60 / 60 (its count
does not move, it sleeps only on its own schedule); modem 2137 -> 2147 (the modem does enter its sleep).
soc-sleeps stays "not passing" (cxsd and aosd 0): this is the baseline every later change is read against.

## Answers to the item's questions

- **cmdline**: `quiet splash plymouth... pmos_boot_uuid=... pmos_root_uuid=... pmos_rootfsopts=defaults`
  (+ two initrds). **No clk_ignore_unused, no pd_ignore_unused**, no module_blacklist. So step (3) of the decision
  (floor-no-ignore-unused) does not apply: it is closed as "not the cause, not set".
- **genpd** (`pm_genpd_summary`): `cx` is ON at performance 256 and `mx` ON at 256 (cx's parent). The cx
  children that are *active*: `88c000.serial` (perf 256 - the Bluetooth UART, the wake-source one) and
  `a88000.serial` (perf 64). Everything else under cx is runtime-suspended, **including all three remoteproc
  domains** (genpd:0/1/2 of 4080000 modem, 8300000 cdsp, 62400000 adsp: suspended, mss/lcx/lmx/mx_ao/gfx off).
  Also ON: `usb30_prim_gdsc` (a6f8800.usb active), `ufs_phy_gdsc` (ufshc active), and the seven
  `hlos1_vote_*_tbu_gdsc` (HLOS votes, always on). Off: all camcc, vcodec, venus, mdss_gdsc, gx, gfx, pcie, mss.
- **clk** (enable_count > 0, outside display): `bi_tcxo` 167-177 users, among them **the three remoteprocs' `xo`
  (4080000, 8300000, 62400000)**, ufshc ref_clk, usb phy ref, sdhci (8804000.mmc), dsi byte; `bi_tcxo_ao` via gcc_cpuss;
  UFS (tx/rx symbol, ahb, axi, unipro, aux, ice, mem_clkref: all on, ufshc "active"); USB (usb30 master, mock_utmi,
  sleep, ahb2phy, gpll0 x3, gpll0_out_even x4); qup wrap0/1 ahb; gcc_npu_cfg_ahb_clk (held by the NPU SMMU
  iommu@5040000); LPASS_HW_MACRO 3 / NPL_MCLK 2 / TX_CORE_MCLK 4 / fsgen 2 (the macros, known, no effect twice);
  dispcc (screen on). **Not on at all: ln_bb_clk, rf_clk, camcc, videocc, gpucc** (the rpmh bb/rf clocks are not
  held; gpu/video/camera clocks are not held).
- **regulator** (use_count>0): vph_pwr 6; smps8 2 (ldo2 1 = wcn3998 vddrf, ldo3 1 = ufs phy vdda-pll and dsi vdda);
  ldo1 1 (wcn3998 vddxo); bob 5 (mic-bias, wcn vddch0/ch1, ldo17 usb pdphy / dpdm, ldo11); ldo10 wcn vddch0;
  ldo12 ufs vccq2 (600 mA load); ldo15 audio-codec vdd-buck; ldo17 typec pdphy + usb dpdm. The WCN3998 (Bluetooth
  in this cycle) holds five rails. mmc vmmc/vqmmc 0.
- **icc** (`interconnect_summary`): ebi/llcc avg 240000 kB/s, peak 12288000 (idle read 8752000): the average is
  **a6f8800.usb alone** (xm_usb3_0 240000/700000; gadget up); the peak is **cpu0 (and cpu6 smaller)** votes
  (tag 3). ufshc peak 149422. Nothing from adsp/cdsp/modem; ipa 0. The DDR freq table counts 1353 MHz and 200 MHz
  most (ddr_stats' LPM rows are all 0, ddr_stats freq rows move).
- **wakeup_sources**: `devlab-usb` is active the whole time (active_since == total_time, 1.3e6 ms), `sxmo_*`
  inactive-after-use, `pm8150b-charger`, `qcom_qg`, `tcpm-source-psy`: none of these is the soc counters' holder, but
  `devlab-usb` is the USB gadget wake lock: the cycle itself lets the gadget go (soft_connect disconnect) before
  s2idle, so USB is a *candidate holder only if it does not release*: read `a6f8800.usb` runtime state at late suspend
  (not known yet).
- **cpuidle**: cpu0/4/7 enter WFI, cpu-sleep-0-0 / -0-1 (silver, gold prime): cluster idle states are used
  (cpu0 sleep-0-1 65816 uses; cpu7 sleep-1-1 11644 uses), consistent with the cluster-params research
  (the cluster is in S2; the SoC counters stay 0).

## What this says about the next subtractions (a reading, not a result)

1. The three **remoteprocs hold `bi_tcxo` (xo) as plain clock consumers** and are the only xo users that exist
   in the DSPs' name: floor-dsps-never-started (module_blacklist=qcom_q6v5_pas) takes exactly these away. Their
   genpds (cx/mx votes) are runtime-suspended here, so the cx/mx vote that remains at 256 comes from the
   **serial ports** (88c000 BT uart perf 256, a88000 perf 64) and the clk/regulator users above - candidates, not
   measured.
2. The BT UART (88c000) is an active child of cx at perf 256 with its wakeup disabled for bt-on: a cx performance
   holder that the "bt off" cycle would not have (bt-on is the baseline of every cycle, so that is the difference
   to read in one cycle: baseline bt-on vs the default blocked).
3. USB (usb30 gdsc, master clk, gpll0, icc avg 240000 on ebi) and UFS (gdsc, clocks, vccq2 600 mA, icc) are on
   at the read; UDC disconnect in the cycle releases USB's icc only if the gadget driver does - UDC subtraction is
   its own cycle.
4. The cpu icc peak votes (up to 12.3 GB/s on ebi) are cpufreq's and are not dropped at s2idle: candidate for the
   ddr counter (DDR is at 1353 MHz for a large share of the time at idle). Unmeasured whether the cluster idle path
   drops them (osm_l3 peak 41.8 MB/s stays).
5. Not held: ln_bb/rf rpmh clocks, camera/video/gpu clocks and gdscs, gx/gfx/mss/lcx/lmx domains. So those are not
   what keeps cx/aosd up.
