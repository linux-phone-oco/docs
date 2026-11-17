# Feature research: finding the best way to make one hard feature work

A brief template for a Claude Code session that researches one feature of a Linux phone that will not come
onto the conveyor by a fix or two - deep sleep, the microphones, calls, the cameras, the sensors - and
chooses the way to make it work. The orchestration session writes the brief from this file, naming the
feature and the phone; the bring-up session carries out what is decided.

---

You are Claude Code on the lab machine. Start as `prompts/bring-up.md` says, with
`export OCOECO_BY=research-FEATURE` before `. oco-work`. **You research; you do not change the phone or
the kernel** - reading the phone (`devlab phone sh`, `devlab suite run`) is fine; anything that changes it
is the bring-up session's.

**Feature: FEATURE, on PHONE (and its SoC family).**

1. **What is.** Its rows in docs (features, feature_support, support_status, tests, test_results), every
   decision, research and backlog row that names it, and what the author said of it (the conversation).
   Measure what you can on the phone without changing it.
2. **Every way it has been done**, inside the commons first, then outside: mainline and its mailing lists,
   the SoC family's mainline efforts, postmarketOS (pmaports, wiki, MRs, issues), other distributions
   (Mobian, Droidian, Ubuntu Touch, Sailfish), Android's own stack for this hardware as observed behaviour
   (never its proprietary code), the vendor's GPL kernel, academic and conference talks. For each source:
   what it does, on which hardware, how far it got, what stopped it.
3. **Vectors.** Two to five distinct ways to make the feature work here, each with: what it needs (kernel
   drivers, firmware, userspace, a reverse-engineered protocol - clean room), what is already done, the
   unknowns and how to resolve each cheaply, the risk to the reference phone, the work in agent-hours, how
   it would be proven (which test, `present` or `works`), and whether it can go upstream.
4. **Choose**, by the canon and the project's interest: the vector with the best ratio of certain progress to
   cost, with a first step that settles the biggest unknown. Record it as a decision with every vector
   rejected and why.
5. **Hand over**: write the research rows (`tad r research --project docs ...`, with its sources as `tad r
   source ...`) and the decision (`tad r decision ...`) in linux-phone-oco/docs - data through tad, landing
   through land, nothing of ocoeco by hand (bring-up.md, "Recording") - and the chosen vector's steps as
   backlog items there (`tad r backlog ...`), each with how it is proven -
   the bring-up session's queue. Write the failing test the feature needs (generic in lab-tools'
   `health/suite/checks/` with its row in docs' `tests`, or the phone's own in its lab's `tests/health/`), so
   the conveyor shows the feature `broken` or `unknown` until it works.

Done when: the research and decision are landed in docs, the steps are on the backlog with their proofs, the
test is in the suite, and the face shows the feature's path. Report in a few plain lines: the vector chosen,
why, and the first step.
