<!-- Generated from data/ by tad. Do not edit by hand. -->

# Landscape

<a id="pmos-initramfs-tests"></a>
### Initramfs CI hook and test packages

Project
: postmarketOS

What
: postmarketos-mkinitfs-hook-ci runs tests inside the initramfs; tests ship as small subpackages that install themselves for the right device (postmarketos-test-suspend, -unl0kr).

For us
: Our automatic checks and the test kernel's timeout hook belong in this shape, so they can go upstream and run in their CI.

Link
: https://docs.postmarketos.org/pmaports/main/ci/hardware-ci.html

Checked
: 2026-11-10


<a id="bootrr"></a>
### bootrr

Project
: Linaro / postmarketOS

What
: Checks that every expected driver probed on a booted device; packaged in pmaports for the CI hook.

For us
: Replaces our hand-made waiting-to-probe checks with the established tool.

Link
: https://gitlab.com/postmarketOS/pmaports/-/merge_requests/4420

Checked
: 2026-11-10


<a id="pmos-deviceinfo"></a>
### Device packages and deviceinfo

Project
: postmarketOS

What
: Each device package carries a deviceinfo file - codename, name, architecture, flash method, device tree - the device's manifest.

For us
: Our device.toml derives from deviceinfo and adds only what it lacks (how the lab reaches the phone), rather than duplicating it.

Link
: https://docs.postmarketos.org/hardware-ci

Checked
: 2026-11-10


<a id="ci-tron"></a>
### CI-tron

Project
: freedesktop.org (gfx-ci)

What
: A bare-metal testing gateway: deploys test environments to devices, sequences power and boot, collects logs; devices are trained through boot cycles before they take jobs.

For us
: The gateway our lab machine could become, instead of growing its own.

Link
: https://docs.postmarketos.org/hardware-ci/gateway.html

Checked
: 2026-11-10


<a id="mobian-recipes"></a>
### mobian-recipes

Project
: Mobian

What
: Debian images built with debos; devices grouped in families by SoC; device packages (<device>-tweaks); weekly CI image builds. Points to the postmarketOS wiki to judge whether a device runs mainline.

For us
: Consumes mainline device support rather than building it: surya reaches Mobian through mainline and a family recipe, after pmOS.

Link
: https://wiki.debian.org/Teams/Mobian/DevelopersGuide

Checked
: 2026-11-10


<a id="pmos-hardware-ci"></a>
### postmarketOS hardware CI

Project
: postmarketOS

What
: Tests on real phones: CI-tron as the testing gateway, power units that switch devices and press buttons, GitLab pipelines generated per device from a template in its package; scaling toward a farm of dozens of devices (talk at the 2026 conference).

For us
: Our lab is a one-phone version of it. Aim: surya as a device under test in their farm, our tests in their shape - contributed, not kept apart.

Link
: https://docs.postmarketos.org/hardware-ci

Checked
: 2026-11-10
