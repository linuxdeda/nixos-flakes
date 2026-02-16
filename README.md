# ❄️ NixOS Plasma - Dotfiles (Flake Edition)

This repository contains my personal NixOS configuration powered by **KDE Plasma 6** and **Nix Flakes** for a deterministic and reproducible system, specifically optimized for laptop stability, thermal efficiency, and configured as a **"digital fortress"** with multiple layers of protection.

## 📂 File Structure
* `flake.nix` — System entry point, defines inputs and package versions.
* `configuration.nix` — Main system-wide settings (bootloader, services, drivers).
* `home.nix` — Home Manager configuration (user packages, git, dotfiles).
* `modules/` — Modularized configs for cleaner organization.

### ⚠️ Important: Hardware Configuration
The file `hardware-configuration.nix` is **not** meant to be shared. It is unique to your machine's UUIDs. If replicating:
`nixos-generate-config --show-hardware-config > hardware-configuration.nix`

---

## 🛡️ Security Hardening
This system implements multiple layers of protection:

1. **Privileged Access (`doas`):** Standard `sudo` is disabled for the more minimalist and secure `doas`.
2. **Sandbox Isolation (`Firejail` & `Flatseal`):** Firefox and Telegram are isolated. Flatseal manages Flatpak permissions.
3. **Network & Privacy:** Password SSH is disabled (ED25519 only). DNS over TLS (DoT) via systemd-resolved.
4. **Physical Security (`USBGuard`):** Blocks all unauthorized USB devices by default to prevent Rubber Ducky attacks.
5. **System Hygiene:** Automated weekly Garbage Collection and store optimization.

---

## 🌡️ Thermal Optimization (TLP)
Specifically tuned for Intel 13th Gen (i5-1334U):
* **AC Performance:** Limited to 81%.
* **Battery Performance:** Limited to 60%.
* **Turbo Boost:** Disabled to prevent spikes and fan noise.

---

## ⌨️ Custom Aliases (Fish Shell)

| Alias | Command | Description |
| :--- | :--- | :--- |
| `sys-up` | `doas nixos-rebuild switch --flake .#nixos` | Apply changes |
| `sys-clean` | `doas nix-collect-garbage -d` | Clean old generations |
| `usb-list` | `doas usbguard list-devices` | List USB devices |
| `usb-allow` | `doas usbguard allow-device` | Whitelist USB |
| `gens` | `nixos-rebuild list-generations` | List versions |

---

## 🚀 How to Apply
1. Clone this repository to your config folder.
2. Ensure `hardware-configuration.nix` is present.
3. Run:
   ```bash
   doas nixos-rebuild switch --flake .#nixos
