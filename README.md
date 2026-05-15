# Arma 3 Dedicated Server — Antistasi Ultimate

A self-restarting Windows dedicated server for Arma 3 running the [Antistasi Ultimate](https://steamcommunity.com/sharedfiles/filedetails/?id=3020755032) mission framework. Designed to be cloned onto any Windows machine and configured via a local `.env` file.

## Requirements

- Windows 10/11
- [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) installed (default: `C:\steamcmd\`)
- A Steam account that owns Arma 3 (required to download workshop mods)
- Arma 3 mods subscribed in Steam **or** SteamCMD credentials configured (see [Mod updates](#mod-updates))

## Quick start

### 1. Clone and configure

```bat
git clone git@github.com:Andrew-InTheBox/arma3-dedicated.git
cd arma3-dedicated
copy .env.example .env
```

Edit `.env` for your machine — at minimum set `WORKSHOP_PATH` to where Steam stores your Arma 3 workshop mods.

### 2. Install the server binary

```bat
install_server.bat
```

Downloads the Arma 3 dedicated server (SteamCMD AppID `233780`) into this folder. Anonymous login — no credentials needed for this step.

### 3. Create mod stubs

Create a folder for each mod with a `meta.cpp` inside so the startup script knows which workshop item to sync:

```
@CBA_A3\meta.cpp
@AntistasiUltimate\meta.cpp
```

Each `meta.cpp` should contain:

```cpp
// @CBA_A3
name = "CBA_A3";
publishedid = 450814997;
```

```cpp
// @AntistasiUltimate
name = "Antistasi Ultimate";
publishedid = 3020755032;
```

### 4. Edit server.cfg

Set at minimum:

```
hostname = "Your Server Name";
passwordAdmin = "your_admin_password";
```

### 5. Start the server

```bat
start_arma3_antistasi.bat
```

On first run this will sync mod files from your Steam workshop cache, then launch the server. Connect via LAN in Arma 3 and select the Antistasi mission from the in-game browser.

Once you know the mission `.pbo` name (visible in `@AntistasiUltimate\mpmissions\`), uncomment the `class Missions {}` block in `server.cfg` to enable auto-mission-select on restart.

---

## Mod updates

The startup script syncs mods before each server restart. Two modes, set via `.env`:

| Mode | Setting | When to use |
|---|---|---|
| Copy from Steam cache | `USE_STEAMCMD=0` (default) | Dev PC — mods already subscribed and downloaded via the Steam client |
| Download via SteamCMD | `USE_STEAMCMD=1` | Public/headless server without the Steam client |

SteamCMD mode requires a Steam account that owns Arma 3. Set `USERNAME` and `PASSWORD` in `.env`, or pre-authenticate with `C:\steamcmd\steamcmd.exe +login <username>` to store the auth token.

Set `ENABLE_WORKSHOP_UPDATES=0` in `.env` to skip mod syncing entirely (e.g. if you manage mods manually).

---

## Ports

| Port | Protocol | Use |
|---|---|---|
| **2402** | UDP | Game / VON |
| 2403 | UDP | Steam query |
| 2404 | UDP | Steam master |
| 2405 | UDP | VON reserved |
| 2406 | UDP | BattlEye |

Open all five UDP ports on your firewall and router for a public server. Port 2402 was chosen to avoid conflict with a DayZ server on the same host (DayZ default: 2302–2306).

---

## Deploying to a public server

1. `git clone` the repo on the public server
2. Copy `.env.example` to `.env` and set `USE_STEAMCMD=1` plus Steam credentials
3. Run `install_server.bat`
4. Create the mod stub folders (step 3 above)
5. In `server.cfg` set `verifySignatures = 2;` and `BattlEye = 1;`
6. Run `start_arma3_antistasi.bat`

The `.env` file is git-ignored and never leaves the machine it's created on.

---

## Files

| File | Purpose |
|---|---|
| `install_server.bat` | One-time server binary installer |
| `start_arma3_antistasi.bat` | Auto-restart loop with mod sync |
| `server.cfg` | Arma 3 server configuration |
| `.env.example` | Environment variable template |
| `.gitignore` | Excludes binaries, mods, logs, secrets |
| `CLAUDE.md` | Context for Claude Code sessions |
