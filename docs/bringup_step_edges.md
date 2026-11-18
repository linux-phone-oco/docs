<!-- Generated from data/ by tad. Do not edit by hand. -->

# Bringup Step Edges

### Row 1

Step
: bootloader-unlocked

Requires
: stock-measured

Kind
: soft

Why
: an unlock may wipe the stock system


### Row 2

Step
: control-image-boots

Requires
: bootloader-unlocked

Kind
: hard

Why
: fastboot boot needs an unlocked bootloader


### Row 3

Step
: control-image-boots

Requires
: slot-state-known

Kind
: hard

Why
: walleye: refusals were the slot state (walleye-load-error-first-state)


### Row 4

Step
: boot-image-packs

Requires
: stock-facts-read

Kind
: hard

Why
: the header and offsets are the stock image's


### Row 5

Step
: kernel-builds

Requires
: stock-facts-read

Kind
: soft

Why
: the dtb ids the bootloader matches


### Row 6

Step
: dtbo-accepted

Requires
: kernel-builds

Kind
: hard

Why
: it is our dtb that must merge


### Row 7

Step
: stock-kernel-runs-our-init

Requires
: control-image-boots

Kind
: hard

Why
: the control is the image swapped into


### Row 8

Step
: stock-kernel-runs-our-init

Requires
: boot-image-packs

Kind
: hard

Why
: the swap repacks


### Row 9

Step
: stock-kernel-runs-our-init

Requires
: initramfs-gadget-emulated

Kind
: soft

Why
: an init proven emulated spends no phone time


### Row 10

Step
: crash-window

Requires
: stock-facts-read

Kind
: soft

Why
: the ramoops region is the stock fdt's


### Row 11

Step
: reference-kernel-boots

Requires
: control-image-boots

Kind
: hard

Why
: same bootloader path


### Row 12

Step
: reference-kernel-boots

Requires
: boot-image-packs

Kind
: hard

Why
: packed the device's way


### Row 13

Step
: kernel-reaches-init

Requires
: kernel-builds

Kind
: hard

Why
: it is our kernel


### Row 14

Step
: kernel-reaches-init

Requires
: boot-image-packs

Kind
: hard

Why
: packed the device's way


### Row 15

Step
: kernel-reaches-init

Requires
: control-image-boots

Kind
: hard

Why
: the bootloader accepts images


### Row 16

Step
: kernel-reaches-init

Requires
: dtbo-accepted

Kind
: hard

Why
: walleye: no start without the merge (walleye-dtbo-overlay-merge-why)


### Row 17

Step
: kernel-reaches-init

Requires
: crash-window

Kind
: soft

Why
: without one a dead kernel says nothing


### Row 18

Step
: kernel-reaches-init

Requires
: reference-kernel-boots

Kind
: soft

Why
: the bisect reference


### Row 19

Step
: uart-console

Requires
: kernel-builds

Kind
: hard

Why
: it is our kernel's log


### Row 20

Step
: gadget-enumerates

Requires
: kernel-reaches-init

Kind
: hard

Why
: our kernel's gadget


### Row 21

Step
: gadget-enumerates

Requires
: initramfs-gadget-emulated

Kind
: hard

Why
: the init makes the gadget


### Row 22

Step
: banner-on-console

Requires
: gadget-enumerates

Kind
: hard

Group
: console

Why
: the console over the gadget


### Row 23

Step
: banner-on-console

Requires
: uart-console

Kind
: hard

Group
: console

Why
: or over UART


### Row 24

Step
: shell-on-console

Requires
: banner-on-console

Kind
: hard

Why
: a console that carries text first


### Row 25

Step
: first-dmesg-mapped

Requires
: shell-on-console

Kind
: hard

Why
: dmesg is read through the shell


### Row 26

Step
: dmesg-clean

Requires
: first-dmesg-mapped

Kind
: hard

Why
: the map names what to clean


### Row 27

Step
: pmic-bound

Requires
: shell-on-console

Kind
: hard

Why
: read through the shell


### Row 28

Step
: pmic-bound

Requires
: first-dmesg-mapped

Kind
: soft

Why
: the map names the PMIC's faults


### Row 29

Step
: charger-online

Requires
: pmic-bound

Kind
: hard

Why
: the charger is a PMIC child


### Row 30

Step
: watchdog-way-back

Requires
: kernel-reaches-init

Kind
: hard

Why
: it is our kernel that hangs


### Row 31

Step
: watchdog-way-back

Requires
: pmic-bound

Kind
: soft

Why
: walleye's way is the PMIC watchdog


### Row 32

Step
: storage-readonly

Requires
: shell-on-console

Kind
: hard

Why
: read through the shell


### Row 33

Step
: storage-readonly

Requires
: dmesg-clean

Kind
: soft

Why
: smmu and supplier faults stop DMA devices


### Row 34

Step
: usb-network

Requires
: gadget-enumerates

Kind
: hard

Why
: the network rides the gadget


### Row 35

Step
: rootfs-boots

Requires
: storage-readonly

Kind
: hard

Why
: the root is on the storage


### Row 36

Step
: rootfs-boots

Requires
: usb-network

Kind
: hard

Why
: ssh is the proof


### Row 37

Step
: health-suite-runs

Requires
: rootfs-boots

Kind
: hard

Why
: the suite runs on the root
