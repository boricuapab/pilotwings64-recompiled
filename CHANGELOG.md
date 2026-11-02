# Custom development build

Based on Pilotwings64Recomp revision `8d0d9a4808375c2ff6d0328581fdf43df1691269`.

- Replaced the inherited launcher animation with the supplied splash artwork.
- Added ROM-selection, launch, display-settings, and input-configuration actions.
- Added explicit 60/120 FPS output presets using RT64 interpolation.
- Expanded the CPU visibility frustum to match widescreen rendering.
- Resolved resource paths relative to the executable for shortcut launches.
- Fixed the upstream debug helper's unavailable thread API reference.
- Vendored dependency sources and their licenses because original upstream repositories became unavailable.
- Added portable source-generation, Windows build, packaging, and publication audit tools.
- Excluded ROMs, generated game code, local paths, saves, and build-machine configuration.

Game startup and splash display were confirmed. Full mission completion, controller hardware coverage, and sustained high-frame-rate performance remain unverified.

## Linux packaging

- Added a native Linux x64 release ZIP, portable launch script, runtime requirements, and source build/package commands.
- Preserve both platform checksums when packaging either release.
