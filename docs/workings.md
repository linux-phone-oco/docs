<!-- Generated from data/ by .tad/tools/render.py. Do not edit by hand. -->

# Workings

<a id="w-feature-table"></a>
### w-feature-table

What
: The feature table

Kind
: practice

Serves
: lp-everything

How
: Every thing a phone does, against every system, each entry with its source and the day it was checked.

Why
: So 'as good as Android' is a count, not a feeling.

Evidence
: feature_support


<a id="w-watch"></a>
### w-watch

What
: devlab watch

Kind
: gatherer

Serves
: lp-tested-daily

How
: After every start of the phone, its checks run by themselves and the results are written down; a regression raises a task on the board.

Why
: A phone nobody is watching drifts away from working.

Evidence
: tests@xiaomi-surya

Uses
: linux-phone-oco/lab-tools


<a id="w-upstream-queue"></a>
### w-upstream-queue

What
: The upstream queue

Kind
: practice

Serves
: lp-upstream

How
: Each fix prepared as a patch for the project it belongs to, with its maintainers named - sent in its author's name.

Why
: A fix kept to ourselves helps one phone; sent upstream, every phone of that kind.

Evidence
: backlog:upstream-tas2562-volume


<a id="w-flash"></a>
### w-flash

What
: devlab flash

Kind
: tool

Serves
: surya-boots

How
: Writes the pristine image with the device's known fixes baked in, and fingerprints its device tree first.

Why
: Any flash gives the same known phone - found out the hard way.

Evidence
: backlog:flash

Uses
: linux-phone-oco/lab-tools


<a id="w-health"></a>
### w-health

What
: devlab health

Kind
: check

Serves
: surya-boots

How
: Twenty-two checks on the phone itself - the sound card, the amplifiers, the modem, Wi-Fi, storage - compared with everything that passed before.

Why
: The phone is the reference: it must not quietly get worse.

Evidence
: tests@xiaomi-surya

Uses
: linux-phone-oco/lab-tools


<a id="w-hear"></a>
### w-hear

What
: devlab hear

Kind
: test

Serves
: surya-sound

How
: Plays a tone on each speaker and hears it through a microphone in the lab, measured against the silent room. It waits for a microphone fixed in place: its first results, from a microphone that moved, were withdrawn.

Why
: A driver that loads proves nothing about sound. A machine should hear it.

Evidence
: component:audio-speaker@xiaomi-surya

Uses
: linux-phone-oco/lab-tools


<a id="w-manifest-fixes"></a>
### w-manifest-fixes

What
: The device's manifest

Kind
: tool

Serves
: surya-sound

How
: The stereo profile, the corrected amplifier driver and two masked services, written down once and baked into every flash.

Why
: A fix made by hand is lost at the next flash.

Evidence
: component:audio-speaker@xiaomi-surya

Uses
: linux-phone-oco/surya-lab


<a id="w-modem-checks"></a>
### w-modem-checks

What
: The modem checks

Kind
: check

Serves
: surya-phone

How
: Whether the modem is seen and ready for calls, messages and data - not yet whether a call goes through.

Why
: Seen is not the same as working; this is the first rung only.

Evidence
: component:modem-calls@xiaomi-surya

Uses
: linux-phone-oco/lab-tools


<a id="w-parts-table"></a>
### w-parts-table

What
: The parts table

Kind
: practice

Serves
: surya-every-part

How
: Each part of the phone with its state, taken from the checks and the records of the work.

Why
: So what is left to do is a list, not a guess.

Evidence
: support_status


<a id="w-watch-surya"></a>
### w-watch-surya

What
: devlab watch

Kind
: gatherer

Serves
: surya-tested

How
: The checks after every start, by themselves, written down.

Why
: Tested once is not tested.

Evidence
: tests@xiaomi-surya

Uses
: linux-phone-oco/lab-tools


<a id="w-upstream-surya"></a>
### w-upstream-surya

What
: The upstream queue

Kind
: practice

Serves
: surya-upstream

How
: The amplifier fixes and the Sxmo profile prepared as patches with their maintainers named.

Why
: So every phone on this chip gets them.

Evidence
: backlog:upstream-tas2562-slot-length
