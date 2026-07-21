# EMERGENCY: Wrong Clock on Boot, Time Will Not Sync

Architecture reminder: apps → resolver → chronyd (NTS). A badly wrong clock breaks **TLS validation itself** (DoT/NTS-KE X.509 validation) before chrony's time synchronization is even attempted.

Recovery order is: **clock → time daemon → RTC**.

## 1) Confirm the Situation

```bash
timedatectl status
chronyc tracking
chronyc sources -v
```

## 2) Set the Clock to Roughly "Now"

This is required so DoT/NTS TLS certificates validate.

(a) Simplest — type an approximate current LOCAL wall-clock time:

```bash
sudo date -s 'YYYY-MM-DD HH:MM:SS'
```

(b) Or pull rough time from a plain-HTTP Date header (immune to the DNS/TLS deadlock). Any reachable HTTP server IP (including your gateway) works:

```bash
sudo date -s "$(curl -sI [http://1.1.1.1](http://1.1.1.1) | tr -d '\r' | sed -n 's/^[Dd]ate: //p')"
```

## 3) Force Chrony to Re-resolve and Sync

Force re-resolution, NTS-KE re-keying, and step to true time.

```bash
sudo systemctl restart chronyd
sudo chronyc burst 4/4
sleep 8
sudo chronyc makestep
```

## 4) Verify Health

Verify that 'Leap status' reports as Normal, the offset approaches zero, NTS sources show valid cookies, and the system clock is synchronized.

```bash
chronyc tracking
chronyc -N authdata
timedatectl status
```

## 5) Write Time to RTC

Persists only if the CMOS battery is healthy.

```bash
sudo hwclock --systohc
```

## Architectural Context

A dead CMOS battery loses the RTC's stored time (and CMOS settings) at power-off. While `chronyd -s` (sysconfig) floors the clock at each boot to the driftfile mtime to mitigate a grossly wrong clock at boot, replacing the physical battery is the only permanent remediation for hardware-level clock loss. If DNS or TLS (DoT/NTS) validation deadlocks due to an invalid clock, manual steps or plain-HTTP scraping are required to break the loop.
