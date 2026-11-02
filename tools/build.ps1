param(
    [Parameter(Mandatory=$true)][string]$RomPath,
    [string]$Distro = 'Ubuntu',
    [string]$LLVMPath,
    [int]$Jobs = 8,
    [switch]$SkipGeneration
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
function Invoke-Checked([string]$Program, [string[]]$Arguments) {
    & $Program @Arguments
    if ($LASTEXITCODE -ne 0) { throw "$Program failed with exit code $LASTEXITCODE" }
}
$rom = (Resolve-Path -LiteralPath $RomPath).Path
if ((Get-FileHash -LiteralPath $rom -Algorithm SHA1).Hash -ne 'EC771AEDF54EE1B214C25404FB4EC51CFD43191A') {
    throw 'Use the supported US big-endian (.z64) ROM.'
}
Push-Location $repo
try {
    if (!$SkipGeneration) {
        $linuxRepo = (& wsl -d $Distro --exec wslpath -a -u $repo.Replace("\", "/"))
        if ($LASTEXITCODE -ne 0) { throw 'Cannot resolve repository path in WSL.' }
        $linuxRom = (& wsl -d $Distro --exec wslpath -a -u $rom.Replace("\", "/"))
        if ($LASTEXITCODE -ne 0) { throw 'Cannot resolve ROM path in WSL.' }
        Invoke-Checked 'wsl' @('-d',$Distro,'--exec','env',"JOBS=$Jobs",'bash',"$linuxRepo/tools/generate.sh",$linuxRom)
    }
    foreach ($generated in @('RecompiledFuncs/funcs.h','RecompiledPatches/patches.c','patches/patches.bin','rsp/aspMain.cpp')) {
        if (!(Test-Path $generated)) { throw "Missing $generated. Run generation first." }
    }
    $vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio/Installer/vswhere.exe'
    $vs = (& $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath)
    if (!$vs) { throw 'Install Visual Studio 2022 Desktop development with C++.' }
    Import-Module (Join-Path $vs 'Common7/Tools/Microsoft.VisualStudio.DevShell.dll')
    Enter-VsDevShell -VsInstallPath $vs -SkipAutomaticLocation -DevCmdArguments '-arch=x64 -host_arch=x64'
    if ($LLVMPath) { $env:PATH = "$LLVMPath;$env:PATH" }
    $env:PATH = "$(Join-Path $vs 'Common7/IDE/CommonExtensions/Microsoft/CMake/Ninja');$env:PATH"
    $clang = (Get-Command clang-cl -ErrorAction Stop).Source
    $versionText = (& $clang --version) -join " "
    if ($versionText -notmatch 'clang version (\d+)' -or [int]$Matches[1] -lt 19) {
        throw 'Clang 19 or newer is required. Use -LLVMPath to select its bin directory.'
    }
    Invoke-Checked 'cmake' @('--fresh','-S',$repo,'-B',"$repo/build-windows",'-G','Ninja','-DCMAKE_BUILD_TYPE=Release',"-DCMAKE_C_COMPILER=$clang","-DCMAKE_CXX_COMPILER=$clang",'-DPW_PREGENERATED_PATCHES=ON')
    Invoke-Checked 'cmake' @('--build',"$repo/build-windows",'--target','Pilotwings64Recompiled','-j',"$Jobs")
    & "$PSScriptRoot/package.ps1" -BuildDir "$repo/build-windows"
} finally { Pop-Location }
