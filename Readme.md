# Powershell Sciprt to automatically set wallpaper to latest sun image from SDO satellite

Download a sciprt and create folder Pictures in your home directory (USERPROFILE\Pictures).

Than open Windows Task scheduler and run from admin script automatically every 15 min.
```
powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\great\Scripts\update_wallpaper.ps1"
```
