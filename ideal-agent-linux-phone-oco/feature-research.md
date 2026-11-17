# Feature research: the way for one hard feature of a Linux phone

Role: research-lead (ideal-agent)
Name: research-FEATURE
Also practices: 42

A brief template for a session that researches one feature of a Linux phone that a fix or two will not
bring onto linux-phone-oco's conveyor - deep sleep, the microphones, calls, the cameras, the sensors. The
orchestration session writes the brief from this file, naming the feature and the phone; the phone keeper
carries out what is decided. The method is ideal-agent's skill **research-a-feature** (its card:
research-lead); this file keeps only what is linux-phone's.

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
