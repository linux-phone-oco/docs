# device-template and its labs, measured 2026-11-18

What this folder holds: the measurement behind research rows device-template-drift-measured and
device-template-follow-world, and the failing test `template-drift.sh` (decision
2026-11-18-device-template-follows-by-release). Read only git refs: device-template 78fb062, surya-lab
972cebf, google-walleye-lab 87c4f4e, ideal-knowledge-base v0.15.0 (all origin/main). No phone touched.

## Origin

- 2026-11-10: asked for (docs backlog `device-template`): the conveyor as a repo of its own, "surya is the
  first instance, not the mould"; design names a GitHub template repository.
- 2026-11-17: made from what surya proved (`dt-made`, device-template #1, a GitHub template); decision
  2026-11-17-the-phone-is-data: a lab holds data only, every tool is lpoco's (then devlab's).
- 2026-11-17: surya-lab re-based by hand (`dt-surya-from-template`, surya-lab #81, #134) - surya-lab predates
  the template (first commit 2026-11-09; GitHub knows no template link). google-walleye-lab made by "Use this
  template" (decision walleye-lab-repo; GitHub records templateRepository device-template).
- 2026-11-17/18: the device base layer (#4-#15: parts, phone queries, lane-next, phone-stands, blocked_by,
  hardware, decision fields) - each landed in the template and again, by hand, in each lab within minutes
  (surya-lab #134, #136, #139, #155, #218; google-walleye-lab #15, #20, #29, #80; #208 still open, stale).
- idealkb's slice reaches all three by update-pins (consumers lists them); the template has no release, so
  nothing follows its own `generic` list (it says so in its header). Decision 2026-11-17-chain-follow-by-slice
  (idealkb) chose the same pin-and-follow for the template; item device-template-follow is in progress, waiting
  on template releases and idealkb follow-source-from-pin.
- Other repos: none. `gh repo list linux-phone-oco` shows two labs; grenudi has no device lab.

## Use: what kind of child

| | surya-lab | google-walleye-lab |
|---|---|---|
| how made | hand re-base of an older repo | GitHub "Use this template" (unrelated history) |
| link kept | none in git; devicebase.toml template = "2026-11-17" | the same |
| idealkb slice | update-pins, pin 0.15.0 | update-pins, pin 0.15.0 |
| template's generic | 13 of 13 equal, carried by hand | 13 of 13 equal, carried by hand |

## Drift, file by file (blob ids, template main vs lab main, outside data/ and docs/)

Equal in both: every idealkb generic file, all 13 template generic files, Makefile, bin/install-tad.sh,
bin/install-ikb.sh, tad.yml, gather.yml, .gitignore, devicebase.toml, idealkb.toml, tables.toml.

Named drift:
1. `generic` (both labs): a stale copy of the template's list, 5 entries behind (lane-next, phone-stands,
   records/hardware, records/hardware-status, queries/hardware). A lab needs no copy at all.
2. Two sources for one file (template itself): records/hardware.sql, records/hardware-status.sql,
   queries/hardware.sql were born in the template (#11), copied by hand, then taken into idealkb 0.15.0's
   generic; the template still lists them. The 0.15.0 bump therefore opened "this base changed a generic
   file" PRs in all three (device-template #21, surya-lab #241, google-walleye-lab #233), each closed by hand.
   0.14.0 did the same for records/backlog.sql (#16, #220, #212) - an own file idealkb changed.
3. surya-lab `.github/workflows/check.yml`: lacks the template's `xargs -r` (fails on a repo with no .sh);
   google-walleye-lab adds its own rust job to the same file (an extension, but the file has no split).
4. surya-lab lacks tests/health/README.md and the .gitkeep files (its tests tree predates the template).
5. AGENTS.md: the idealkb part equal in both; outside it surya-lab has its own older text, walleye only its
   owner line and the battery rule. Per device, never classified.
6. device.toml shape (keys, awk over uncommented lines): surya-lab lacks [fastboot] serial/writes and
   health.absent; the labs use keys the template does not show - [[flash.overlay]], [[hazard]], [hear],
   [[provision.install]], health.data_budget_mb, health.remoteprocs (surya); [host], [host.gadget],
   fastboot.slot_switch (walleye). The template's example lags the Rust model: decision
   2026-11-18-device-manifest-schema-from-rust (template-manifest-schema) answers it, not this one.
7. devicebase.toml template = "2026-11-17" in all three: says nothing true about which template changes a
   lab has (it has #1-#15 by hand).
8. google-walleye-lab PR #208 (the template's #15 by hand) open, stale: its change is on main another way.

Nothing catches any of it: no CI in a lab compares anything to the template; idealkb's exit 3 sees only
idealkb's files and fires on false alarms (2).

## Outside (researcher report, read at source 2026-11-18)

- cruft: .cruft.json pins the template commit; `cruft check` exits 1 when behind, `cruft diff --exit-code`
  when the child changed a template file; a weekly action opens update/reject PRs. Take: pin + failing check.
- copier: .copier-answers.yml with _commit; update re-renders the old version, diffs, applies the new
  (three-way), conflicts inline or .rej; _skip_if_exists, _exclude; check-update exits 2 when behind. Take:
  "behind" and "edited" are two checks; made-once files (_skip_if_exists).
- GitHub template repositories: one squashed copy, no link, no update. actions-template-sync merges the
  template with -X theirs, .templatesyncignore - overwrites a child's data. Set aside.
- Yeoman: re-run with an interactive conflicter, no pin, no drift check. Set aside.
- Nix: `flake init -t` copies once and never overwrites; logic consumed as a flake input is pinned in
  flake.lock and cannot drift (update-flake-lock opens PRs). Take: logic as a pinned input (lpoco), files
  only where they must sit in the child's tree.
- projen: files it synthesizes are marked read-only and an anti-tamper check fails the build. Take: the
  template names which files it owns.
- Renovate custom regex managers bump a pin anywhere; Dependabot does not do arbitrary files.
- git-rhizoid: whole forks (cuttings); slice-consumption, followers-one-pin-bump and
  send-back-writes-the-upstream-item open on its backlog; CLI add/update/status stubbed.
