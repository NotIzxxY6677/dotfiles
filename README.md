# dotfiles

Modular post-install configs, system hardening, and cross-platform reference notes for Linux (Fedora KDE) and Windows. The focus is a privacy-hardened, fail-closed network stack: encrypted DNS end to end, authenticated (NTS) time synchronization, and telemetry reduction.

## Repository structure

```
common/    Cross-platform references (dnscrypt-proxy overrides, DNS/NTP server list)
linux/     Fedora KDE post-install: networking drop-ins, debloat script, app notes
windows/   Windows post-install: GPO privacy settings, winget app lists, disk setup
```

### common/

- `dnscrypt-proxy-reference.txt` — Partial `dnscrypt-proxy.toml` (overrides from defaults only; not a standalone config). Selects DoH/DoH3 resolvers requiring DNSSEC, no-log, and no-filter policies, with listen addresses for Linux (active) and Windows (commented).
- `privacy-dns-ntp-reference.md` — Curated public DNS resolvers (Cloudflare, Google, Quad9) with their encrypted-transport endpoints and ECS behavior, plus NTP servers split into NTS-capable non-smearing sources and leap-smearing sources.

### linux/

Two alternative encrypted-DNS stacks are provided under `linux/networking/` — deploy **one**, not both:

- `encrypted-dns/` — systemd-resolved speaks DNS-over-TLS **directly** to public resolvers (strict mode, fail-closed, no plaintext fallback).
- `proxy-dns/` — systemd-resolved acts as a thin bridge to a **local dnscrypt-proxy** instance on `127.0.0.1:53`, which handles DoH/HTTP3, load balancing, and upstream DNSSEC (pair with `common/dnscrypt-proxy-reference.txt`).

Each variant ships a matching `time-sync-rescue.md` runbook for the cold-boot deadlock where a wrong clock breaks TLS validation (DoT/DoH/NTS) before time can sync.

Shared pieces:

- `networking/90-disable-nm-dns.conf` — NetworkManager drop-in that removes NM from the DNS path entirely (`dns=none`, no D-Bus pushes to resolved).
- `networking/99-net-transport-optimization.conf` — sysctl drop-in for the measured link (~500 Mbit/s fibre, ~3.4 ms RTT, BDP ≈ 214 KB): MTU black-hole probing and `tcp_notsent_lowat`. Buffer ceilings and congestion control deliberately stay on kernel defaults, which already exceed the BDP many times over; BBR + fq and future-VPN (WARP/WireGuard) MTU/MSS notes are kept commented in the file.
- `networking/nts/` — chrony configured for NTS-only, non-smearing time sync (`chrony.conf`) plus the matching `/etc/sysconfig/chronyd` flags file (`-s -F 2`) that defends against the DNS↔time deadlock.
- `install.sh` — Idempotent placement of the files above (see the deployment map): installs only what differs, restores SELinux labels, reloads only affected services.
- `fedora-kde-debloat.sh` — One-shot removal of unneeded preinstalled KDE/Fedora apps.
- `config-notes.md` — Hardware-specific notes (Jellyfin via Podman, EEE disable, OBS encoder settings).

#### Deployment map (manual)

Both hosts (desktop, laptop) receive identical files; nothing is per-machine. `linux/install.sh encrypted-dns` or `linux/install.sh proxy-dns` places everything below idempotently, or copy by hand:

| Repo file (under `linux/`) | Destination | Apply |
|---|---|---|
| `networking/90-disable-nm-dns.conf` | `/etc/NetworkManager/conf.d/` | `systemctl reload NetworkManager` |
| `networking/encrypted-dns/90-dns-strict-policy.conf` **or** `networking/proxy-dns/90-dns-bridge-policy.conf` — one, never both | `/etc/systemd/resolved.conf.d/` | `systemctl restart systemd-resolved` |
| `networking/99-net-transport-optimization.conf` | `/etc/sysctl.d/` | `sysctl -p /etc/sysctl.d/99-net-transport-optimization.conf` (reboot to *unset* removed keys) |
| `networking/nts/chrony.conf` | `/etc/chrony.conf` | `systemctl restart chronyd` |
| `networking/nts/chronyd` | `/etc/sysconfig/chronyd` | `systemctl restart chronyd` |

`fedora-kde-debloat.sh` is run once, not placed. SELinux note: files *created* under `/etc` (as `install`/`cp` do) inherit correct labels; after a `mv`, run `restorecon -v <dest>`.

### windows/

- `windows-group-policy-settings.md` — Group Policy privacy hardening checklist (telemetry, Cloud Content, Recall/Copilot, OneDrive, Search, etc.). **Separately licensed — see below.**
- `apps.txt` / `apps-for-others.txt` — winget one-liners: a personal app set, and a broader-compatibility set (all VC++ redists, VLC, JDK) for machines set up for other people.
- `enable-utc.reg` — Store the RTC in UTC (`RealTimeIsUniversal`) for dual-boot clock sanity.
- `setup-partitions.bat` — **Destructive.** Wipes the hardcoded target disk and lays down a GPT layout (2 GiB ESP, MSR, 192 GiB Windows, 1 GiB Recovery). Read it and verify the disk number before running.
- `config-notes.md` — PotPlayer/LAV Filters setup, NTP server change, OBS encoder settings.

## Licensing

This repository is dual-licensed:

- **Everything except the file below** is released into the public domain under the [Unlicense](https://unlicense.org) — see [`LICENSE`](LICENSE).
- **`windows/windows-group-policy-settings.md`** is a derivative of the [Privacy Guides Group Policy Settings guide](https://www.privacyguides.org/en/os/windows/group-policies/) and is licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/), per the attribution header inside the file. If you redistribute or adapt that file, CC BY-SA 4.0 terms apply to it (attribution + share-alike), not the Unlicense.
