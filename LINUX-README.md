# Linux x64 development release

Built on Ubuntu 24.04 x86-64. Use Ubuntu 24.04 or a compatible newer Linux distribution with a Vulkan-capable GPU and driver. This package is not an AppImage and uses system desktop libraries.

On Ubuntu 24.04, install runtime dependencies:

```sh
sudo apt-get install libsdl2-2.0-0 libgtk-3-0t64 libfreetype6 libatomic1 libvulkan1
```

Extract the entire ZIP and run `./launch.sh`. If the archive extractor did not preserve executable permissions:

```sh
chmod +x launch.sh Pilotwings64Recompiled
./launch.sh
```

Select your own US Pilotwings 64 ROM in the launcher. No ROM is included. The launcher artwork, settings, widescreen option, FPS presets, and input remapping are shared with the Windows build. Higher output rates use interpolation.

Use a graphical desktop session. For WSL, WSLg and a working Vulkan graphics driver are required; a terminal-only WSL installation cannot display the game. Full gameplay and sustained 120 FPS performance have not been verified for this Linux package.

Known test limitation: the launcher initialized under WSLg, but timed termination crashed during graphics-thread cleanup with the Dozen driver. A software-Vulkan comparison required forced termination. Clean shutdown and gameplay on a native Linux desktop have not been verified; treat this as a development release.
