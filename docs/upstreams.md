<!-- Generated from data/ by tad. Do not edit by hand. -->

# Upstreams

<a id="linux-sound"></a>
### linux-sound (ALSA SoC) and the TAS2562 maintainers

Kind
: list

Address
: linux-sound@vger.kernel.org

How
: git send-email to the maintainers from scripts/get_maintainer.pl, the list and linux-kernel in Cc; the author signs off

Contacts
: Mark Brown, Liam Girdwood, Shenghao Ding, Kevin Lu, Baojun Xu (TI), Takashi Iwai, Jaroslav Kysela

Notes
: Recipients as the queue README lists them; wait a week before pinging


<a id="sxmo-devel"></a>
### sxmo-devel

Kind
: list

Address
: ~mil/sxmo-devel@lists.sr.ht

How
: git send-email, plain text (lists.sr.ht refuses HTML); the send setup is ~/sxmo-send on the lab machine

Notes
: Archive: https://lists.sr.ht/~mil/sxmo-devel - watch it for review; replies in the author's name need his word


<a id="sm7150-mainline"></a>
### sm7150-mainline/linux

Kind
: code-project

Address
: https://github.com/sm7150-mainline/linux

How
: A pull request or a comment on an open one; the surya device tree and the SM7150 LPI pin driver live here before mainline


<a id="alsa-ucm-conf"></a>
### alsa-ucm-conf

Kind
: code-project

Address
: https://github.com/alsa-project/alsa-ucm-conf

How
: A pull request adding Xiaomi/surya; once the kernel fix is accepted or at least posted


<a id="linux-arm-msm"></a>
### linux-arm-msm (remoteproc, pd-mapper)

Kind
: list

Address
: linux-arm-msm@vger.kernel.org

How
: git send-email to the remoteproc and Qualcomm maintainers from scripts/get_maintainer.pl


<a id="idealkb"></a>
### ideal-knowledge-base (idealkb)

Kind
: kb-instance

Address
: https://github.com/grenudi/ideal-knowledge-base

How
: A pull request to the repository with the change to a generic file; docs' own copies of generic files (own in idealkb.toml) that idealkb changes show in update-pins' diff. Record it as an upstream item (ikb upstream-item --upstream idealkb --form patch --file auto).

Contacts
: grenudi (owner); the ikb session

Notes
: Where docs' standing tables, generic queries and records, ikb and install-ikb.sh come from; the pin is idealkb.toml.


<a id="device-template"></a>
### device-template

Kind
: kb-instance

Address
: https://github.com/linux-phone-oco/device-template

How
: A pull request to the template with what every device would need; the device bases take its listed files (generic) once it has releases.

Contacts
: linux-phone-oco orchestration


<a id="ideal-agent"></a>
### grenudi/ideal-agent

Kind
: code-project

Address
: https://github.com/grenudi/ideal-agent

How
: a pull request through its owner session (ideal-agent-roles): an upstream item here naming ideal-agent, and a message to that session, which looks around, decides, lands and reads back

Contacts
: ideal-agent-roles (the session that keeps ideal-agent)

Notes
: Takes what is general: how agents work, roles, skills, practices, and how any device is brought up; the domain keeps a pointer (ideal-agent decision 2026-11-17-research-on-own-initiative).


<a id="linux-watchdog"></a>
### linux-watchdog (watchdog drivers) and its maintainers

Kind
: list

Address
: linux-watchdog@vger.kernel.org

How
: git send-email of a b4-prepared series (b4 prep, b4 prep --auto-to-cc, b4 prep --check), each patch passing scripts/checkpatch.pl --strict, signed off by the person who sends; recipients from scripts/get_maintainer.pl

Contacts
: Wim Van Sebroeck <wim@linux-watchdog.org>, Guenter Roeck <linux@roeck-us.net>; pm8916_wdt binding: Krzysztof Kozlowski; dt-bindings: Rob Herring, Krzysztof Kozlowski, Conor Dooley, devicetree@vger.kernel.org; Qualcomm dts: linux-arm-msm, Bjorn Andersson, Konrad Dybcio

Notes
: Subjects: 'watchdog: pm8916_wdt: ...', 'dt-bindings: watchdog: ...' first in the series, 'arm64: dts: qcom: ...' last. An AI agent adds no Signed-off-by; the sender adds his and 'Assisted-by: LLM' in place of Co-Authored-By (Documentation/process/coding-assistants.rst). Keeping a watchdog running through suspend was refused as policy (Roeck 2025, Kozlowski 2026): only the wake-to-pet shape (wakeup-source, stm32_iwdg/ma35d1_wdt) has precedent.


<a id="fork-sxmo-utils"></a>
### grenudi/sxmo-utils (our sxmo-utils, carrying our patches)

Kind
: code-project

Address
: https://github.com/grenudi/sxmo-utils

How
: a topic branch per upstream item off master (master mirrors git.sr.ht/~mil/sxmo-utils, never edited); the lab branch merges the topics and is what the phones run, tagged per build; the series goes out from the topic by git format-patch, in the author's name

Notes
: A mirror (sourcehut cannot be forked on GitHub). The old branch deviceprofile/xiaomi-surya is upstream since 1fd7822 and can go.

Fork of
: sxmo-devel


<a id="fork-linux"></a>
### grenudi/linux (our kernel tree, carrying our patches)

Kind
: code-project

Address
: https://github.com/grenudi/linux

How
: topic branches (fix/, dt/, topic/) each off the base its upstream takes (sm7150-mainline v7.x for sm7150 work, a kernel.org tag for mainline drivers); test/ branches merge them for a phone; series go out by b4 in the author's name

Notes
: A GitHub fork of sm7150-mainline/linux; carries patches for linux-sound, sm7150-mainline and linux-watchdog

Fork of
: sm7150-mainline


<a id="git-rhizoid"></a>
### git-rhizoid (rhizoid: fork, own and sync git dependencies)

Kind
: code-project

Address
: https://github.com/git-rhizoid/git-rhizoid.github.io

How
: a backlog item in its design log (tad base) by its owner, from a finding here

Notes
: Design log git-rhizoid.github.io, code git-rhizoid/rhizoid (CLI typed, add/update/status stubbed, parked 2026-11-11)


<a id="nura-pmaports"></a>
### Nura (formerly postmarketOS): pmaports, pmbootstrap, its wiki

Kind
: distro

Address
: https://gitlab.nura.eco/nura/pmaports

How
: Only by the author himself, in his own words and work: an issue, a merge request test (Testing Team, mrtest), a wiki edit. Nura forbids contributions fully or in part created by generative AI, so no agent drafts anything headed here - no patch, test, report, comment or wiki line.

Contacts
: device-qcom-sm7150 co-maintainers: Danila Tikhonov, David Wronek, Arian Kulmer (the APKBUILD's lines)

Notes
: AI policy since 2026-02-16 (source nura-ai-policy); the Code of Conduct and the wiki rules reach issues, comments and wiki text too. Renamed from postmarketOS on 2026-09-27; pmaports and pmbootstrap keep their names. pmaports issue 4441 (tqftpserv, surya's SIM slot) is the one of its reports we cite. Our kernel and sxmo work reaches Nura through sm7150-mainline, kernel.org and sxmo, not through here.


<a id="alpine-aports"></a>
### Alpine aports

Kind
: distro

Address
: https://gitlab.alpinelinux.org/alpine/aports

How
: A merge request or an issue on the repository; a request to Alpine is made in the author's name

Notes
: Alpine's own; Nura's pmaports is the upstream nura-pmaports. Alpine's rules on AI-made contributions not checked (research nura-relation-how-it-stands).
