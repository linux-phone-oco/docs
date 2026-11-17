# One controlled s2idle cycle on surya, by hand (2026-11-17, surya-keeper)

- suspend-cycle.sh: before/after snapshots (qcom_stats, suspend_stats, wakeup sources, cluster idle states,
  interrupts, RTC), USB gadget let go with soft_connect, `rtcwake -m freeze -s 60`. Put it on the phone
  (`devlab phone put`) and run it as a transient unit: `systemd-run --unit=NAME sh /var/tmp/cycle.sh`
  (a nohup child dies when the ssh session ends). Read /var/tmp/sleep-cycle/ over USB after.
- suspend-wake-trace.sh: the same with ftrace (irq entries, suspend_resume, function stack trace on the
  wake functions). Found the wake: `s2idle_wake <- pm_system_irq_wakeup <- irq_pm_handle_wakeup`, raised in
  suspend_device_irqs, with dmesg "irq 157: nobody cared ... Disabling IRQ #157" (qcom_geni_serial_isr,
  the serial at 88c000, wake enabled).
- Never trust date or dmesg time across a sleep (clocks stand still); read the RTC (rtc0/since_epoch).
- Never read /sys/power/wakeup_count with a wake lock held: it blocks.
- Measured 5 times on kernel 7.1.0-sm7150-calls+ (once with cluster states 0x41002244 / 0x4100c244 in the
  device tree, booted by `devlab kernel try calls --dtb`): every cycle ended in about 2 s, never entered
  s2idle's idle loop; cxsd 0, aosd 0, cluster S2 0 each time.
