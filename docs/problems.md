<!-- Generated from data/ by tad. Do not edit by hand. -->

# Problems

<a id="a-release-that-would-say-1-0-0"></a>
### a-release-that-would-say-1-0-0

Project
: linux-phone-oco/docs

What
: the release pull request proposes 1.0.0 while the manifest says 1.2.0: no release was ever tagged, so release-please starts from nothing

Seen
: 2026-11-12

By
: claude

Countermeasure
: the docs begin their own history (decisions:2026-11-12-the-docs-own-history): manifest at 0.0.0 read by release-please, versions below 1.0 while forming, the template's changelog cleared with a note

Handled
: 2026-11-12


<a id="actions-could-not-open-pull-requests"></a>
### actions-could-not-open-pull-requests

Project
: linux-phone-oco/docs

What
: the docs release failed on every merge for two days, 54 times, unheard: Actions were not permitted to open pull requests in the phone organization

Seen
: 2026-11-12

By
: claude

Countermeasure
: allowed for this repository, default permissions kept read-only; the release run succeeded and opened its pull request

Handled
: 2026-11-12


<a id="watch-files-no-run-since-0210"></a>
### watch-files-no-run-since-0210

Project
: linux-phone-oco/lab-tools

What
: devlab watch has filed no run into docs since 20261117-021008: at least eight health reports came after it (023135 to 050042, seen in the watch's journal), the last 'filed through tad' line is at 03:28 local, and the watch says nothing about why; the microphone's support therefore stands on records typed by surya-lab and docs (#102, #130), not on a filed run

Seen
: 2026-11-17

By
: patrol

Kind
: lacking


<a id="landings-signed-by-no-session"></a>
### landings-signed-by-no-session

Project
: linux-phone-oco/lab-tools

What
: seven landings between 05:09 and 05:50 carry only 'Claude Opus 5.5' as co-author, no session's name: lab-tools #48, #51, #52, #53 and docs #122, #123, #127 - where that session stands cannot be read off its commits

Seen
: 2026-11-17

By
: patrol

Kind
: unclear


<a id="watch-restarted-by-hand"></a>
### watch-restarted-by-hand

Project
: linux-phone-oco/lab-tools

What
: devlab-watch@surya-lab was restarted by hand four times in an hour (04:45, 05:35, 05:44, 05:51 local), each after a lab-tools landing put a new devlab in place; a third time asks that installing devlab restart the watch itself

Seen
: 2026-11-17

By
: patrol

Kind
: lacking


<a id="lens-lands-without-checks"></a>
### lens-lands-without-checks

Project
: linux-phone-oco/docs

What
: linux-phone-oco/lens (which draws docs' face) has no workflow and is not a place docs' records may name: its #7 and #8 landed with no check at all, so land waits on nothing there

Seen
: 2026-11-17

By
: patrol

Kind
: lacking


<a id="landings-signed-by-no-session-again"></a>
### landings-signed-by-no-session-again

Project
: linux-phone-oco/docs

What
: 19 more landings between 06:11 and 11:35 carry no session's name, only 'Claude Opus 5.5': docs #134, #136, #141, #151, #153, #157, #158, #162, #168, #169; lab-tools #54, #55, #56, #59, #64, #66, #67; surya-lab #108, #109 - and #176 is signed by a 'Signed:' line instead of oco-work's co-author, so the same thing is read two ways; the earlier sign (landings-signed-by-no-session) asks for a mechanism, none came

Seen
: 2026-11-17

By
: patrol

Kind
: unclear


<a id="watch-restarted-by-hand-again"></a>
### watch-restarted-by-hand-again

Project
: linux-phone-oco/lab-tools

What
: devlab-watch@surya-lab was restarted by hand five more times (10:12, 10:16, 10:47, 11:18, 11:30 local), each right after a lab-tools landing (#57, #59, #64, #66, #67) put a new devlab in place - nine in all today, none counted in docs' manual_events; installing devlab still does not restart the watch itself

Seen
: 2026-11-17

By
: patrol

Kind
: lacking


<a id="board-rows-say-what-docs-unsaid"></a>
### board-rows-say-what-docs-unsaid

Project
: linux-phone-oco/docs

What
: three linux-phone-oco rows on the lab board contradict docs: 'sim' waits for a SIM card that is in (mobile data, SMS and calls proven today, #147, #152, #155); 'microphone' needs bus tracing though both microphones are judged working (#140); 'cameras' says it is refocused on booting the microphone's device tree - the board is said by hand and nobody said it again

Seen
: 2026-11-17

By
: patrol

Kind
: stale


<a id="land-manual-record-lacks-project"></a>
### land-manual-record-lacks-project

Project
: linux-phone-oco/docs

What
: land --manual wrote the manual_work and manual_events rows without their project, so tad check and CI's verify failed on the pull request until the project was added by hand (docs, 2026-11-17, PR 226)

Seen
: 2026-11-17

By
: walleye-research-vendor

Kind
: lacking


<a id="oco-agent-one-run-per-name"></a>
### oco-agent-one-run-per-name

Project
: linux-phone-oco/google-walleye-lab

What
: Two oco-agent run processes under one name park each other's job ('the agent restarted while doing it') and a killed run leaves a job parked; submit without --as is recorded as the user's login, not the session's name

Seen
: 2026-11-17

By
: walleye-builder

Kind
: unclear


<a id="agent-folder-over-3kb"></a>
### agent-folder-over-3kb

Project
: linux-phone-oco/docs

What
: start-weight 2026-11-17 17:08: ideal-agent-linux-phone-oco/AGENTS.md is 3467 B and its README.md 3280 B, both over the 3 KB budget (keep-the-start-light); no open item for it. Role totals are under 32 KB (orchestration 26425, phone-keeper 23937); briefs under 8 KB.

Seen
: 2026-11-17

By
: patrol

Kind
: unclear


<a id="first-reads-whole-records"></a>
### first-reads-whole-records

Project
: linux-phone-oco/docs

What
: read-weight 2026-11-17 17:08: sessions started since 11:08 UTC read far past brief and task summary before the first act: f7309841 (walleye lane, 15:22) 118 KB in 38 results, largest 14.8 KB scratch file and a 10 KB tad row; 07bf3625 (15:23) 197 KB, two paper searches of 27-30 KB each; 5510fa28 (16:33) 50 KB; d2219fca (15:17) 50 KB. Named query output, not whole records, was meant.

Seen
: 2026-11-17

By
: patrol

Kind
: unclear


<a id="land-release-silent"></a>
### land-release-silent

Project
: linux-phone-oco/lab-tools

What
: In lab-tools on 2026-11-17, 'land --release' exited without a line and without merging release-plz PR 84 (v0.2.0). The bringup-release builder then merged it with 'gh pr merge', outside land. A release step that ends silently leaves the builder to decide alone, and the family tags then rest on a merge land never checked. Seen by lab-tools-builder run local_72f506e8; reported to orchestration.

Seen
: 2026-11-17

By
: orchestration

Kind
: unclear


<a id="start-over-budget-agents-md-readme-1118"></a>
### start-over-budget-agents-md-readme-1118

Project
: linux-phone-oco/docs

What
: The agent folder's start is over the 3 KB budget of keep-the-start-light: AGENTS.md 3887 B and ideal-agent-linux-phone-oco/README.md 4236 B (start-weight on docs, 2026-11-18); roles themselves are under 32 KB (largest orchestration 27191 B). Item for agent-folder.

Seen
: 2026-11-17

By
: patrol

Kind
: stale


<a id="session-read-guide-before-first-act-1118"></a>
### session-read-guide-before-first-act-1118

Project
: linux-phone-oco/docs

What
: Session 7007ce97 (started ~23:07) read 'lab-agent guide' whole (19 KB) and a whole source file (12 KB) before its first act: 77 KB in 16 results; the start already carries the practices. Item for agent-folder naming those reads. Also seen, likely fitting research: sessions 07bf3625 and 992f4370 read 197 KB and 115 KB of paper-search and tad output before first act.

Seen
: 2026-11-17

By
: patrol

Kind
: unclear
