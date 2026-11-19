#!/bin/sh
# The failing test of the distro-agnostic device layer (decision 2026-11-19-device-layer-declared-once, item
# layer-test-in-lab-tools carries it into lab-tools' suite): surya's device layer, declared once in its device.toml
# ([layer], read by lpoco-manifest), packs into an apk AND a deb with one command per format, and the two hold the
# same files. Unknown until `lpoco layer pack` exists; it fails today at the first check, by design.
#
#   sh test-layer-apk-and-deb.sh [DEVICE_DIR]      DEVICE_DIR defaults to ~/Projects/linux-phone-oco/surya-lab
#
# Needs only sh, tar, gzip, ar and sort (no dpkg, no apk): an apk v2 is concatenated gzip tar streams, a deb an ar
# archive holding data.tar.*. Exit 0: pass; 1: fail, each reason on its own FAIL line.
set -u
dev="${1:-$HOME/Projects/linux-phone-oco/surya-lab}"
lpoco="${LPOCO:-lpoco}"
fails=0
fail() { echo "FAIL: $*"; fails=$((fails + 1)); }

[ -f "$dev/device.toml" ] || { echo "FAIL: no device.toml in $dev"; exit 1; }
grep -q '^\[layer\]' "$dev/device.toml" || fail "$dev/device.toml declares no [layer] table (item surya-layer-declared)"
if ! "$lpoco" layer --help >/dev/null 2>&1; then
	fail "'$lpoco layer' does not run: the layer packer is not built (item lpoco-layer-pack)"
	echo "result: fail ($fails)"; exit 1
fi

out="$(mktemp -d)"; trap 'rm -rf "$out"' EXIT
for f in apk deb; do
	mkdir -p "$out/$f"
	"$lpoco" layer pack --manifest "$dev/device.toml" --format "$f" --out "$out/$f" >"$out/$f.log" 2>&1 \
		|| fail "pack --format $f exited non-zero: $(tail -n 3 "$out/$f.log" | tr '\n' ' ')"
done

# The files a package installs, one path per line, without the leading ./ and the format's own metadata.
list_apk() { gzip -dc "$1" | tar -t --ignore-zeros 2>/dev/null | grep -v -e '^\.PKGINFO$' -e '^\.SIGN\.' -e '^\.pre-' -e '^\.post-' -e '/$' | sed 's|^\./||' | sort -u; }
list_deb() {
	d="$(mktemp -d)"; (cd "$d" && ar x "$1") || return 1
	tar -tf "$d"/data.tar.* | grep -v '/$' | sed 's|^\./||' | sort -u; rm -rf "$d"
}

found=0
for a in "$out"/apk/*.apk; do
	[ -f "$a" ] || continue
	found=1
	name="$(basename "$a" .apk | sed 's/-[0-9][^-]*-r[0-9]*$//')"
	deb="$(ls "$out"/deb/"${name}"_*.deb 2>/dev/null | head -n 1)"
	[ -n "$deb" ] || { fail "apk $name has no deb of the same name"; continue; }
	list_apk "$a" >"$out/$name.apk.files"
	list_deb "$deb" >"$out/$name.deb.files"
	diff -u "$out/$name.apk.files" "$out/$name.deb.files" >"$out/$name.diff" \
		|| fail "$name: apk and deb hold different files: $(head -n 8 "$out/$name.diff" | tr '\n' ' ')"
done
[ "$found" = 1 ] || fail "pack --format apk made no .apk"

# One file of surya's real layer, today a flash overlay, must be in a package of each format.
for f in apk deb; do
	cat "$out"/*."$f".files 2>/dev/null | grep -qx 'usr/share/alsa/ucm2/Xiaomi/surya/HiFi.conf' \
		|| fail "no $f package holds usr/share/alsa/ucm2/Xiaomi/surya/HiFi.conf (surya's UCM, a flash overlay today)"
done
# surya's boot glue on any systemd base: kernel-install(8) reads the dtb's path from /usr/lib/kernel/devicetree.
cat "$out"/*.deb.files 2>/dev/null | grep -qx 'usr/lib/kernel/devicetree' \
	|| fail "no deb holds usr/lib/kernel/devicetree (surya's boot glue for kernel-install)"

[ "$fails" = 0 ] && { echo "result: pass"; exit 0; }
echo "result: fail ($fails)"; exit 1
