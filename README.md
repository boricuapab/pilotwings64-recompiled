# Pilotwings 64: Recompiled

Custom Windows and Linux builds of [gcsmith/Pilotwings64Recomp](https://github.com/gcsmith/Pilotwings64Recomp), based on [Pilotwings64Decomp](https://github.com/gcsmith/Pilotwings64Decomp) and [N64Recomp](https://github.com/N64Recomp/N64Recomp).

## Play

Download [the Windows ZIP](releases/Pilotwings64Recompiled-Windows.zip), extract the whole archive, and run `Pilotwings64Recompiled.exe`. Select your own US Pilotwings 64 ROM when prompted. **No game ROM is included.**

- Custom splash launcher and native ROM picker.
- Widescreen rendering with an expanded CPU visibility frustum.
- 60 and 120 FPS output presets, plus original, display-matched, and manual rates.
- Controller and keyboard remapping and profiles.

Higher output frame rates use RT64 interpolation without changing simulation speed. This is a development build: game startup has been verified, but full mission coverage, every widescreen transition, and sustained 120 FPS performance have not.

For Linux x64, download [the Linux ZIP](releases/Pilotwings64Recompiled-Linux-x64.zip) and follow [the Linux instructions](LINUX-README.md). It targets Ubuntu 24.04-compatible systems with Vulkan.

## Build from source

See [BUILDING.md](BUILDING.md) for prerequisites and Windows/WSL and native Linux build commands. Generated game code is deliberately excluded and is recreated locally from your ROM. Dependency sources and the frontend modifications are included directly; their revisions are recorded in `DEPENDENCIES.lock.json`.

## Credits and licensing

This is an unofficial custom build, not an official release from Nintendo or the upstream developers. The original runtime, renderer, frontend, and recompilation tools retain their authors' copyrights and licenses. See [LICENSE](LICENSE), the vendored dependencies, and the third-party licenses in the release ZIP.

The original game and its assets are not supplied. The launcher artwork is included in `assets/pilotwings-splash.png`. See [CHANGELOG.md](CHANGELOG.md) for local changes and [releases/README.md](releases/README.md) for package details.
