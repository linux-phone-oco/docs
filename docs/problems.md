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
