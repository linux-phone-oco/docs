# Feature research: finding the best way to make one hard feature work

A brief template for a Claude Code session that researches one feature of a Linux phone that will not come
onto the conveyor by a fix or two - deep sleep, the microphones, calls, the cameras, the sensors - and
chooses the way to make it work. The orchestration session writes the brief from this file, naming the
feature and the phone; the phone keeper carries out what is decided. The method - what is, every way
it has been done, vectors, choose, hand over - is the skill **research-a-feature** of the ideal-agent plugin
(grenudi/ideal-agent); this file keeps only what is linux-phone's.

---

You are Claude Code on the lab machine. Start as the skill lab-session-start says, with
`export OCOECO_BY=research-FEATURE` before `. oco-work`. **You research; you do not change the phone or
the kernel** - reading the phone (`devlab phone sh`, `devlab suite run`) is fine; anything that changes it
is the phone keeper's.

**Feature: FEATURE, on PHONE (and its SoC family).** Follow research-a-feature. Here:

- **What is**: its rows in docs (features, feature_support, support_status, tests, test_results), every
  decision, research and backlog row that names it, its `DOMAIN-how-it-stands` research row, and what the
  author said of it (`~/Projects/marshall-oco/conversation`).
- **Where to look**: mainline and its mailing lists, the SoC family's mainline efforts (sm7150-mainline and
  siblings), postmarketOS (pmaports, wiki, MRs, issues), Mobian, Droidian, Ubuntu Touch, Sailfish,
  Android's own stack for this hardware as observed behaviour, the vendor's GPL kernel.
- **Hand over** in linux-phone-oco/docs - data through tad, landing through land, nothing of ocoeco by
  hand (docs' AGENTS.md, "Recording"): `tad r research --project docs ...` with its sources (`tad r source ...`),
  the decision (`tad r decision ...`), the chosen vector's steps as backlog items (`tad r backlog ...`), each
  with how it is proven. The failing test the feature needs goes in lab-tools' `health/suite/checks/` with
  its row in docs' `tests` when it is generic, else in the phone's lab's `tests/health/`.

Done when: the research and decision are landed in docs, the steps are on the backlog with their proofs, the
test is in the suite, and the face shows the feature's path. Report in a few plain lines: the vector chosen,
why, and the first step.
