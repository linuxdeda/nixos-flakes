# ❄️ NixOS Plasma - Dotfiles (Flake Edition)

This repository contains my personal NixOS configuration powered by **KDE Plasma 6**. It is built using **Nix Flakes** for a deterministic and reproducible system, specifically optimized for laptop stability and thermal efficiency.

## 📂 File Structure
* `flake.nix` — System entry point, defines inputs and package versions.
* `configuration.nix` — System-wide settings (bootloader, services, drivers).
* `home.nix` — Home Manager configuration (user packages, git, dotfiles).
 device.
* `modules/` & `user-configs/` — Modularized configs for cleaner organization.

### ⚠️ Important: Hardware Configuration
The file `hardware-configuration.nix` is **not** meant to be shared across different machines. It is automatically generated during the NixOS installation process based on the specific hardware (CPU, GPU, disk UUIDs, partitions) of the device.

If you are replicating this setup on a new machine, you should:
1. Generate your own hardware config:
   ```bash
   nixos-generate-config --show-hardware-config > hardware-configuration.nix
---

## 🌡️ Thermal Optimization (TLP)
To prevent overheating and extend battery life, **TLP** is strictly configured to manage CPU performance:

* **On AC (Charger):** CPU performance limited to **81%**.
* **On Battery:** CPU performance limited to **60%**.
* **Turbo Boost:** Completely **Disabled** to prevent temperature spikes and reduce fan noise.

You can verify the current TLP status with:
```bash
sudo tlp-stat -p
