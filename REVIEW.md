# Publication review

Prepared on 2026-11-01. Changes are staged locally; no commit or push was made.

## Start here

- `README.md`: player-facing overview and Windows ZIP link.
- `BUILDING.md`: portable Windows/WSL source-build workflow.
- `releases/Pilotwings64Recompiled-Windows.zip`: rebuilt Windows x64 package, without a ROM.
- `releases/SHA256SUMS.txt`: package checksum.
- `CHANGELOG.md`: custom game and launcher changes.

## Validation completed

- Built N64Recomp from the included source.
- Generated game and audio code directly from an external, hash-validated ROM; the ROM was not copied into this repository.
- Compiled the custom patches and native Windows Release executable using Clang 19.
- Rebuilt the ZIP with compiler source-path mapping.
- Audited the complete publishable tree and decompressed release contents for ROMs and private build-machine paths.
- Verified the release checksum and checked custom source changes for whitespace errors.
- Confirmed no tracked ROM files or remaining Git submodule links.

## Dependency review

The original Pilotwings64Recomp and its N64ModernRuntime fork returned HTTP 404 during preparation. This does not establish whether they were removed, renamed, or made private. Previously obtained dependency snapshots are included directly, with 51 upstream revisions recorded in `DEPENDENCIES.lock.json` and their licenses preserved.

The large dependency addition contains upstream sources and required SDK binaries. The custom frontend FPS modification is included directly and documented by `tools/patches/frontend-fps.patch`. The audit's 39 upstream fixture/SDK exceptions were checked against the pinned upstream Git objects; any content change invalidates an exception. No exception applies to release ZIP contents.

No full gameplay regression or sustained 120 FPS benchmark was performed for this packaging pass. Splash display and game startup were confirmed during the earlier development session.

## Linux release addition

- Added `releases/Pilotwings64Recompiled-Linux-x64.zip` for Ubuntu 24.04-compatible x86-64 systems with Vulkan.
- Built the native Release executable from the included sources and generated game code.
- Checked runtime dependencies; no missing shared libraries or build-directory runtime search paths were found.
- Tested the extracted package with a fresh configuration under WSLg: the launcher initialized its UI and remained running until the 20-second test timeout. Termination then crashed in graphics-thread cleanup; a software-Vulkan comparison required forced termination. Clean shutdown, native Linux gameplay, and performance remain unverified.
- Audited both decompressed release archives for ROMs and private paths; the audit passed.
- Added native Linux build/package scripts and runtime instructions. Both packaging scripts retain checksums for both platforms.
- The Windows archive is unchanged. All changes remain local for review; nothing has been pushed.
