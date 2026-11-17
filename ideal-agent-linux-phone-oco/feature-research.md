# Feature research: the way for one hard feature of a Linux phone

Role: research-lead (ideal-agent)
Name: research-FEATURE
Also practices: 42

A brief template for a session that researches one feature of a Linux phone that a fix or two will not
bring onto linux-phone-oco's conveyor - deep sleep, the microphones, calls, the cameras, the sensors. The
orchestration session writes the brief from this file, naming the feature and the phone; the phone keeper
carries out what is decided. The method is ideal-agent's skill **research-a-feature** (its card:
research-lead); this file keeps only what is linux-phone's. A lane's research launcher (surya-research,
walleye-research) starts at its own section, the last one.

---

You are Claude Code on the lab machine. Start as lab-session-start says; the brief written from this file
names the feature in its `Name:` line (research-deep-sleep). Reading the phone (`devlab phone sh`,
`devlab suite run`) is fine; any change to it, or to its kernel, is the phone keeper's.

**Feature: FEATURE, on PHONE (and its SoC family).** Follow research-a-feature. Here:

- **What is**: its rows in docs (features, feature_support, support_status, tests, test_results), every
  decision, research and backlog row that names it, its `DOMAIN-how-it-stands` row, and what the author
  said of it (`~/Projects/marshall-oco/conversation`).
- **Where to look**: mainline and its mailing lists, the SoC family's mainline efforts (sm7150-mainline and
  siblings), postmarketOS (pmaports, wiki, MRs, issues), Mobian, Droidian, Ubuntu Touch, Sailfish,
  Android's own stack for this hardware as observed behaviour, the vendor's GPL kernel.
- **Hand over** in linux-phone-oco/docs, as docs' AGENTS.md ("Recording") says - no ocoeco by hand:
  `tad r research --project docs ...` with its sources (`tad r source ...`), `tad r decision ...`, and
  `tad r backlog ...` for each step of the chosen way, each with how it is proven. The feature's failing
  test goes in lab-tools' `health/suite/checks/` with its row in docs' `tests` when it is generic, else in
  the phone's lab's `tests/health/`.

Done and reported as research-a-feature says, with the research and decision landed in docs.

## A lane's research launchers: surya-research, walleye-research

Started by a lane coordinator from its stored task, with this file as the brief. The lane is the one your
Name names: surya-research works surya (`~/Projects/linux-phone-oco/surya-lab`, reports to the session whose
title starts "surya coordinator"); walleye-research works the Google Pixel 2 (walleye, MSM8998,
`~/Projects/linux-phone-oco/google-walleye-lab`, reports to "walleye coordinator"); find it with `list_sessions`.

- **A fresh worktree of your own** of the lane's lab, never the shared clone (it may be stale), removed
  when you end (`git -C ~/Projects/linux-phone-oco/LAB worktree remove WT`):
  - surya-research: `R=$(date +%s); git -C ~/Projects/linux-phone-oco/surya-lab fetch -q origin && git -C ~/Projects/linux-phone-oco/surya-lab worktree add -q --detach ~/Projects/linux-phone-oco/wt-surya-research-$R origin/main && cd ~/Projects/linux-phone-oco/wt-surya-research-$R`
  - walleye-research: `R=$(date +%s); git -C ~/Projects/linux-phone-oco/google-walleye-lab fetch -q origin && git -C ~/Projects/linux-phone-oco/google-walleye-lab worktree add -q --detach ~/Projects/linux-phone-oco/wt-walleye-research-$R origin/main && cd ~/Projects/linux-phone-oco/wt-walleye-research-$R`
- **Your question**: `tad q lane-next --needs research --format csv` in that worktree. The coordinator
  placed it there before starting you; **none: report that and end.**
- **Where it is recorded**: the lane's records live in its lab's own base, not in docs (decision
  2026-11-17-commons-and-device-bases): `ikb research` with its sources, `ikb decision` with what was
  rejected (`ikb --help`). What helps every device - a method, a family's research, a generic check - still
  goes to docs.
- **The writes you may make**: those records; phone work the answer leads to, queued for the keeper with
  `ikb backlog-needs --id ... --needs phone --proof TEST`; landing in linux-phone-oco places; messages to
  your coordinator. You never change the phone.
- **End**: land in the lab, read it back from main, mark the item done (`ikb backlog-status`), report to
  your coordinator, end.
