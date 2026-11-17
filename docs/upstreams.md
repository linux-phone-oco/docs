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


<a id="alpine-aports"></a>
### Alpine aports / postmarketOS pmaports

Kind
: distro

Address
: https://gitlab.alpinelinux.org/alpine/aports

How
: A merge request or an issue on the repository; a request to Alpine is made in the author's name

Notes
: pmaports issue 4441 is the report for tqftpserv


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
