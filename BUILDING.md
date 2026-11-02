# Build from source (Windows and Linux x64)

## Windows requirements

- Windows 10/11 x64 with a D3D12 or Vulkan-capable GPU.
- Git, CMake 3.24 or newer, and Visual Studio 2022 with **Desktop development with C++**, a Windows SDK, and CMake/Ninja tools.
- LLVM/Clang 19.1.7 on PATH, or pass its `bin` directory with `-LLVMPath`.
- Ubuntu under WSL with the packages below.
- Your own unmodified US big-endian `.z64` ROM, SHA1 `ec771aedf54ee1b214c25404fb4ec51cfd43191a`.

In Ubuntu:

```sh
sudo apt-get update
sudo apt-get install git cmake ninja-build build-essential clang lld python3
```

## Clone and build

```powershell
git clone https://github.com/boricuapab/pilotwings64-recompiled.git
cd pilotwings64-recompiled
./tools/build.ps1 -RomPath ./my-rom.z64
```

The ROM path can point anywhere readable from WSL. Substitute your actual file. ROM extensions and build products are ignored by Git. The repository and ROM paths are resolved at runtime; no particular checkout location or user account is required.

Use `-Distro` if your WSL distribution has a different name. Use `-LLVMPath` to select a portable LLVM installation. PowerShell script execution must be enabled according to your normal local policy.

The build script:

1. Validates and reads the external ROM without copying it into the repository.
2. Builds vendored N64Recomp at revision `ffb39cdad1da5de07eaaa48bd1db4a89a7986771` inside ignored `.tools/`.
3. Generates game C code, audio RSP code, and MIPS patches under WSL.
4. Builds a native Windows Release executable with Clang and the Visual Studio SDK.
5. Packages the EXE, assets, runtime DLLs, instructions, and dependency licenses without a ROM.

Output: `dist/Pilotwings64Recompiled/` and `releases/Pilotwings64Recompiled-Windows.zip`.

After a C++-only edit, `-SkipGeneration` reuses previously generated files. After editing `patches/`, run the full command. Do not edit generated `RecompiledFuncs/`, `RecompiledPatches/`, or `rsp/aspMain.cpp`.

## Source layout

- `src/`: native game host and custom launcher.
- `patches/widescreen.c`: CPU culling-frustum expansion; RT64 handles the GPU projection.
- `lib/RecompFrontend/`: vendored frontend with explicit FPS presets; the original diff is retained in `tools/patches/frontend-fps.patch`.
- `lib/` and `tools/N64Recomp/`: vendored dependency sources and required upstream SDK binaries, with licenses and revisions in `DEPENDENCIES.lock.json`.
- `assets/`: launcher resources, including the custom splash.

Some original upstream repositories are no longer publicly reachable. Their previously obtained open-source snapshots are included directly so a fresh checkout does not depend on those URLs. Only the documented system toolchains and CMake's public SDL2 download are external requirements. Do not run submodule updates: these dependencies are regular tracked directories.

## Validation before publication

Run `python3 tools/audit.py` (from WSL or another Python 3 environment). It checks publishable files and ZIP entries for ROM extensions, ROM headers, ROM hash matches, and private absolute paths. Build products and generated game sources are excluded by `.gitignore`. Release binaries use compiler path mapping so they do not expose the build machine's source paths.

The audit permits 39 unchanged upstream fixture/SDK files containing example or third-party build paths. Their hashes are recorded in `tools/audit-upstream-paths.json` and verified against the pinned upstream Git objects. Changes invalidate those exceptions. Additional private prefixes can be checked using `--forbid`; these are never stored in the repository. Release ZIP contents have no such exceptions.

## Native Linux x64 build

On Ubuntu 24.04:

```sh
sudo apt-get install git cmake ninja-build build-essential clang lld python3 libsdl2-dev libgtk-3-dev libfreetype-dev libvulkan-dev
bash tools/build-linux.sh /path/to/your/rom.z64
```

The script reads the external ROM directly, uses the vendored recompiler, builds native Linux code, and creates `releases/Pilotwings64Recompiled-Linux-x64.zip`. Runtime requirements are in `LINUX-README.md`. Both packaging scripts update checksums for all release ZIPs.
