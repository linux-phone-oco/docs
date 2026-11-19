# dt checks in a container, nothing Python on the host (2026-11-19)

This note covers running the kernel's devicetree schema checks (`dt_binding_check`, `CHECK_DTBS=y`)
in a throwaway Docker container on the lab machine. The host gets no Python; dtschema lives only in
the image.

## Measured

- The host already has Docker 29.9.3; images alpine:3.24 and koalaman/shellcheck are in use.
- alpine:3.24's `py3-dt-schema` (2025.12) is too old for the v7.3 schemas: building
  processed-schema.json fails with a KeyError in check_duplicate_property_types.
- alpine:edge's `py3-dt-schema` (2026.09) works. The packages needed are make, gcc, musl-dev, flex,
  bison, yamllint, py3-dt-schema and dtc.
- On linux-topics at 8b2283da3:
  - `make O=/out ARCH=arm64 DT_SCHEMA_FILES=watchdog/qcom,pm8916-wdt.yaml dt_binding_check`: clean.
  - `CHECK_DTBS=y` on qcom/msm8998-oneplus-cheeseburger.dtb (pm8998) and
    qcom/sm7125-xiaomi-joyeuse.dtb (pm6150), full schema set: 0 warnings.
- Negative test: a node with `bogus-prop` gets "Unevaluated properties are not allowed" from the
  qcom,pm8916-wdt schema. The checker does flag faults.
- Time per run, with `apk add` on every run: binding check about 2 min; two dtbs including defconfig
  about 2.5 min. Most of it is processing the schema; Docker cost is small.

## The run

The source is mounted read-only. Output goes to a scratch O= directory, chowned back to the user at
the end:

    docker run --rm -v "$PWD":/src:ro -v OUT:/out -w /src alpine:edge sh -c \
      'apk add -q make gcc musl-dev flex bison yamllint py3-dt-schema dtc &&
       make O=/out ARCH=arm64 CHECK_DTBS=y qcom/BOARD.dtb; chown -R UID:GID /out'

Pin the image by digest, or bake it, so a later edge dtschema doesn't change results unseen.

## Correction, and the first real run of `lpoco-bringup dt-check` (2026-11-19, later)

**Correction.** The pm8998 and pm6150 watchdog nodes are `status = "disabled"` on cheeseburger and
joyeuse, and dtschema skips disabled nodes. So the "0 warnings" above never covered our nodes.

Re-run with both nodes set to okay (a scratch copy of 8b2283da3):
- cheeseburger and joyeuse: clean.
- With `bogus-prop` added to the enabled pm8998 node, the qcom,pm8916-wdt schema flags it 3 times
  ("Unevaluated properties are not allowed").

The nodes do pass. A negative test only means something on an enabled node.

**The verb** is lab-tools 0.21.2 (#199), with image alpine@sha256:020dfcba…, the pin named in its
backlog row. Compared with the one-liner:

1. `dt-check binding`: matches. watchdog/qcom,pm8916-wdt.yaml is clean; 69 s.
2. `dt-check dtbs` on a fresh `--out` fails: it doesn't run defconfig, so make stops at a missing
   .config. The verb then calls that a checker failure ("dt-check: failed ... the checker's lines
   are above").
3. `dt-check dtbs` prints schema violations and still says "dt-check: clean", exit 0. CHECK_DTBS
   reports violations as warnings, so make succeeds. The verdict has to come from the output
   (lines matching `.dtb: `), not from make's exit code. The same holds for dt_binding_check, whose
   example warnings don't fail make either.
4. The digest pins only the base image. dtschema comes from `apk add py3-dt-schema` at run time, from
   whatever edge holds that day, so a later dtschema can still change results unseen. The image
   needs dtschema baked in, then pinned.
