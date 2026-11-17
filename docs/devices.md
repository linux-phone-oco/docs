<!-- Generated from data/ by tad. Do not edit by hand. -->

# Devices

<a id="xiaomi-surya"></a>
### Xiaomi POCO X3 NFC

Codename
: surya

Soc
: Qualcomm SM7150 (Snapdragon 732G)

Notes
: Mainline-kernel support tracked by the sm7150-mainline community; Nura (formerly postmarketOS) package status: community. The device name includes NFC; that refers to the stock Android feature, not yet confirmed working under mainline (see the nfc component).

Sources
: [linux-postmarketos-qcom-sm7150: the sm7150-mainline kernel fork and its changelog across releases](https://gitlab.postmarketos.org/postmarketOS/pmaports/-/merge_requests/4818), [device-xiaomi-{davinci,surya}: Move from testing to community](https://gitlab.postmarketos.org/postmarketOS/pmaports/-/merge_requests/6210), [sm7150-mainline: the community org hosting the kernel fork, nightly builds, and firmware repos](https://github.com/orgs/sm7150-mainline/repositories), [lab-agent: the pull-based agent that runs jobs on the real phone and reports back through git](https://github.com/creation-guidelines/lab-agent)


<a id="google-taimen"></a>
### Google Pixel 2 XL

Codename
: taimen

Soc
: Qualcomm MSM8998 (Snapdragon 835)

Notes
: Surveyed from published sources on 2026-11-17, never touched: nothing is measured here, so every part is unknown. The Nura (postmarketOS) wiki reports mainline boots with a basic device tree, USB networking and flashing, no display (kernel 5.10-rc2); the port is out of tree (kcxt/linux-wahoo, last pushed 2022-02-27), with no mainline device tree and no pmaports package. Same SoC and kernel tree as walleye (Pixel 2).

Sources
: [Nura (postmarketOS) wiki: Google Pixel 2 XL (google-taimen)](https://wiki.nura.eco/wiki/Google_Pixel_2_XL_%28google-taimen%29), [kcxt/linux-wahoo: Mainline Linux for the Google Pixel 2XL (And 2?)](https://github.com/kcxt/linux-wahoo), [Linux mainline: arch/arm64/boot/dts/qcom (MSM8998 device trees)](https://github.com/torvalds/linux/tree/master/arch/arm64/boot/dts/qcom), [Nura pmaports: device packages of Google phones (device/community, device/testing)](https://gitlab.nura.eco/nura/pmaports/-/tree/master/device/testing), [LineageOS wiki: Google Pixel 2 (walleye)](https://wiki.lineageos.org/devices/walleye/), [AOSP: Build Pixel kernels (legacy branches)](https://source.android.com/docs/setup/build/building-pixel-kernels), [Nura wiki: OnePlus 5 (oneplus-cheeseburger), the MSM8998 phone best supported in mainline](https://wiki.nura.eco/wiki/OnePlus_5_%28oneplus-cheeseburger%29)


<a id="google-walleye"></a>
### Google Pixel 2

Codename
: walleye

Soc
: Qualcomm MSM8998 (Snapdragon 835)

Notes
: Surveyed from published sources on 2026-11-17, never touched: nothing is measured here, so every part is unknown. No Nura wiki page, no pmaports package, no mainline device tree; only the out-of-tree fork kcxt/linux-wahoo (last pushed 2022-02-27) carries a walleye device tree, and no source says it boots. The smaller sibling of taimen (Pixel 2 XL), same SoC.

Sources
: [kcxt/linux-wahoo: Mainline Linux for the Google Pixel 2XL (And 2?)](https://github.com/kcxt/linux-wahoo), [Linux mainline: arch/arm64/boot/dts/qcom (MSM8998 device trees)](https://github.com/torvalds/linux/tree/master/arch/arm64/boot/dts/qcom), [Nura pmaports: device packages of Google phones (device/community, device/testing)](https://gitlab.nura.eco/nura/pmaports/-/tree/master/device/testing), [Ubuntu Touch: Google Pixel 2 (walleye), old releases](https://devices.ubuntu-touch.io/device/walleye/), [LineageOS wiki: Google Pixel 2 (walleye)](https://wiki.lineageos.org/devices/walleye/), [AOSP: Build Pixel kernels (legacy branches)](https://source.android.com/docs/setup/build/building-pixel-kernels), [Nura wiki: OnePlus 5 (oneplus-cheeseburger), the MSM8998 phone best supported in mainline](https://wiki.nura.eco/wiki/OnePlus_5_%28oneplus-cheeseburger%29)
