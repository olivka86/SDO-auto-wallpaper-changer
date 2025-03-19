# Папка для хранения изображения
$WallpaperPath = "$env:USERPROFILE\Pictures\nasa_wallpaper.jpg"

# Скачивание изображения
Invoke-WebRequest -Uri "https://sdo.gsfc.nasa.gov/assets/img/latest/latest_4096_0304.jpg" -OutFile $WallpaperPath

# Функция для установки обоев
function Set-Wallpaper {
    param([string]$Image, [ValidateSet('Fill', 'Fit', 'Stretch', 'Tile', 'Center', 'Span')][string]$Style)
 
    $WallpaperStyle = switch($Style) {
        "Fill"    {"10"}
        "Fit"     {"6"}
        "Stretch" {"2"}
        "Tile"    {"0"}
        "Center"  {"0"}
        "Span"    {"22"}
    }

    # Устанавливаем параметры реестра
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value $WallpaperStyle
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -Value "0" # Отключаем плитку

    # Добавляем тип для работы с Windows API
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public class Wallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@

    # Устанавливаем обои
    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02
    $fWinIni = $UpdateIniFile -bor $SendChangeEvent

    # Применяем обои
    [Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}

# Получаем все мониторы, на которых есть обои
$monitors = Get-WmiObject -Namespace "root\wmi" -Class WmiMonitorBasicDisplayParams

# Применяем обои на каждый монитор
foreach ($monitor in $monitors) {
    Set-Wallpaper -Image $WallpaperPath -Style "Fit"
}

Write-Output "✅ Done. Wallpaper applied to all monitors."
