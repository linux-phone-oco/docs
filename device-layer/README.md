# The device layer

What docs gives every device base (device-template, surya-lab, google-walleye-lab, and the next phone's): the statements a
device base runs and the part of its `tables.toml` that declares the tables docs reads from it. Decision
2026-11-18-device-layer-from-docs.

- `../generic` names the files and says how a base follows them: `#! pin = devicebase.toml`, `#! marker = device`,
  `#! from = device-layer/`. A file is laid at the base's root with the path it has here (`queries/parts.sql` here is
  `queries/parts.sql` there); `tables.toml` only between the lines of its marker.
- `../consumers` names the bases. ideal-knowledge-base's `bin/update-pins.sh` (docs is one of its `./sources`) moves each
  base's pin in `devicebase.toml` to docs' latest release when a file of this folder changed, and the base's CI decides.
- A contract change (parts, steps) is one change here, next to the feed that reads it (`records/feed-device-parts.sql`,
  `records/feed-device-steps.sql`, to come) and the catalogues; a base that needs a change opens it here, never in its copy.
- These are the device base's statements, not docs' own: docs' root `records/device.sql`, `backlog-status.sql`, `backlog-needs.sql` and
  `test-run.sql` differ from them and stay docs'. Nothing here is named by ideal-knowledge-base's `generic`.
- `bin/check-device-layer.sh` (run by `make verify`) holds the folder whole: every file the list names is here and nothing
  else, the marked part of `tables.toml` is valid on its own.
- The steps contract (`steps = 1` in the base's `devicebase.toml`): the `steps` table of the marked part and the record
  `records/step.sql` (`tad r step --step S --status done --proof P --run R`). A base claims where its device stands on a
  step of docs' generic catalogue (`tad q bringup-chain`); docs' feed reads `data/steps.json` from the base at main into
  `step_status`, and a step never claimed is unknown. `bin/test-steps-contract.sh` (run by `make verify`) makes a base of
  the layer alone claim a step and refuses a status outside the six, a done claim without proof or run, and a not-needed
  one without its reason.
  The base's own step: `steps = 1` in its `devicebase.toml` (the pin file is the base's, never laid), with its first claim;
  until then docs reads the base as not declaring the contract and every step of it is unknown.
