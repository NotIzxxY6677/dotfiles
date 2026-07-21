# EMERGENCY: Wrong Clock on Boot, Time Will Not Sync

Architecture reminder: apps → 127.0.0.53 (resolved stub) → 127.0.0.1:53 (dnscrypt-proxy, DoH/HTTP3) → upstream. A badly wrong clock breaks **DNS itself** (DoH X.509 validation) before chrony's NTS-KE is even attempted.

Recovery order is: **clock → resolver → time daemon → RTC**.

## 1) Confirm the Situation

```bash
timedatectl status
chronyc tracking
chronyc sources -v
resolvectl status
resolvectl query cloudflare.com
journalctl -u dnscrypt-proxy -n 20
```

## 2) Set the Clock to Roughly "Now"

This is required so DoH/NTS TLS certificates validate.

(a) Simplest — type an approximate current LOCAL wall-clock time:

```bash
sudo date -s 'YYYY-MM-DD HH:MM:SS'
```

(b) Or pull rough time from a plain-HTTP Date header (immune to the DNS/TLS deadlock):

```bash
sudo date -s "$(curl -sI [http://1.1.1.1](http://1.1.1.1) | tr -d '\r' | sed -n 's/^[Dd]ate: //p')"
```

## 3) Revive the Resolver

dnscrypt-proxy must be restarted after the clock jump to re-run DoH handshakes with a valid clock.

```bash
sudo systemctl restart dnscrypt-proxy
sleep 2
resolvectl flush-caches
# Note: dig requires the bind-utils package to be preinstalled
dig @127.0.0.1 time.cloudflare.com +short
resolvectl query google.com
```

## 4) Force Chrony to Re-resolve and Sync

Force re-resolution, NTS-KE re-keying, and step to true time.

```bash
sudo systemctl restart chronyd
sudo chronyc burst 4/4
sleep 8
sudo chronyc makestep
```

## 5) Verify Health

```bash
chronyc tracking
chronyc -N authdata
timedatectl status
resolvectl query ietf.org
```

## 6) Write Time to RTC

Persists only if the CMOS battery is healthy.

```bash
sudo hwclock --systohc
```

## Architectural Context

`chronyd -s` (sysconfig) floors the clock at boot to the driftfile mtime — "last time chronyd ran" — which keeps both dnscrypt-proxy's DoH certs and chrony's NTS-KE inside validity windows. `ntsdumpdir` cookies additionally skip the KE round-trip, but cookies cannot resolve hostnames: if DNS is dead, only steps 2–3 above break the loop. `nocerttimecheck 1` covers chrony's own TLS only, never the resolver's.
