# G&D Live Compat & Server Fix (Fix-Nightfall)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Minecraft Version](https://img.shields.io/badge/Minecraft-1.21.1-brightgreen.svg)]()
[![ModLoader](https://img.shields.io/badge/Loader-NeoForge_21.1+-orange.svg)]()

A lightweight, high-performance, open-source compatibility and server crash fix mod for Minecraft 1.21.1 (NeoForge).

Mod เสริม Open-Source ขนาดกะทัดรัด ประสิทธิภาพสูง สำหรับแก้ไขปัญหา Dedicated Server Crash และ GUI Rendering Crash โดยไม่ดัดแปลงไฟล์ของผู้อื่น (100% CurseForge & Modrinth Compliant)

---

## ⚡ Performance Impact (การกินสเปค)

- **File Size**: ~4 KB (ขนาดเล็กมาก)
- **Memory Overhead**: 0 MB (แทบไม่ใช้ RAM เพิ่มเติม)
- **CPU / FPS Impact**: 0% (ไม่มีผลกระทบต่อ FPS)
- **Server Optimization**: ช่วย **ลดภาระ CPU ฝั่ง Server** เนื่องจากระบบตัดการประมวลผลเอฟเฟกต์ภาพและกล้องที่ไม่จำเป็นบน Dedicated Server ออกไป ทำให้ Server ทำงานเบาลงและเสถียรยิ่งขึ้น

---

## 🛠️ Features & Fixes (ความสามารถของ Mod)

### 1. EpicFight Nightfall Dedicated Server Crash Fix
- **Problem**: In `NightFall` (1.21.1), `EffekUnits.VFXENABLE()` and weapon animations try to access client-only configuration (`EFNClientConfig`) during entity ticking, causing immediate server shutdown whenever a player joins or executes combat animations.
- **Solution**: Uses SpongePowered Mixin (`EffekUnitsMixin`) to safely detect environment via `FMLEnvironment.dist.isClient()`. Dedicated servers safely bypass client visual configs while clients render 100% of particles, VFX, and animations smoothly.

### 2. Epic Fight: Skill Tree & Dodge Parry Reward GUI Crash Fix
- **Problem**: Opening the Skill Tree screen with custom skill addons (such as `dodge_parry_reward`) causes `NullPointerException: Cannot invoke CategorySlotTexture.offsetX()` because custom categories lack a hardcoded slot texture.
- **Solution**: Uses Mixin (`NodeButtonMixin`) to inject a safe fallback to `CategorySlotTextures.PASSIVE` whenever a custom category is encountered, allowing full functionality and rendering without crashes.

---

## 📂 Project Structure (โครงสร้างโปรเจกต์)

```text
Fix-Nightfall/
├── .gitignore                      # Git ignore file
├── LICENSE                         # MIT License
├── README.md                       # Documentation
├── build.bat                       # One-click build script for Windows
├── build.ps1                       # Automated build & deploy script
└── src/
    └── main/
        ├── java/com/gnd/compatfix/
        │   ├── GndCompatFix.java   # Main mod entrypoint
        │   └── mixin/
        │       ├── EffekUnitsMixin.java   # Nightfall server fix
        │       └── NodeButtonMixin.java   # Skill Tree GUI fix
        └── resources/
            ├── gnd_compat_fix.mixins.json # Mixin config
            └── META-INF/
                └── neoforge.mods.toml     # Mod metadata
```

---

## 🔨 How to Build (วิธีคอมไพล์)

### Windows:
Double-click `build.bat` or run in PowerShell:
```powershell
.\build.ps1
```
The compiled jar will be generated in `build/gnd-compat-fix-1.21.1-1.0.0.jar` and automatically deployed to your Server and Client instances.

---

## 📜 License (สัญญาอนุญาต)

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details. You are free to use, modify, distribute, or include this mod in any modpack.
