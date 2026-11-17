# Boot image tooling: what exists (2026-11-17)

Read-only look by a researcher subagent from crates.io data and page summaries; counts are weaker than a source read.
Verdict: wrap = a dependency, idea = copy the idea only, ignore.

## Rust crates
| name | licence, last release | does | verdict |
|---|---|---|---|
| abootimg-oxide 0.5.2 | MIT/Apache, 2026-06 | header v0-v4, vendor_boot v3/v4 read+write (binrw), no AVB | wrap, if v0 write is byte-exact (unknown) |
| abootcrafter 1.1.0 | MIT/Apache, 2024-12 | info/extract/update/create v0-v4; no AVB, ramdisk repack unfinished | idea (update = swap) |
| abl-exorcist | GPL-3.0 | wraps a mainline kernel for Pixel ABL, calls mkbootimg | idea |
| AOSP mkbootimg/rust/bootimg.rs | Apache-2.0 | read-only zerocopy header layout v0-v4, ~330 lines, not a crate | idea (authoritative layout) |
| cpio 0.4.2 / cpio-archive 0.10 | MIT / MPL-2.0 | newc archives (writes; cpio-archive also reads) | wrap |
| flate2, lz4_flex 0.14 | active | gzip; lz4 block+frame | wrap |
| dtoolkit 0.5.0 | Apache/MIT, 2026-11 | dtb read, edit, write, overlay | wrap (young) |
| fdt 0.2.0-alpha3 | MPL-2.0 | dtb read | read only |
| AVB | none on crates.io | | wrap avbtool |

## Tools
| name | language | takes |
|---|---|---|
| mkbootimg, unpack_bootimg, repack_bootimg, avbtool (android-tools 37) | Python | the oracles: authoritative; installed here |
| magiskboot | Rust + C++, GPL-3.0 | unpack to a directory, change, repack with the original as template: the swap model |
| pmbootstrap | Python, ~24k lines | deviceinfo field names only |
| lk2nd | C | a bootloader; no host tooling |
| Droidian initramfs-tools-halium | shell | initramfs hooks only |
| Mobian, Halium build scripts, boot-deploy, abootimg (C) | | not read |

No tool checks an image against expected header fields.
