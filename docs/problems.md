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
