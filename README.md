# ❄️ NixOS Plasma - Dotfiles (Flake Edition)

Ovaj repozitorijum sadrži moju ličnu NixOS konfiguraciju baziranu na **KDE Plasma 6** okruženju. Sistem je deterministički konfigurisan pomoću **Flakes-a** i optimizovan za rad na laptopu, sa fokusom na maksimalnu kontrolu temperature i stabilnost.

## 📂 Struktura fajlova
* `flake.nix` — Ulazna tačka sistema, definiše izvore (inputs) i verzije paketa.
* `configuration.nix` — Sistemska podešavanja (bootloader, servisi, drajveri).
* `home.nix` — Home Manager (podešavanja korisničkog okruženja, Git, aplikacije).
* `hardware-configuration.nix` — Hardverski profil specifičan za ovaj laptop.
* `modules/` & `user-configs/` — Modularni delovi za lakše održavanje sistema.

---

## 🌡️ Termalna Optimizacija (TLP)
Za biznis laptopove, TLP je konfigurisan da strogo kontroliše rad procesora:

* **Na punjaču (AC):** CPU iskoristivost ograničena na **81%**.
* **Na bateriji (BAT):** CPU iskoristivost ograničena na **60%**.
* **Turbo Boost:** Potpuno **isključen** kako bi se izbegli termalni skokovi i buka ventilatora.

Status optimizacije možeš proveriti komandom:
```bash
sudo tlp-stat -p
