# ❄️ NixOS Plasma - Dotfiles (Flake Edition)

🛡️ This repository contains my personal NixOS configuration powered by KDE Plasma 6 and Nix Flakes for a deterministic and reproducible system, specifically optimized for laptop stability, thermal efficiency, and configured as a "digital fortress" with multiple layers of protection.

## 📂 File Structure
* `flake.nix` — System entry point, defines inputs and package versions.
* `configuration.nix` — System-wide settings (bootloader, services, drivers).
* `home.nix` — Home Manager configuration (user packages, git, dotfiles).
 device.
* `modules/` & `user-configs/` — Modularized configs for cleaner organization.

### ⚠️ Important: Hardware Configuration
The file `hardware-configuration.nix` is **not** meant to be shared across different machines. It is automatically generated during the NixOS installation process based on the specific hardware (CPU, GPU, disk UUIDs, partitions) of the device.

If you are replicating this setup on a new machine, you should:
0. Generate your own hardware config:
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


1. Privileged Access (doas)

    Sudo-less: Standard sudo is disabled in favor of doas, a minimalist and more secure alternative.
    Rules: Only the primary user can escalate privileges. Password persistence is enabled for a seamless terminal experience.

2. Sandbox Isolation (Firejail & Flatseal)

    Automated Sandboxing: Critical applications like Firefox and Telegram are automatically wrapped in Firejail containers. They are isolated from the rest of the system and cannot see sensitive folders like ~/.ssh.
    Permission Management: Includes Flatseal for managing Flatpak permissions via GUI, ensuring third-party apps remain in their designated sandbox.

3. Network & Privacy

    Hardened SSH: Password-based authentication is strictly disabled. Access is only possible via ED25519 cryptographic keys.
    Firewall: A strict firewall is active, allowing only essential ports (SSH, Web, VPN).
    DNS over TLS (DoT): System-wide DNS queries are encrypted using systemd-resolved (Cloudflare/Quad9), preventing ISP tracking and DNS hijacking.

4. Physical Security (USBGuard)

    USB Blocking: To prevent USB Rubber Ducky attacks, all new USB devices are blocked by default.
    Trusted devices must be explicitly whitelisted using the usbguard CLI.

5. System Hygiene
    Automated GC: Weekly Garbage Collection (GC) removes system generations older than 30 days.
    Store Optimization: Automatically hardlinks identical files in the Nix store to save disk space.

🌡️ Thermal Optimization (TLP)

Specifically tuned for Intel 13th Gen (i5-1334U) to prevent overheating and extend battery life:

    On AC (Charger): CPU performance limited to 81%.
    On Battery: CPU performance limited to 60%.
    Turbo Boost: Completely Disabled to prevent temperature spikes and reduce fan noise.
    EPP: Configured to favor efficiency cores (E-cores) over performance cores (P-cores) during light tasks.

⌨️ Custom Aliases (Fish Shell)

To simplify management, the following aliases are included:

  Alias,Command,Description

    sys-up,doas nixos-rebuild switch --flake .#nixos,Apply configuration changes
    sys-clean,doas nix-collect-garbage -d && doas nix-store --optimise,Deep clean and optimize store
    usb-list,doas usbguard list-devices,Show all connected USB devices
    usb-allow,doas usbguard allow-device <ID> -p,Permanently whitelist a USB device
    gens,nixos-rebuild list-generations,List all system versions
    fetch,fastfetch,Display system information

🚀 How to Apply

    Clone this repository to /etc/nixos/.
    Ensure your hardware-configuration.nix is present.
    Apply the configuration:
    
   doas nixos-rebuild switch --flake .#nixos
