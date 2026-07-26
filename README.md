# dotfiles

Modular post-install configs, system hardening, and cross-platform reference notes for Linux (Fedora KDE) and Windows. The focus is a privacy-hardened, fail-closed network stack: encrypted DNS end to end, authenticated (NTS) time synchronization, and telemetry reduction.

## Repository structure

```
common/    Cross-platform references (dnscrypt-proxy overrides, DNS/NTP server list)
linux/     Fedora KDE post-install: networking drop-ins, debloat script, app notes
windows/   Windows post-install: GPO privacy settings, winget app lists, disk setup
```

### common/

- `dnscrypt-proxy-reference.txt` — Partial `dnscrypt-proxy.toml` (overrides from defaults only; not a standalone config). Selects DoH/DoH3 resolvers requiring DNSSEC, no-log, and no-filter policies, with commented listen addresses for both Linux and Windows.
- `privacy-dns-ntp-reference.md` — Curated public DNS resolvers (Cloudflare, Google, Quad9) with their encrypted-transport endpoints and ECS behavior, plus NTP servers split into NTS-capable non-smearing sources and leap-smearing sources.

### linux/

Two alternative encrypted-DNS stacks are provided under `linux/networking/` — deploy **one**, not both:

- `encrypted-dns/` — systemd-resolved speaks DNS-over-TLS **directly** to public resolvers (strict mode, fail-closed, no plaintext fallback).
- `proxy-dns/` — systemd-resolved acts as a thin bridge to a **local dnscrypt-proxy** instance on `127.0.0.1:53`, which handles DoH/HTTP3, load balancing, and upstream DNSSEC (pair with `common/dnscrypt-proxy-reference.txt`).

Each variant ships a matching `time-sync-rescue.md` runbook for the cold-boot deadlock where a wrong clock breaks TLS validation (DoT/DoH/NTS) before time can sync.

Shared pieces:

- `networking/90-disable-nm-dns.conf` — NetworkManager drop-in that removes NM from the DNS path entirely (`dns=none`, no D-Bus pushes to resolved).
- `networking/99-net-transport-optimization.conf` — sysctl drop-in: BBR + fq, MTU probing, `tcp_notsent_lowat`, and raised buffer ceilings for QUIC/DoH3 (~500 Mbps profile).
- `networking/nts/` — chrony configured for NTS-only, non-smearing time sync (`chrony.conf`) plus the matching `/etc/sysconfig/chronyd` flags file (`-s -F 2`) that defends against the DNS↔time deadlock.
- `fedora-kde-debloat.sh` — One-shot removal of unneeded preinstalled KDE/Fedora apps.
- `config-notes.md` — Hardware-specific notes (Jellyfin via Podman, EEE disable, OBS encoder settings).

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
