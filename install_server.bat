@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
if exist "%SCRIPT_DIR%.env" (
  for /f "usebackq tokens=1,* delims==" %%A in (`findstr /R /C:"^[A-Z_][A-Z0-9_]*=" "%SCRIPT_DIR%.env"`) do (
    set "%%A=%%B"
  )
)

:: ============================================
:: Arma 3 Dedicated Server - One-Time Installer
:: Run this once (or any time you need to
:: update the server binary itself).
:: Mod updates are handled by start_arma3_antistasi.bat
:: ============================================

set "STEAMCMD=C:\steamcmd\steamcmd.exe"
set "INSTALL_DIR=%SCRIPT_DIR%"
set "SERVER_APPID=233780"
set "STEAM_LOGIN=anonymous"
set "STEAM_PASS="
if defined USERNAME set "STEAM_LOGIN=%USERNAME%"
if defined PASSWORD set "STEAM_PASS=%PASSWORD%"

:: Override from .env
if defined STEAMCMD_OVERRIDE set "STEAMCMD=%STEAMCMD_OVERRIDE%"

if not exist "%STEAMCMD%" (
  echo ERROR: SteamCMD not found at "%STEAMCMD%"
  echo Download from https://developer.valvesoftware.com/wiki/SteamCMD
  pause
  exit /b 1
)

:: Build login args — use saved token if config.vdf exists, else use password
for %%I in ("%STEAMCMD%") do set "STEAMCMD_DIR=%%~dpI"
set "LOGIN_ARGS=+login %STEAM_LOGIN%"
if /i not "%STEAM_LOGIN%"=="anonymous" (
  if not exist "%STEAMCMD_DIR%config\config.vdf" (
    if not "%STEAM_PASS%"=="" set "LOGIN_ARGS=+login %STEAM_LOGIN% %STEAM_PASS%"
  )
)

echo ============================================
echo  Installing/Updating Arma 3 Dedicated Server
echo  AppID: %SERVER_APPID%
echo  Install dir: %INSTALL_DIR%
echo  Steam login: %STEAM_LOGIN%
echo ============================================
echo.

:: Remove trailing backslash from INSTALL_DIR for SteamCMD
set "INSTALL_DIR_CLEAN=%INSTALL_DIR:~0,-1%"

"%STEAMCMD%" ^
  +force_install_dir "%INSTALL_DIR_CLEAN%" ^
  %LOGIN_ARGS% ^
  +app_update %SERVER_APPID% validate ^
  +quit

if errorlevel 1 (
  echo.
  echo ERROR: SteamCMD returned an error. Check output above.
  pause
  exit /b 1
)

echo.
echo ============================================
echo  Server binary install complete.
echo.
echo  Next steps:
echo    1. Edit server.cfg with your server name and admin password
echo    2. Copy .env.example to .env and configure for this machine
echo    3. Subscribe to mods in Steam (or set USE_STEAMCMD=1 in .env for
echo       servers without the Steam client) then run start_arma3_antistasi.bat
echo.
echo  Required Workshop mods:
echo    @CBA_A3          ID: 450814997
echo    @AntistasiUltimate  ID: 3020755032
echo ============================================
pause
