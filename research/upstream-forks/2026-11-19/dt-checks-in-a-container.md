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
