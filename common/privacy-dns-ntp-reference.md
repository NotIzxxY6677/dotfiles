# Privacy-Focused DNS & NTP Server Reference

Curated public DNS resolvers and NTP servers, selected for encrypted transport support (DoH/DoT/DoH3, NTS) and explicit EDNS Client Subnet (ECS) / leap-smear behavior.

## DNS Servers

### Cloudflare
*No ECS — Cloudflare deliberately does not forward client subnet info to authoritative servers, for privacy.*
*DoH3 supported*

**IPv4**
```
1.1.1.1
1.0.0.1
```

**IPv6**
```
2606:4700:4700::1111
2606:4700:4700::1001
```

**HTTPS (DoH / DoH3)**
```
https://cloudflare-dns.com/dns-query
```

**TLS (DoT)**
```
one.one.one.one
```

### Google
*ECS supported — auto-detected per authoritative server and sent by default (no opt-in needed).*
*DoH3 supported*

**IPv4**
```
8.8.8.8
8.8.4.4
```

**IPv6**
```
2001:4860:4860::8888
2001:4860:4860::8844
```

**HTTPS (DoH / DoH3)**
```
https://dns.google/dns-query
```

**TLS (DoT)**
```
dns.google
```

### Quad9
*Malware blocking, DNSSEC validation.*
*No ECS on the default 9.9.9.9 service, to preserve anonymity. The 9.9.9.11 variant sends ECS if you want better CDN geo-routing at a small privacy cost.*
*DoH3 supported*

**IPv4**
```
9.9.9.9
149.112.112.112
```

**IPv6**
```
2620:fe::fe
2620:fe::9
```

**HTTPS (DoH / DoH3)**
```
https://dns.quad9.net/dns-query
```

**TLS (DoT)**
```
dns.quad9.net
```

## NTP Servers

### Non-Smearing (NTS-capable)

All five sources below support Network Time Security (NTS) for authenticated time sync.

**Hostnames (IPv4 and IPv6 compatible)**
```
time.cloudflare.com
nts.netnod.se
ptbtime1.ptb.de
ntppool1.time.nl
ntppool2.time.nl
```

**Cloudflare anycast addresses** *(the other four are single-operator services without a comparable small fixed IP set — use the hostnames for those)*

IPv4:
```
162.159.200.1
162.159.200.123
```

IPv6:
```
2606:4700:f1::1
2606:4700:f1::123
```

### Linear-Smearing (12:00 UTC → 12:00 UTC, 24h)

**Hostnames (IPv4 and IPv6 compatible)**
```
time.google.com
time.aws.com
```

Neither service advertises NTS support — both use unauthenticated NTP.
