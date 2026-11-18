<!-- Generated from data/ by tad. Do not edit by hand. -->

# Bringup Stages

<a id="prepare"></a>
### Prepare

Ord
: 1

What
: Read what the machine is and what it allows before anything is changed: the stock system, the boot facts, the way back.


<a id="boot"></a>
### Boot

Ord
: 2

What
: Get an image of ours accepted by the bootloader and run, one part swapped at a time, until it is known what refuses it.


<a id="console"></a>
### Console

Ord
: 3

What
: A window onto the running kernel: a banner, a shell, over UART or the USB gadget.


<a id="kernel"></a>
### Kernel

Ord
: 4

What
: Our kernel builds, reaches its init and says nothing worse than it should.


<a id="power"></a>
### Power

Ord
: 5

What
: The PMIC, the charger and the watchdog: what keeps the machine alive and safe to leave running.


<a id="storage"></a>
### Storage

Ord
: 6

What
: Internal storage seen, first read-only.


<a id="userspace"></a>
### Userspace

Ord
: 7

What
: A distribution's root boots, the network is up and the health suite runs on every boot.


<a id="lab"></a>
### Lab

Ord
: 8

What
: What the lab needs of a machine to work on it without hands: the ways in, a try that cannot brick.


<a id="coprocessors"></a>
### Coprocessors

Ord
: 9

What
: The processors a phone leans on - the modem's, the audio and sensor DSPs, the Wi-Fi core - get their firmware, run, and stay up.


<a id="display"></a>
### Display and input

Ord
: 10

What
: The panel lights, touch and keys answer, the GPU renders.


<a id="audio"></a>
### Sound

Ord
: 11

What
: The card, the codec and the amplifiers, a profile for the shell, sound heard and recorded.


<a id="modem"></a>
### Modem, SMS and data

Ord
: 12

What
: The modem seen, the SIM read, the network joined; messages and data both ways.


<a id="calls"></a>
### Calls

Ord
: 13

What
: A call with sound both ways, the screen dark at the ear, emergency numbers known, calls over LTE.


<a id="radios"></a>
### Local radios

Ord
: 14

What
: Wi-Fi, Bluetooth, NFC, USB host and sharing the connection.


<a id="sensors"></a>
### Sensors and location

Ord
: 15

What
: Motion, light and proximity read and used; a position fix; the fingerprint reader.


<a id="camera"></a>
### Camera

Ord
: 16

What
: From the camera bus to a photo and a video: sensor, raw frame, a viewable stream, focus and flash.


<a id="sleep"></a>
### Sleep and battery life

Ord
: 17

What
: Suspend that returns, wakes only for what matters and reaches the SoC's floor; a day on one charge.


<a id="shell"></a>
### Shell

Ord
: 18

What
: A phone shell on the hardware: keyboard, lock, notifications.


<a id="upkeep"></a>
### Updates and endurance

Ord
: 19

What
: Updates that apply and roll back, and the phone still working after days, upgrades and crashes of its parts.


<a id="goals"></a>
### Goals

Ord
: 20

What
: The steps that only name a whole: Linux runs, a daily-usable phone, a complete phone - each done when all it needs is.
