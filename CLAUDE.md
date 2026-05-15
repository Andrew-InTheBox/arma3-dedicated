# Claude context — Arma 3 / Antistasi Ultimate server

This is a Windows dedicated server repo. Scripts are batch files; config is in `server.cfg` and `.env`. See README.md for user-facing documentation.

## Quick-reference facts

- **Server binary AppID**: 233780 — anonymous SteamCMD login is fine
- **Workshop mod AppID**: 107410 — requires a Steam account that owns Arma 3
- **Server executable**: `arma3server_x64.exe`
- **Game port**: 2402 (DayZ on this host uses 2302; never suggest changing Arma 3 back to 2302)
- **CBA_A3 Workshop ID**: 450814997
- **Antistasi Ultimate Workshop ID**: 3020755032

## How the startup script works

`start_arma3_antistasi.bat` auto-discovers mods by scanning for `@*` and `_@*` folders in the server root. Each mod folder must contain a `meta.cpp` with a `publishedid` field — that's how the script knows which workshop item to sync. Adding a new mod means: create the folder, add `meta.cpp`, done — no script edits needed.

`.env` overrides are loaded at the top of the script. Machine-specific config always goes in `.env`, never hardcoded in the bat file.

## Key decisions — don't re-litigate these

- **Port 2402**: deliberate, to coexist with a DayZ server on 2302–2306 on the same host.
- **Separate `install_server.bat`**: the server binary update (AppID 233780) is a one-time/manual step; the startup script only updates mods, not the binary.
- **`USE_STEAMCMD=0` default**: dev PC already has mods via Steam client; copy from workshop cache is faster and doesn't need credentials. Public server sets `USE_STEAMCMD=1` in `.env`.

## Invariants to preserve

- `.env` must stay git-ignored. Never suggest committing credentials or machine paths.
- Mod folders (`@*/`, `_@*/`) are git-ignored binary content. Never suggest committing them.
- `persistent = 1` in `server.cfg` is non-negotiable for Antistasi — removing it would wipe game saves when the server empties.
- `allowedFilePatching = 1` is required for Antistasi's save system.

## Known gotchas

- `verifySignatures` and `BattlEye` are set to `0`/off for local dev. Remind the user to harden these before going public.
- Arma 3 uses **5 consecutive UDP ports** starting from the game port (2402–2406). All five need to be open on the firewall for a public server.
- Workshop mods for AppID 107410 cannot be downloaded anonymously via SteamCMD — an account owning Arma 3 is required.
- The `class Missions {}` block in `server.cfg` is intentionally commented out until the user has run the server once and confirmed the mission `.pbo` name from `@AntistasiUltimate\mpmissions\`.

## Useful reference URLs

When you need more detail, fetch these:

- Server config reference: https://community.bistudio.com/wiki/server.cfg
- Dedicated server setup: https://community.bistudio.com/wiki/Arma_3:_Dedicated_Server
- Antistasi Ultimate workshop: https://steamcommunity.com/sharedfiles/filedetails/?id=3020755032
