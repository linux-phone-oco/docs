<!-- Generated from data/ by tad. Do not edit by hand. -->

# Hardware

<a id="uart-1v8-adapter"></a>
### 1.8 V FT232-class USB-serial adapter

Kind
: adapter

Status
: general

Spec
: FT232 chip, logic level 1.8 V (a jumper on some boards, for example DSD TECH SH-U09C2 - a retailer's claim); an FT232R supports break (KGDB sysrq), a CP2102N does not

Serves
: phones with the console UART on the USB-C SBU pins (Pixel 2 and family, per the sources)

Sources
: android-debug-cable-howto,bacon-pixel-uart,xairy-pixel-kgdb

Note
: Check the level before connecting: 3.3 V can damage a 1.8 V phone. Variants with other chips are other rows.

Checked on
: 2026-11-17


<a id="usbc-sbu-breakout"></a>
### USB-C passthrough breakout that brings out the SBU pins

Kind
: breakout

Status
: general

Spec
: USB2 data, CC1/CC2 and SBU1/SBU2 passed through; a stock phone cable lacks the SBU and CC lines and does not work

Serves
: phones with the console UART on the SBU pins

Sources
: android-debug-cable-howto,bacon-pixel-uart

Checked on
: 2026-11-17


<a id="usb-cereal"></a>
### USB-Cereal (google/usb-cereal)

Kind
: adapter

Status
: general

Spec
: SBU1 = TX, SBU2 = RX, DIP 1.8/3.3 V, orientation-specific, not USB-C compliant; repository archived 2023-01-10; sold soldered by third parties

Serves
: phones with the console UART on the SBU pins

Sources
: google-usb-cereal,xairy-pixel-kgdb

Note
: A wrong DIP setting can damage the target; the chip edition matters (FT232R vs CP2102N). Prices go in the lab's base, dated.

Checked on
: 2026-11-17


<a id="uart-debug-setup"></a>
### A phone's console on UART through the USB-C SBU pins

Kind
: setup

Status
: general

Wiring
: SBU1 (A8) is the phone's TX into the adapter's RX; SBU2 (B8) the phone's RX from the adapter's TX; ground on A1; 1.8 V; 115200 baud, 8N1; orientation differs between phones. On a Pixel: fastboot oem uart enable (bootloader unlocked), reboot to fastboot; fastboot oem uart disable turns it off. It gives a log only.

Serves
: Pixel 2 and family; each phone's own base says what is confirmed

Sources
: android-debug-cable-howto,bacon-pixel-uart,xairy-pixel-kgdb,google-usb-cereal

Note
: General from the sources; confirmed on no phone here yet (walleye's base holds the claim and, later, its evidence).

Checked on
: 2026-11-17
