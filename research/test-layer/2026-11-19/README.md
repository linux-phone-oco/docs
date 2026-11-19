# A hardware-test layer with no phone shell - material (2026-11-19)

Research lead test-layer-research, for orchestration, on the author's words (relayed verbatim):
"i dont really like sxmo anyway.. i think we should reconsider its use. i was thinking earlier that for
hardware support tests we dont use any shells at all and use our own simple tty setup. and we separate
concerns that way, because we already had to deal with the shit that sxmo does that prevents normal testing
of hardware modes, we spent almost 2 days on hurdles caused by it(i may be wrong, but it seems that way).
again for consideration"

He proposed the same on 2026-11-10: surya-lab backlog `shell-free-base` (open since then; "the console-only
image is still to come"). This research measures his claim, then weighs the split. Read only: surya-lab,
docs, lab-tools, google-walleye-lab, grenudi/sxmo-utils (origin/main of each, 2026-11-19 ~02:00 CET), a local
pmaports copy (walleye-build/porthole/pm, upstream as of 2026-09-30), and one read-only researcher for the
outside sources. No phone touched, no lab repository changed.

Rows: research `test-layer-sxmo-cost-measured`, `test-layer-landscape`, `test-layer-how-it-stands`; decision
`2026-11-19-hardware-test-layer`; test `test-layer-quiet`; backlog under `test-layer`.

## 1. What sxmo cost - measured

Times are CET, read from commit times and session-log ids; a span runs from the first sign to the fix
landed. Phone-down hours are the time surya could not be reached.

### Episodes

| # | Episode | First sign -> fix | Phone down | Author's hands | Whose |
|---|---|---|---|---|---|
| 1 | USB link flapping: sxmo's idle suspend retried every ~12 s on USB, each try dropping the link (26 disconnects / 5 min) | 2026-11-10 ~20:45 (after the devlab flash) -> 21:43 (surya-lab #40, devlab-usb-awake) | link flapping | report only | sxmo (no backoff); fix ours |
| 2 | Sound silently lost: sxmo's loopback card the default output | 2026-11-10 -> 13:32 (surya-lab #30) | 0 | 0 | sxmo |
| 3 | r4 standby run: after a Bluetooth SSR stopped it, sxmo's autosleep kept calling `rtcwake -m mem -s 99999999` every 1-20 s into a stuck rfkill; phone wedged | 2026-11-17 22:45Z -> forced reboot 23:56 | ~1.2 h | forced reboot | kernel (BT SSR) + sxmo (kept suspending) |
| 4 | Tries 1-3 (sleep-fastrpc-helpers): after the third `systemctl suspend` returned, sxmo's autosleep ran a nested `rtcwake -m mem -s 99999999`; no return on USB | 2026-11-18 00:10 -> back 08:21 after the author's power cycle; cause read 08:24 (#174) | ~8.2 h (overnight) | power cycle | sxmo nested suspend (likely; journal ends at its s2idle entry) + ours (fuse defused) |
| 5 | Suspend loop again: our devlab-usb-awake held the lock only while the UDC was configured; each sxmo suspend dropped USB, so the lock dropped and the next idle suspend followed | 08:20 -> last suspend 11:17:41 -> lock always held (#195 10:05) proven 12:23 (#199) | ~3 h off USB / flapping | 0 | sxmo loop + ours (lock design) |
| 6 | Screen blanks and relights by itself (the author's question): swayidle 3 s idle + autosuspend on USB; also lock/screen-off from PMIC key edges sxmo turns into state changes | ~11:09 -> closed 12:39 (#207); key chatter left as surya-key-chatter-resin | 0 | the question | sxmo (idle policy, key-driven state); key edges hardware |
| 7 | Try 4: the try stopped devlab-usb; sxmo's autosuspend then wrote wakeup_count and ran `rtcwake -m mem -s 99999999`, replacing the try's 15 s alarm (a ~3-year sleep); the watchdog did not bite | 11:46 -> power hold 12:16; read 13:18 (#216); who-runs-rtcwake 13:46 (#223) | ~0.5 h | power hold | sxmo (alarm default) + ours (try dropped the lock; watchdog not armed through s2idle) |
| 8 | Wake-lock fight: devlab-usb-awake (hand-put) vs lpoco-awake (package); suite 20:40 failed awake-service-active (lpoco-awake inactive, lock held by devlab-usb); host check later read devlab-usb-awake STALE | lab-tools #148 13:22 -> surya-lab #296 21:38; host-check-stale-pieces still open 2026-11-19 | 0 | 0 | ours (response to sxmo) |
| 9 | The sxmo fork, series and lab apk: three patches (backoff, stop-by-profile, surya sensors), a lab tag, an Alpine-forked APKBUILD, two conveyor gaps, install on surya (modemmanager/mmsd-tng/vvmd pinned so apk would not purge them), a held series when surya went silent (the cable) | docs #469 13:51 -> installed 15:31 (surya-lab #250) -> hold lifted 18:52 (docs #522) | 0 (silence 15:36-17:47 was the cable) | 0 | ours (the chosen fix) |
| 10 | Config migration after the lab apk: 4 `.needs-migration` files; read once as "defaults older", re-read as "package newer, ours equal"; then user configs declared for a new drift check | 19:14 (#264) -> 21:43 (#302) -> 01:38 (#326; lab-tools #201) | 0 | 0 | ours (the apk) + sxmo (configversion stamps) |
| 11 | Standing tax: every suspend item carries "sxmo autosleep stopped first" (health-suspend-cycle-proof, sleep-standby-current r5, surya-unreachable rules); sxmo's own locks (sxmo_not_suspendable, sxmo_modem_warming_up) muddle wake-lock readings (surya-sleep-measured) | open | - | - | sxmo |

Not counted (not sxmo): the irq 157 storm and the QCA Bluetooth SSR, hexagonrpcd's RootPD crash on suspend
(sxmo's suspends exposed it on 11-10, the bug is ours/kernel), the watchdog not biting in suspend, the 13:58
probe drop (way-back's own cycle), the 15:36-17:47 silence (cable), the CTS pull-down hang.

### Counts

- surya-lab pull requests touching sxmo (classified by hand from `git log origin/main`):
  - A, investigating or recovering from sxmo's behaviour (25): #30 #40 #164 #173 #174 #175 #190 #191 #192
    #196 #198 #199 #201 #202 #203 #206 #207 #211 #212 #213 #215 #216 #223 #224 #225;
  - B, our response - lock, gate, fork, apk, migration, configs (20): #193 #194 #195 #204 #205 #208 #222
    #231 #233 #247 #250 #257 #262 #264 #295 #296 #297 #298 #302 #326;
  - the device profile for the shell, not in the way (2): #14 #29.
  - On 2026-11-18, 42 of surya-lab's 151 commits (28%) were A or B.
- docs (16): #461 #469 #470 #474 #477 #478 #479 #480 #488 #499 #502 #518 #519 #522 #577 #580.
- lab-tools (7): #148 #157 #168 #169 #172 #181 #201.
- Total about 70 PRs: 25 on sxmo's behaviour, about 43 on our response to it.
- Backlog items made by it, about 24. In surya-lab: sxmo-autosleep-off-lasting, screen-turns-off-by-itself,
  who-runs-rtcwake-99999999, bt-suspend-gate, devlab-usb-awake-hold-through-resume, surya-awake-from-package,
  surya-sxmo-suspend-series, sxmo-config-migration, sxmo-migration-diff, surya-silent-after-sxmo-apk,
  surya-user-config-declared, surya-unreachable-after-suspend, surya-unreachable-after-try4,
  surya-key-chatter-resin (hardware that sxmo amplifies), and host-check-stale-pieces (in part). In docs:
  sxmo-utils-lab-apk, sxmo-utils-lab-apk-deliver, user-config-drift-named, fork-tracking-job (in part),
  workarounds-marked-where-they-stand (in part), and the three sxmo upstream items. In lab-tools: lpoco-awake.
- Phone down for about 12.9 h (8.2 + 3.0 + 1.2 + 0.5). The author's hands were needed three times: the power
  cycle on the morning of 11-18, the power hold at 12:16, and the forced reboot at 23:56 on 11-17. That is
  three of the four interventions on 11-17/18; the fourth, the 13:09 hold, was not sxmo.
- Wall clock of the thread: 2026-11-17 22:45 to 2026-11-19 01:38, about 27 h, run in four lanes at once:
  the surya keeper, the upstreams lane, the lab-tools builder and docs. Lane-hours, estimated from commit
  clusters: the keeper about 5.5 h in the morning, 3 h in the evening and 1 h at night; the upstreams lane
  about 5.5 h; the lab-tools builder about 2 h. That is about 17 lane-hours, plus about 1 h on 2026-11-10.

### Verdict on "almost 2 days"

Half right in the measure, right in the direction.

- The sxmo thread was a day and a night: about 27 h of wall clock and about 17 lane-hours. It was not two
  days.
- It cost about 13 h of surya unreachable and three of the author's hands.
- On 11-18 it was a quarter of surya-lab's commits.

sxmo's own behaviour, its upstream defaults:
- the 1 s retry with no backoff;
- `rtcwake -s 99999999` as the default alarm;
- swayidle at 3 s and a lock/screen state driven by key events;
- its own wake locks;
- the loopback card as default output;
- configversion migration prompts.

Ours:
- a keep-awake that dropped with USB;
- tries that dropped the lock;
- a watchdog that was not armed through s2idle;
- the response we chose: fork, series, apk, package swap and migration, about 43 of the 70 PRs.

The kernel's Bluetooth SSR and the RootPD crash were bugs that sxmo's suspends found, not sxmo's.

So the larger part of the spend was our way of living with sxmo, not sxmo itself. A layer without a shell
removes both: no shell's policy to tame, and nothing to fork.

## 2. How others do it, and what we have

- **walleye** runs no distribution and no init system (google-walleye-lab build/initramfs/init, 84 lines):
  - busybox, a USB gadget (ECM, udhcpd), `telnetd -l /bin/sh` on 172.16.42.1, and a respawned shell on
    ttyGS0;
  - nothing suspends, locks or reads keys;
  - it is the bare-init form of the layer and suits the boot/console/kernel stages.
- **Nura `ui=console`** (`postmarketos-ui-console`):
  - it brings postmarketos-base-ui, NetworkManager and wireless-tools, no compositor and no idle daemon;
  - it is systemd by default;
  - with **`ui=none`** no UI package is installed;
  - both carry sshd from postmarketos-base (openssh-server-pam);
  - logind on Nura systemd: `HandlePowerKey=ignore` (postmarketos-base-systemd logind.conf), and
    `IdleAction=ignore` by systemd's default. A tty system therefore never suspends or powers off by
    itself.
  - images.nura.eco has no console image for qcom-sm7150 (edge, v26.06, v25.12 list gnome-mobile, phosh,
    plasma-mobile and sxmo-de-sway only); one would be built with pmbootstrap.
- **Nura's UIs start from tinydm**:
  - `system-tinydm.service` is `display-manager.service`; it conflicts with getty@tty1 and falls back to it
    on failure;
  - sxmo's autosuspend, swayidle and input handling are user services started by that session
    (sxmo-utils configs/services/sxmo_autosuspend.service).
  - So booting the same image to `multi-user.target` starts no display manager and no sxmo: getty on tty1,
    sshd and the system services only. This is the cheapest separation there is, and it needs no new image.
- **Nura hardware CI** boots a kernel and initramfs on the OnePlus 6T over fastboot and matches
  PMOS-CI-OK/FAIL on serial. Its test environments are containers, not a phone UI.
- **Martijn Braam's phone test rig** wrote a rootfs or booted an initramfs and matched serial strings. No
  one found tests phone hardware under a phone shell.
- **The later UX layer** brings its own idle policy:
  - Phosh: gnome-settings-daemon sleep-inactive-* (Phosh #686);
  - Plasma Mobile: PowerDevil, where disabling suspend is reported hard (KDE bug 497893);
  - sxmo: autosuspend.
  - So each shell needs its own "held off in the lab" proof. That proof belongs to the shell stage, not the
    lab stage.
- **Base distro** (decision 2026-11-19-base-distro, landed #582): stay on Nura with a thin layer of our own.
  The layer is less thin than it needs to be while it carries sxmo-utils@lab. The base's console target is
  the natural hardware-test layer: on surya the same image at multi-user.target, on walleye the first
  rootfs built with no UI package.

## 3. Vectors

1. **Same image, second boot entry at `multi-user.target`** (chosen).
   - How: an entry beside the stock one, the same kernel, dtb and root, `systemd.unit=multi-user.target`
     on the command line. lpoco's test-kernel route already writes entries with boot counting and a
     fallback.
   - Needs: a read-only look first (`systemctl get-default`, what `graphical.target` alone pulls in, which
     suite checks need the user session: pipewire is a user service), then one entry.
   - Cost: 1-2 keeper-hours.
   - Risk: low. A command-line change only; the sxmo entry stays and the fallback catches a failed boot.
   - Proof: the test test-layer-quiet; the base layer of the suite passes as it does under sxmo.
   - Unknowns:
     - audio checks that rely on the session's pipewire: either ALSA-level in this layer, or lingering for
       the user;
     - whether USB networking needs anything from the session: NetworkManager is a system service.
2. **A fresh Nura `ui=console` image built with pmbootstrap**, flashed by devlab.
   - Gain: the cleanest baseline, with sxmo not even installed.
   - Cost: 4-8 h and a witnessed flash; the provisioned state is redone (the manifest bakes the fixes in).
   - Kept for new devices (walleye's first rootfs) and as a later step on surya if vector 1 shows leaks.
3. **Swap the UI in place** (`apk del` the sxmo UI, `apk add postmarketos-ui-console`).
   - Rejected: it loses the UX layer, there is no official doc, and leftover autologin and tinydm state make
     it no clean baseline.
4. **Two root filesystems** (a second root chosen by `pmos.root_uuid` per entry).
   - Rejected for now: it needs space (SD card or resize), boot-deploy may rewrite hand entries, and no one
     documents it on a phone. Vector 1 gives the same split at the systemd level.
5. **Keep sxmo and keep taming it** (lpoco-awake, gates, the fork's series).
   - Rejected: it is the status quo that cost the 70 PRs.
   - It taxes every suspend test with "sxmo autosleep stopped first".
   - The series has no way upstream: SourceHut's terms bar LLM-written content since 2026-09-10 (docs #580).
6. **initramfs-only tests** (walleye's form, Nura CI's hook).
   - Kept for the boot, console and kernel stages on new devices.
   - Rejected for surya's hardware layer: the coprocessors, audio and modem need the rootfs daemons.

## 4. What becomes of the sxmo pieces

- **The patch series** (sxmo-autosuspend-backoff, sxmo-suspend-stop-by-profile, sxmo-surya-sensors-suspend):
  - its first purpose (the lab link) goes with the test layer;
  - its second (daily sleep under sxmo) has no agent path upstream;
  - recommended withdrawn, carried in none, on the author's word. He may send his own version by hand if he
    wants it for daily use.
- **The fork grenudi/sxmo-utils**: the lab branch, the tag lab-20261118.1 and three topics. Archive it,
  keep the history, stop tracking (fork-tracking-job drops it). The surya profile is upstream already
  (1fd7822) and stays.
- **The lab apk**:
  - surya returns to Nura's own sxmo-utils (world backup /root/world.before-sxmo-lab; keep modemmanager,
    mmsd-tng and vvmd in world);
  - lab-tools drops packaging/sxmo-utils and its CI check;
  - the Pages repository then carries lpoco-health alone.
- **lpoco-awake** stays: a lab phone on USB stays awake unless a test asks. It is the lab's policy, no
  longer a WORKAROUND for sxmo-autosuspend-backoff. Its mark goes, and the `bluetooth-not-up` gate stays
  for allow-autosleep runs.
- **Suspend steps that need another proof path**:
  - sensors-across-suspend (test sensors-after-suspend, which says "under Sxmo"): it is proven in the test
    layer by `lpoco-health suspend cycle` stopping and restarting the services the manifest names, which
    is what patch 2/3 did inside sxmo, now in our own tool. A real `systemctl suspend` stops sensorspd by
    its Conflicts= and needs the delayed restart (research 2026-11-18-systemctl-suspend-leaves-sensors-stopped).
  - shell-autosleep-tamed (test suspend-retry-backs-off, sxmo-only): it moves to the shell stage, where it
    is proven per shell by "the shell's idle suspend is held off while the lab works"; the backoff test
    retires with the series.
  - standby-current, call-wakes-from-sleep and alarm-wakes-from-sleep require real-suspend-under-shell
    hard. Standby current is first measured in the test layer: lpoco's own suspend, nothing else
    suspending. The shell's figure follows in the shell stage.
  - s2idle-cycle-returns, radios-survive-suspend and suspend-way-back are already shell-free
    (`lpoco-health suspend cycle`).

## Sources (rows in docs sources)

- surya-lab, docs and lab-tools: git log of origin/main, session_log, research and backlog, read through tad.
- google-walleye-lab build/initramfs/init.
- grenudi/sxmo-utils lab branch: scripts/core/sxmo_autosuspend.sh, configs/services/.
- pmaports postmarketos-ui-console, extra-repos/systemd: system-tinydm.service and postmarketos-base-systemd
  logind.conf (sources pmaports-ui-console, pmaports-tinydm-systemd, pmaports-base-systemd-logind).
- images.nura.eco/bpo/*/qcom-sm7150 (nura-images-sm7150).
- Nura explicit service managers (nura-explicit-service-managers).
- Nura hardware CI MVP (nura-hw-ci-mvp).
- brixit automated phone testing pt 4 (brixit-phone-testing-4).
- logind.conf(5) (systemd-logind-conf).
- Phosh #686 (phosh-686-sleep-inactive).
- KDE bug 497893 (kde-497893-plasma-suspend).
