<!-- Generated from data/ by tad. Do not edit by hand. -->

# Sources

<a id="sm7150-mainline-kernel"></a>
### linux-postmarketos-qcom-sm7150: the sm7150-mainline kernel fork and its changelog across releases

Url
: https://gitlab.postmarketos.org/postmarketOS/pmaports/-/merge_requests/4818

Year
: 2026

Cited by
: [Xiaomi POCO X3 NFC](devices.md#xiaomi-surya)


<a id="pmos-community-promotion"></a>
### device-xiaomi-{davinci,surya}: Move from testing to community

Url
: https://gitlab.postmarketos.org/postmarketOS/pmaports/-/merge_requests/6210

Cited by
: [Xiaomi POCO X3 NFC](devices.md#xiaomi-surya)


<a id="sm7150-mainline-org"></a>
### sm7150-mainline: the community org hosting the kernel fork, nightly builds, and firmware repos

Url
: https://github.com/orgs/sm7150-mainline/repositories

Cited by
: [Xiaomi POCO X3 NFC](devices.md#xiaomi-surya)


<a id="lab-agent-repo"></a>
### lab-agent: the pull-based agent that runs jobs on the real phone and reports back through git

Url
: https://github.com/creation-guidelines/lab-agent

Author
: grenudi

Year
: 2026

Cited by
: [Xiaomi POCO X3 NFC](devices.md#xiaomi-surya)


<a id="sm7150-dtsi-v72"></a>
### sm7150-mainline's sm7150.dtsi (branch v7.2): CPU and cluster idle states, PSCI domains, apps_rsc on the cluster domain, rpmh-stats

Url
: https://github.com/sm7150-mainline/linux/blob/v7.2/arch/arm64/boot/dts/qcom/sm7150.dtsi


<a id="surya-downstream-fdt"></a>
### sm7150-mainline/downstream-fdt: the device trees of the phones' own Android kernels (fdt-surya: lpm-levels, rpm-stats)

Url
: https://github.com/sm7150-mainline/downstream-fdt


<a id="sm7150-upstream-series"></a>
### Danila Tikhonov: the SM7150 upstreaming series (v1, 2025-04-22)

Url
: https://lore.kernel.org/linux-arm-msm/?q=s%3Asm7150+d%3A2025-04-21..2025-04-24


<a id="psci-osi-hierarchy"></a>
### LWN: hierarchical CPU idle and PSCI OS-initiated mode (Ulf Hansson's series)

Url
: https://lwn.net/Articles/788306/


<a id="rpmh-rsc-cluster-pd"></a>
### rpmh-rsc: attach RSC to the cluster PM domain - sleep votes flushed when the cluster powers off (Ulf Hansson, 2022)

Url
: https://github.com/torvalds/linux/commit/25092e6100ac


<a id="sm8150-cluster-idle"></a>
### sm8150.dtsi in mainline: one cluster sleep state, PSCI parameter 0x4100c244

Url
: https://github.com/torvalds/linux/blob/master/arch/arm64/boot/dts/qcom/sm8150.dtsi


<a id="qcom-stats-binding"></a>
### The qcom-stats binding: the SoC's sleep counters (aosd, cxsd, ddr, per subsystem)

Url
: https://kernel.org/doc/Documentation/devicetree/bindings/soc/qcom/qcom-stats.yaml


<a id="qcom-soc-sleep-states"></a>
### Qualcomm: SoC power-saving states (CXSD, AOSD) on QCS6490

Url
: https://docs.qualcomm.com/doc/80-70020-30/topic/qcs6490-soc-power-saving-state.html


<a id="portareos-sleep-votes"></a>
### PortareOS issue 62: aosd/cxsd/ddr stuck at 0 on QCS8550 until the USB, PCIe and LPASS votes were released (2026-10)

Url
: https://github.com/portare-ch/portareos/issues/62


<a id="pmaports-sargo-hexagonrpcd"></a>
### pmaports, google-sargo: hexagonrpcd's sensors helper stopped before suspend, the DSP crashing otherwise

Url
: https://ayakael.net/forge/pmaports/src/commit/bb5d9920e19c018b0ed69e2710b147c210aa5b4c/device/testing/device-google-sargo/no-hexagonrpcd-on-suspend.sh


<a id="nura-sdm845-wiki"></a>
### Nura (postmarketOS) wiki, SDM845: s2idle only; waking for calls through the modem's IPCRTR glink wakeup

Url
: https://wiki.nura.eco/wiki/Qualcomm_Snapdragon_845/850_(SDM845/SDM850)


<a id="nura-enchilada-wiki"></a>
### Nura (postmarketOS) wiki, OnePlus 6: ModemManager's quick suspend/resume and the IPCRTR wakeup

Url
: https://wiki.nura.eco/wiki/OnePlus_6_(oneplus-enchilada)


<a id="nura-sm7150-wiki"></a>
### Nura (postmarketOS) wiki, SM7150: suspend listed as working, no detail

Url
: https://wiki.nura.eco/wiki/Qualcomm_Snapdragon_730/730G/732G_(SM7150)


<a id="pmaports-4194"></a>
### pmaports 4194: calls signalled late or lost across suspend - fixed by ModemManager's quick suspend/resume

Url
: https://gitlab.nura.eco/nura/pmaports/-/work_items/4194


<a id="pmaports-4989"></a>
### pmaports 4989: waking from suspend for calls does not work (OnePlus 6/6T, Pixel 3a; open)

Url
: https://gitlab.nura.eco/nura/pmaports/-/work_items/4989


<a id="pmaports-4783"></a>
### pmaports 4783: with the modem wakeup on, every modem event wakes the phone; Wi-Fi blocks suspend

Url
: https://gitlab.nura.eco/nura/pmaports/-/work_items/4783


<a id="pmaports-4823"></a>
### pmaports 4823: surya wakes at random while asleep (open)

Url
: https://gitlab.nura.eco/postmarketOS/pmaports/-/work_items/4823


<a id="ut-surya"></a>
### Ubuntu Touch on surya: Halium 10 with the vendor's 4.14 kernel

Url
: https://devices.ubuntu-touch.io/device/surya/


<a id="crust-pinephone"></a>
### Crust on the PinePhone: deep sleep on a separate power-management core

Url
: https://pine64.org/documentation/PinePhone/Software_tricks/Crust/


<a id="lwn-autosleep"></a>
### LWN: Android's opportunistic suspend in mainline - wakeup sources and autosleep

Url
: https://lwn.net/Articles/479841/


<a id="uninsane-push"></a>
### Push notifications through suspend on the PinePhone: WoWLAN and an RTC safety net (2023)

Url
: https://uninsane.org/blog/mobile-linux-push-notifications/


<a id="soc-sleeps-check"></a>
### lab-tools: the soc-sleeps check - the SoC's own sleep counters after every boot

Url
: https://github.com/linux-phone-oco/lab-tools/blob/main/health/suite/checks/base/90-sleep.sh
