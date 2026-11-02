param([string]$BuildDir = (Join-Path (Split-Path $PSScriptRoot -Parent) 'build-windows'))
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$output = Join-Path $repo ('build-package-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $output -Force | Out-Null
# Explicit allowlist: never copy ROMs, user settings, saves, logs, or debug symbols.
Copy-Item (Join-Path $BuildDir 'Pilotwings64Recompiled.exe') $output
foreach ($dll in @('SDL2.dll','dxil.dll','dxcompiler.dll')) { Copy-Item (Join-Path $BuildDir $dll) $output }
Copy-Item "$repo/assets" $output -Recurse -Force
Copy-Item "$repo/recompcontrollerdb.txt","$repo/LICENSE","$repo/PLAYING.txt" $output
$licenses = New-Item -ItemType Directory -Path "$output/third-party-licenses" -Force
Get-ChildItem "$repo/lib" -File -Recurse | Where-Object { $_.Name -match '^(LICENSE|COPYING)(\.|$)' } | ForEach-Object {
    $name = $_.FullName.Substring(("$repo/lib/").Length) -replace '[\\/]', '_'
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $licenses $name)
}
if ($env:VCToolsRedistDir) {
    Copy-Item (Join-Path $env:VCToolsRedistDir 'x64/Microsoft.VC143.CRT/*.dll') $output
}
New-Item -ItemType Directory -Path "$repo/releases" -Force | Out-Null
$zip = "$repo/releases/Pilotwings64Recompiled-Windows.zip"
Compress-Archive -Path "$output/*" -DestinationPath $zip -Force
Get-ChildItem "$repo/releases/*.zip" | Sort-Object Name | ForEach-Object {
    "$((Get-FileHash $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant())  $($_.Name)"
} | Set-Content "$repo/releases/SHA256SUMS.txt" -Encoding ascii
Write-Host "Package created: $zip"

$dist = Join-Path $repo 'dist/Pilotwings64Recompiled'
New-Item -ItemType Directory -Path $dist -Force | Out-Null
Copy-Item "$output/*" $dist -Recurse -Force
