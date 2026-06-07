# 💀 Sudden Death - FPS Shooter

A full-featured, competitive FPS shooter game built on **Roblox Studio** with advanced gunplay mechanics, intelligent AI enemies, dynamic progression systems, and multiplayer support.

## 🎮 Features

### Core Gameplay
- **Advanced Gunplay**: Realistic ballistics, recoil, spread, and weapon mechanics
- **Dynamic AI Enemies**: Intelligent pathfinding, tactical combat, and adaptive difficulty
- **Player Progression**: Level system, cosmetics, weapon unlocks, and seasonal passes
- **Multiple Game Modes**: Team Deathmatch, Elimination, Capture the Flag, Campaign
- **Customizable Loadouts**: Weapons, attachments, perks, and abilities

### Technical Features
- **Optimized Networking**: Server-side authority with lag compensation
- **Advanced HUD System**: Minimap, scoreboard, killfeeds, and contextual UI
- **Map System**: Dynamic spawning, objective markers, environmental effects
- **Audio-Visual Effects**: Weapon effects, explosions, environmental feedback
- **Performance Optimized**: Efficient rendering and network synchronization

## 📁 Project Structure

```
src/
├── config/
│   └── GameplayConfig.lua
├── shared/
│   ├── Constants.lua
│   └── Util.lua
├── server/
│   ├── server.lua
│   └── systems/
│       ├── WeaponSystem.lua
│       └── AISystem.lua
├── client/
│   ├── client.lua
│   └── controllers/
│       ├── PlayerController.lua
│       └── CameraController.lua
└── ui/
    ├── HUD.lua
    └── MainMenu.lua
```

## 🚀 Setup Guide

See [SETUP_GUIDE.md](docs/SETUP_GUIDE.md) for detailed instructions.

## 📚 Documentation

- **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** - System design and communication flow
- **[CODE_STANDARDS.md](docs/CODE_STANDARDS.md)** - Luau coding standards
- **[SETUP_GUIDE.md](docs/SETUP_GUIDE.md)** - Implementation guide

## 🎯 Quick Start in Roblox Studio

1. Create folder structure in ServerScriptService
2. Copy Config, Shared, and Systems files
3. Copy Server scripts
4. Copy Client scripts to StarterPlayer
5. Test in Studio

---

**Made with ❤️ - Let's build an amazing FPS! 🔥**
