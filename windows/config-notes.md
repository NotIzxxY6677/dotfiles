## PotPlayer + LAV Filters Setup:


1. F5 (Preferences) > Filter Control > Filter Priority (Overall) 
2. Add registered filter > Add these 3 and set to "Prefer":
   - LAV Splitter Source
   - LAV Video Decoder ( Double-click -> Hardware Decoder to use: D3D11 -> Hardware Device to use: Automatic(Native) )
   - LAV Audio Decoder ( Double-click -> Mixing -> If using Headphones/Stereo Speakers: Enable Mixing -> Stereo -> Check "Don't mix Stereo Sources". *Leave unchecked if using true surround sound or Virtual 3D spatial software* )

## Windows Recommended Changes (Navigation based on Windows 11 Pro):
Settings > Time & language > Date & time > Sync now > Change the time server to time.cloudflare.com. This server uses standard (non-smearing) NTP rather than leap-smearing, and is generally the preferred choice for accurate time synchronization.


## OBS Studio (Hardware Specific/Desktop-dGPU: AMD Radeon RX 7800 XT)

```
File > Settings > Output > Recording Tab:
Output Mode: Advanced
Recording(Type: Standard)
Recording Format: Matroska Video (.mkv)
Video Encoder: AMD HW AV1
Audio Encoder: CoreAudio AAC (Fallback: FFmpeg Opus, FFmpeg AAC) [Note: You will have to install Apple iTunes in order to use CoreAudio AAC,*winget install -e --id=Apple.iTunes*]
Encoder Settings:
Rate Control: CQP
File > Settings > Advanced
Recording: Automatically remux to mp4 
```

## OBS Studio (Hardware Specific/Laptop-iGPU: Intel(R) UHD Graphics 620)

```
File > Settings > Output > Recording Tab:
Output Mode: Advanced
Recording(Type: Standard)
Recording Format: Matroska Video (.mkv)
Video Encoder: QuickSync HEVC (Fallback: QuickSync H.264, x264)
Audio Encoder: CoreAudio AAC (Fallback: FFmpeg Opus, FFmpeg AAC) [Note: You will have to install Apple iTunes in order to use CoreAudio AAC,*winget install -e --id=Apple.iTunes*]
Encoder Settings:
Rate Control: ICQ
ICQ Quality: 23 (default) or 24 (Saves ~10-15% storage space)
Target Usage: TU5: Fast
File > Settings > Advanced
Recording: Automatically remux to mp4
```
