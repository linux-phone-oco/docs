To: sm7150-mainline (an issue or pull request on github.com/sm7150-mainline/linux), for Aelin Reidel
Subject: surya: WCD9375 - four fixes, and the microphones record

Hi! We are working on audio for the POCO X3 NFC (surya): the speakers are stereo with two tas2562
fixes we will send upstream, and with the four patches attached the WCD9375 microphones record on
mainline - proven on the phone by its own test (a quiet tone from the speaker found by the bottom
microphone, 57 dB above the noise). They pick up where your "WIP WCD stuff" (7b00a934ace1, reverted in
6ec3051564fd) and the davinci work (PR #60) left the codec:

1. pinctrl-sm7150-lpass-lpi: two SoundWire data pins select their function at the wrong mux index -
   TX data 1 (gpio1 here, gpio19 in the vendor's count) is mux 3, RX data 1 (gpio5 / gpio23) is mux 2,
   per the vendor's sm6150-lpi device tree. This was the TX bus clash.
2. sm7150: the TX and RX SoundWire controllers are at 0x62ed0000 and 0x62ef0000 (the vendor's
   swrm-io-base), and this SoC's DSP rejects the LPASS_HW_DCODEC_VOTE request (error 3), which made the
   VA macro fail and the card defer; the patch drops that vote and clocks the VA macro like TX and RX.
3. sm7150-xiaomi: the codec's reset is active-low and belongs to the driver; its "sleep" pin state
   drove it low, and ASoC selects a component's sleep state whenever it is idle (at card registration
   and after every stream), so the codec dropped off both buses about a millisecond after the card
   registered (a function trace of pinctrl_commit_state caught it from snd_soc_bind_card).
4. sm7150-xiaomi-surya: capture through the TX SoundWire controller's DAI 1 - DAI 0 is its playback DAI
   (one data-out port), so the capture ports were never programmed and recordings were silence. This
   one we found in pulpoff/linux-surya, a mainline tree for surya on Mobian that already records both
   microphones and carries call audio; credit to them.

Also learned: this ADSP firmware rejects the VA capture port (AFE port 0xb021, error 3).

The patches are linux-phone-oco/linux pull requests 3 to 6. Our notes and logs are public:
https://linux-phone-oco.github.io/docs/ (backlog: microphone) and linux-phone-oco/surya-lab
research/microphone.md.

Thank you for the SM7150 work - it is what made any of this possible.
