
param(
    [Parameter(Mandatory = $true)]
    [string]$ShortcutPath
)

# Configuration
$User = "Game"
$StoreBackup = $false

$ErrorActionPreference = "Stop"

try {
    # Resolve input shortcut
    $ShortcutPath = (Resolve-Path -LiteralPath $ShortcutPath).Path

    if ([IO.Path]::GetExtension($ShortcutPath) -ne ".lnk") {
        throw "Input must be a Windows shortcut (.lnk)"
    }

    $Shell = New-Object -ComObject WScript.Shell
    $Original = $Shell.CreateShortcut($ShortcutPath)

    $Target = $Original.TargetPath
    $Arguments = $Original.Arguments
    $WorkingDirectory = $Original.WorkingDirectory

    if (-not (Test-Path -LiteralPath $Target)) {
        throw "Target executable not found: $Target"
    }

    if (-not $WorkingDirectory) {
        $WorkingDirectory = Split-Path -Parent $Target
    }

    # Create BAT beside executable
    $GameDirectory = Split-Path -Parent $Target
    $BatName = "___runner_as"
    $BatPath = Join-Path $GameDirectory "$BatName.bat"

    $Content = @"
@echo off
cd /d "$WorkingDirectory"
runas /user:"$User"  /savecred "$Target" $Arguments
"@

    Set-Content -LiteralPath $BatPath -Value $Content -Encoding ASCII
    #backup old one
    if(StoreBackup){
    $BackupName = [IO.Path]::GetFileNameWithoutExtension($ShortcutPath) + ".bk.lnk"
    Rename-Item -LiteralPath $ShortcutPath -NewName $BackupName
    }

    # Create desktop shortcut
    $ShortcutName = [IO.Path]::GetFileNameWithoutExtension($ShortcutPath)
    $Desktop = [Environment]::GetFolderPath("Desktop")
    $DesktopShortcutPath = Join-Path $Desktop "$ShortcutName.lnk"

    $NewShortcut = $Shell.CreateShortcut($DesktopShortcutPath)
    $NewShortcut.TargetPath = $BatP،ath
    $NewShortcut.WorkingDirectory = $GameDirectory
    $NewShortcut.IconLocation = "$Target,0"
    $NewShortcut.Save()

    Write-Host ""
    Write-Host "Successfully created!" -ForegroundColor Green
    Write-Host "BAT: $BatPath"
    Write-Host "Desktop: $DesktopShortcutPath"
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "LINE: $($_.InvocationInfo.ScriptLineNumber)"
    Write-Host "COMMAND: $($_.InvocationInfo.Line)"
    pause
    exit 1
}
