# ❄️ NixOS Plasma - Dotfiles (Flake Edition)

[English](#english) | [Srpski](#srpski)

---

<a name="english"></a>
## 🇬🇧 English

This repository contains my personal NixOS configuration powered by **KDE Plasma 6** and **Nix Flakes** for a deterministic and reproducible system, specifically optimized for laptop stability, thermal efficiency, and configured as a **"digital fortress"** with multiple layers of protection.

### 📂 File Structure
* `flake.nix` — System entry point, defines inputs and package versions.
* `configuration.nix` — Main system-wide settings (bootloader, services, drivers).
* `home.nix` — Home Manager configuration (user packages, git, dotfiles).
* `modules/` — Modularized configs for cleaner organization.

### 🛡️ Security Hardening
1. **Privileged Access (`doas`):** Standard `sudo` is disabled for the more minimalist and secure `doas`.
2. **Sandbox Isolation (`Firejail` & `Flatseal`):** Firefox and Telegram are isolated. Flatseal manages Flatpak permissions.
3. **Network & Privacy:** Password SSH is disabled (ED25519 only). DNS over TLS (DoT) via systemd-resolved.
4. **Physical Security (`USBGuard`):** Blocks all unauthorized USB devices by default to prevent Rubber Ducky attacks.
5. **System Hygiene:** Automated weekly Garbage Collection and store optimization.

### 🌡️ Thermal Optimization (TLP)
Specifically tuned for Intel 13th Gen (i5-1334U):
* **AC Performance:** Limited to 81%.
* **Battery Performance:** Limited to 60%.
* **Turbo Boost:** Disabled to prevent spikes and fan noise.


## 🚀 How to Apply

### ⚠️ Important: Hardware Configuration
The file `hardware-configuration.nix` is **not** meant to be shared. It is unique to your machine's UUIDs.

1. Clone this repository:
   ```bash
   git clone [https://github.com/linuxdeda/nixos-flakes.git](https://github.com/linuxdeda/nixos-flakes.git)

2. Generate your hardware config:  

   nixos-generate-config --show-hardware-config > hardware-configuration.nix
   
3. Run:

   doas nixos-rebuild switch --flake .#nixos

---

<a name="srpski"></a>
## 🇷🇸 Srpski

Ovaj repozitorijum sadrži moju ličnu NixOS konfiguraciju baziranu na **KDE Plasma 6** i **Nix Flakes** sistemu za determinističku i ponovljivu instalaciju. Sistem je optimizovan za stabilnost laptopa, termalnu efikasnost i konfigurisan kao **"digitalna tvrđava"** sa više nivoa zaštite.

### 📂 Struktura fajlova
* `flake.nix` — Ulazna tačka sistema, definiše verzije paketa.
* `configuration.nix` — Glavna sistemska podešavanja (bootloader, servisi, drajveri).
* `home.nix` — Home Manager konfiguracija (korisnički paketi, git, dotfiles).
* `modules/` — Modularne konfiguracije radi bolje organizacije.

### 🛡️ Bezbednosne mere
1. **Pristup privilegijama (`doas`):** Standardni `sudo` je zamenjen lakšim i bezbednijim `doas` alatom.
2. **Izolacija aplikacija (`Firejail` & `Flatseal`):** Firefox i Telegram su izolovani. Flatseal upravlja Flatpak dozvolama.
3. **Mreža i privatnost:** SSH lozinke su isključene (samo ED25519 ključevi). DNS preko TLS-a (DoT) preko systemd-resolved.
4. **Fizička bezbednost (`USBGuard`):** Blokira sve neovlašćene USB uređaje radi sprečavanja "Rubber Ducky" napada.
5. **Higijena sistema:** Automatsko nedeljno čišćenje starih generacija i optimizacija Nix store-a.

### 🌡️ Termalna optimizacija (TLP)
Posebno podešeno za Intel 13. generaciju (i5-1334U):
* **AC performanse:** Ograničeno na 81%.
* **Baterija performanse:** Ograničeno na 60%.
* **Turbo Boost:** Isključen radi sprečavanja skokova temperature i buke ventilatora.

---

## ⌨️ Custom Aliases (Fish Shell)

| Alias | Command | Description / Opis |
| :--- | :--- | :--- |
| `sys-up` | `doas nixos-rebuild switch --flake .#nixos` | Apply changes / Primeni izmene |
| `sys-clean` | `doas nix-collect-garbage -d` | Clean old versions / Obriši staro smeće |
| `usb-list` | `doas usbguard list-devices` | List USB devices / Lista USB uređaja |
| `usb-allow` | `doas usbguard allow-device` | Whitelist USB / Dozvoli USB uređaj |
| `gens` | `nixos-rebuild list-generations` | List versions / Lista verzija sistema |

---

## 🚀 Kako primeniti

### ⚠️ Važno: Konfiguracija hardvera
Fajl `hardware-configuration.nix` **nije** namenjen deljenju. On je jedinstven za vaš hardver.

1.  Kloniraj ovaj repo:
   ```bash
   git clone [https://github.com/linuxdeda/nixos-flakes.git](https://github.com/linuxdeda/nixos-flakes.git)

2. Generiši svoj hardverski config:  

   nixos-generate-config --show-hardware-config > hardware-configuration.nix
   
3. Pokreni:

   doas nixos-rebuild switch --flake .#nixos
   
