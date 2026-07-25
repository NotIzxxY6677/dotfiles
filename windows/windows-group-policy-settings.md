# Windows Group Policy Settings (Privacy Hardening)

> **Attribution:** Based on the [Group Policy Settings guide](https://www.privacyguides.org/en/os/windows/group-policies/) by [Privacy Guides](https://www.privacyguides.org/), licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/). This file is a derivative work containing personal additions/corrections (marked below) and is shared under the same CC BY-SA 4.0 license. Privacy Guides does not endorse this file or its modifications.

Based on the Privacy Guides Group Policy list, with personal updates/additions for newer Windows builds.

**Key**
- `E` — Enabled
- `D` — Disabled
- `E, C` — Enabled, with additional configuration required
- `Optional` — up to you / not required

**Markers**
- `(+)` — Added by me
- `(-)` — Not currently used
- `(~)` — Renamed by Windows

All paths below start at: `Local Computer Policy > Computer Configuration > Administrative Templates > ...`

---

## System

### Device Guard
| Policy | Status | Sub-setting |
|---|---|---|
| Turn On Virtualization Based Security | E, C | Platform Security Level: Secure Boot and DMA Protection; Secure Launch Configuration: Enabled |

### Internet Communication Management
| Policy | Status |
|---|---|
| Turn off Windows Customer Experience Improvement Program | E |
| Turn off Windows Error Reporting | E |
| Turn off the Windows Messenger Customer Experience Improvement Program | E |

### OS (Operating System) Policies
| Policy | Status |
|---|---|
| Allow Clipboard History | D |
| Allow Clipboard synchronization across devices | D |
| Enables Activity Feed | D |
| Allow publishing of User Activities | D |
| Allow upload of User Activities | D |

### User Profiles
| Policy | Status |
|---|---|
| Turn off the advertising ID | E |

---

## Windows Components

### AutoPlay Policies
| Policy | Status | Sub-setting |
|---|---|---|
| Turn off AutoPlay | E | |
| Disallow Autoplay for nonvolume devices | E | |
| Set the default behavior for AutoRun | E, C | Default AutoRun Behavior: Do not execute any AutoRun commands |

### BitLocker Drive Encryption
| Policy | Status | Sub-setting |
|---|---|---|
| Choose drive encryption method and cipher strength (Windows Vista, Windows Server 2008, Windows 7, Windows Server 2008 R2) (~) | E, C | Encryption method: AES-256 |
| Require additional authentication at startup (OS drives) | E | |
| Allow enhanced PINs for startup (OS drives) | E | |

### Cloud Content
| Policy | Status |
|---|---|
| Turn off cloud optimized content | E |
| Turn off cloud consumer account state content | E |
| Do not show Windows tips | E |
| Turn off Microsoft consumer experiences | E |

### Credential User Interface
| Policy | Status |
|---|---|
| Require trusted path for credential entry (-) | E |
| Prevent the use of security questions for local accounts | E |

### Data Collection and Preview Builds
| Policy | Status | Sub-setting |
|---|---|---|
| Allow Diagnostic Data | E, C | Pro: "Send required diagnostic data"; Enterprise/Education: "Diagnostic data off" |
| Limit Diagnostic Log Collection | E | |
| Limit Dump Collection | E | |
| Limit optional diagnostic data for Desktop Analytics | E, C | Disable Desktop Analytics collection |
| Do not show feedback notifications | E | |

### File Explorer
| Policy | Status |
|---|---|
| Show files based on your account and cloud provider activity (~) | D |

> Old name was "Turn off account-based insights, recent, favorite, and recommended files in File Explorer" (Enabled) — newer Windows builds renamed this to the entry above.

### MDM
| Policy | Status |
|---|---|
| Disable MDM Enrollment | E |
| Enable automatic MDM enrollment using Azure AD credentials (+) | D |

### Microsoft account
| Policy | Status |
|---|---|
| Block all consumer Microsoft account user authentication (+) | E |

### OneDrive
| Policy | Status |
|---|---|
| Save documents to OneDrive by default | D |
| Prevent OneDrive from generating network traffic until sign-in | E |
| Prevent the usage of OneDrive for file storage | E (set to D if you use OneDrive) |

### Push To Install
| Policy | Status |
|---|---|
| Turn off Push To Install service | E |

### Search
| Policy | Status | Sub-setting |
|---|---|---|
| Allow Cortana | D | |
| Don't search the web or display web results in Search | E | |
| Set what information is shared in Search | E, C | Type of information: Anonymous info |
| Allow search highlights (+) | D | |

### Sync your settings
| Policy | Status |
|---|---|
| Do not sync | E |

### Text input
| Policy | Status |
|---|---|
| Improve inking and typing recognition | D |

### Widgets
| Policy | Status |
|---|---|
| Allow widgets (+) | D |

### Windows AI
| Policy | Status |
|---|---|
| Allow Recall to be enabled (+) | D |
| Turn off saving snapshots for use with Recall (+) | E |
| Disable Click to Do (+) | E |
| Disable Settings agentic search experience (+) | E |
| Remove Microsoft Copilot App (+) | E |

### Windows Error Reporting
| Policy | Status | Sub-setting |
|---|---|---|
| Do not send additional data | E | |
| Consent > Configure Default consent | E, C | Consent level: Always ask before sending data |

### App Privacy
| Policy | Status | Sub-setting |
|---|---|---|
| Let Windows apps access location (+) | E, C | Under Options, set "Default for all apps" to Force Deny |

---

## Notes
- These are intended for a fresh Windows install — applying to an existing install can cause quirks.
- Each policy has Windows' own explanation built into the Group Policy Editor (`gpedit.msc`), worth reading as you configure it.
- Entries marked `(+)`, `(-)`, or `(~)` are personal additions/notes, not from the original Privacy Guides list — double-check they still match your Windows build before applying.
