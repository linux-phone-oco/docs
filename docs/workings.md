<!-- Generated from data/ by tad. Do not edit by hand. -->

# Workings

<a id="w-feature-table"></a>
### w-feature-table

Project
: linux-phone-oco/docs

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

Project
: linux-phone-oco/docs

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

Project
: linux-phone-oco/docs

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

Project
: linux-phone-oco/docs

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

Project
: linux-phone-oco/docs

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

Project
: linux-phone-oco/docs

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

Project
: linux-phone-oco/docs

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

Project
: linux-phone-oco/docs

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

Project
: linux-phone-oco/docs

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

Project
: linux-phone-oco/docs

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

Project
: linux-phone-oco/docs

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


<a id="w-01"></a>
### w-01

Project
: linux-phone-oco/lab-tools

What
: devlab phone

Kind
: tool

Serves
: dl-reaches

How
: Finds the phone on any of its addresses and works on it by its key.

Why
: Everything else begins with reaching it, every time.


<a id="w-02"></a>
### w-02

Project
: linux-phone-oco/lab-tools

What
: devlab health

Kind
: check

Serves
: dl-reaches

How
: The device's checks, compared with everything that passed before.

Why
: Worse than yesterday is the thing to catch.


<a id="w-03"></a>
### w-03

Project
: linux-phone-oco/lab-tools

What
: devlab flash and provision

Kind
: tool

Serves
: dl-life

How
: From bare to ready: the image with the device's fixes baked in; then clock, storage, packages, Wi-Fi.

Why
: A phone's whole life should be repeatable from nothing.


<a id="w-04"></a>
### w-04

Project
: linux-phone-oco/lab-tools

What
: devlab watch

Kind
: gatherer

Serves
: dl-life

How
: Runs the checks after every start and raises a task when something got worse.

Why
: Nobody has to remember to look.


<a id="w-05"></a>
### w-05

Project
: linux-phone-oco/lab-tools

What
: devlab kernel try

Kind
: tool

Serves
: dl-safe

How
: A test kernel beside the stock one, started once, falling back to stock by itself.

Why
: An experiment must never cost the phone.


<a id="w-06"></a>
### w-06

Project
: linux-phone-oco/lab-tools

What
: devlab hear

Kind
: test

Serves
: dl-manual

How
: A tone on each speaker, heard through a microphone in the lab: the first test that needs something outside the phone. It waits for a microphone fixed in place.

Why
: Some truths cannot be read from inside the device.
