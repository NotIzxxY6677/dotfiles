## Jellyfin Podman Setup (Hardware Specific/Desktop)

```bash
podman run \
  --detach \
  --restart unless-stopped \
  --label "io.containers.autoupdate=registry" \
  --security-opt label=disable \
  --name myjellyfin \
  --publish 8096:8096/tcp \
  --device /dev/dri/renderD128:/dev/dri/renderD128 \
  --device /dev/dri/renderD129:/dev/dri/renderD129 \
  --user $(id -u):$(id -g) \
  --userns keep-id \
  --volume jellyfin-cache:/cache:Z \
  --volume jellyfin-config:/config:Z \
  --mount type=bind,source=/run/media/pc/HDD-Storage/Downloads/Media/,destination=/media,ro=true,relabel=private \
  docker.io/jellyfin/jellyfin:latest

sudo firewall-cmd --add-port=8096/tcp --permanent
sudo firewall-cmd --reload
```

## Disable EEE - Energy Efficient Ethernet (Hardware Specific/Desktop)
```bash
# Requires NetworkManager >= 1.46 (nmcli --version to check)
sudo nmcli connection modify Wired_Connection ethtool.eee-enabled off
sudo nmcli connection up Wired_Connection

# Verify
sudo ethtool --show-eee enp8s0
```

## OBS Studio (Hardware Specific/Desktop-dGPU: AMD Radeon RX 7800 XT)

```
File > Settings > Output > Recording Tab:
Output Mode: Advanced
Recording(Type: Standard)
Recording Format: Matroska Video (.mkv)
Video Encoder: FFmpeg VAAPI AV1
Audio Encoder: FFmpeg Opus (Fallback: libfdk AAC, FFmpeg AAC)
Encoder Settings:
Rate Control: CQP
File > Settings > Advanced
Recording: Automatically remux to mp4 
```

## OBS Studio (Hardware Specific/Laptop-iGPU: Intel UHD Graphics 620 @ 1.15 GHz)

```
File > Settings > Output > Recording Tab:
Output Mode: Advanced
Recording(Type: Standard)
Recording Format: Matroska Video (.mkv)
Video Encoder: QuickSync HEVC (Fallback: FFmpeg VAAPI HEVC)
Audio Encoder: FFmpeg Opus (Fallback: libfdk AAC, FFmpeg AAC)
Encoder Settings:
Rate Control: ICQ
ICQ Quality: 23 (default) or 24 (Saves ~10-15% storage space)
Target Usage: TU5: Fast
File > Settings > Advanced
Recording: Automatically remux to mp4 
```
