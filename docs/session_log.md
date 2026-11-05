<!-- Generated from data/ by .tad/tools/render.py. Do not edit by hand. -->

# Session Log

<a id="docs-repo-created"></a>
### The docs repo: schema, style, and an honest first seed of what is actually known

Entry date
: 2026-11-04

Done
: Created linux-phone-oco/docs from text-as-data-template. Schema: devices, components, support_status (the matrix), device_sources, plus the template's backlog/session_log/sources. Adopted software-engineering-canon's RFC-like Jekyll theme verbatim (monospace, uniform heading size, definition-list field/value rendering, 72-character width) rather than inventing a new one, since it already does exactly what was asked for and is proven. Seeded one device (xiaomi-surya) and 19 components with status, citing only what was actually confirmed by search earlier in the session; everything not confirmed is marked unknown rather than guessed.

Considered
: Reusing ideal-project-playbook's concepts/relations schema for this too.

Rejected
: Concepts/relations model general, reusable PRINCIPLES with their relationships; a hardware support matrix is a different shape (a fact about one device and one component, not a principle), and forcing it into that model would be more awkward than a purpose-built pair of tables.

---


<a id="first-fastboot-probe"></a>
### The phone, for real: bootloader unlocked, product confirmed, two jobs run end to end

Entry date
: 2026-11-05

Done
: Ran the first two real jobs through lab-agent against the physical device: a read-only USB probe (0001, phone not connected at the time) and fastboot getvar all (0002, phone connected). Confirmed for real: product=surya (matches the docs repo's device id), unlocked=yes, kernel=uefi, secure=yes, serial fcbd04b4, and the full stock Android partition layout. Cross-checked against upstream: this device migrated from per-device pmaports packages to the generic qcom-sm7150 port (U-Boot + systemd-boot + EFI, March 2025), which changes the install/partition steps from the older device-specific instructions - U-Boot goes to boot, the pmOS boot image to cache, the rootfs to userdata.

Considered
: Attempting a fastboot boot or flash as part of this same session.

Rejected
: The user mentioned the device already has something called 'nuria' installed or flashed, which does not match any term found in the sm7150-mainline/postmarketOS sources searched; flashing or booting anything before that is understood risks overwriting or being inconsistent with whatever is actually there.
