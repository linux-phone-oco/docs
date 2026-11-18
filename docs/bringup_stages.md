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
