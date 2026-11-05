<!-- Generated from data/ by .tad/tools/render.py. Do not edit by hand. -->

# Backlog

<a id="first-real-boot"></a>
### Boot the current sm7150-mainline kernel on the phone via lab-agent and record dmesg + audio card list

Status
: open

Note
: The first real job: proves the whole lab-agent loop end to end on real hardware, and gives a verified baseline instead of secondhand notes.

Opened
: 2026-11-04


<a id="kernel-fork-repo"></a>
### Fork sm7150-mainline/linux into linux-phone-oco and wire it into lab-agent's build/boot jobs

Status
: open

Opened
: 2026-11-04


<a id="custom-matrix-render"></a>
### A custom render.py that draws support_status as a real device x component matrix, not one page-section per row

Status
: open

Note
: The generic engine renders it as plain rows for now (it has no reason to detect this shape specially); a matrix is much easier to scan at a glance once there is more than one device.

Opened
: 2026-11-04


<a id="verify-headphone-mic-earpiece"></a>
### Verify headphone, mic and earpiece status directly on hardware instead of relying on the secondhand pmaports note

Status
: open

Note
: The source only confirms mic/earpiece are broken as a group; headphone output specifically was never separately confirmed one way or the other.

Opened
: 2026-11-04
