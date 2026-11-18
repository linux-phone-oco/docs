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
  and the steps feed when it lands) and the catalogues; a base that needs a change opens it here, never in its copy.
- These are the device base's statements, not docs' own: docs' root `records/device.sql`, `backlog-status.sql`, `backlog-needs.sql` and
  `test-run.sql` differ from them and stay docs'. Nothing here is named by ideal-knowledge-base's `generic`.
- `bin/check-device-layer.sh` (run by `make verify`) holds the folder whole: every file the list names is here and nothing
  else, the marked part of `tables.toml` is valid on its own.
