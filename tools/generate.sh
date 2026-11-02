#!/usr/bin/env bash
set -euo pipefail
repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_dir"
rom_path=${1:?Usage: tools/generate.sh /path/to/your/rom}
expected_sha=ec771aedf54ee1b214c25404fb4ec51cfd43191a
actual_sha=$(sha1sum -- "$rom_path" | cut -d' ' -f1)
if [[ "$actual_sha" != "$expected_sha" ]]; then
    echo 'ROM does not match the supported US big-endian (.z64) release.' >&2
    exit 1
fi
for tool in git cmake ninja clang ld.lld make python3; do command -v "$tool" >/dev/null; done
[[ -f lib/rt64/CMakeLists.txt && -f lib/Pilotwings64RecompSyms/pilotwings64.us.syms.toml ]] || {
    echo 'Missing vendored dependency sources. Restore a complete checkout.' >&2; exit 1;
}
# Dependencies and the FPS changes are vendored at the revisions in
# DEPENDENCIES.lock.json. No unavailable/private upstream clone is needed.
recompiler=tools/N64Recomp
tool_build=.tools/build-recompiler
cmake -S "$recompiler" -B "$tool_build" -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build "$tool_build" --target N64RecompCLI RSPRecomp -j "${JOBS:-8}"
# Temporary TOML files stay beside the original configs so their relative
# symbol/output paths still resolve correctly. The ROM itself is never copied.
game_config=$(mktemp "$repo_dir/.rom-config.XXXXXX.toml")
rsp_config=$(mktemp "$repo_dir/.rom-config.XXXXXX.toml")
trap 'rm -f -- "$game_config" "$rsp_config"' EXIT
python3 - "$rom_path" "$game_config" "$rsp_config" <<'PY'
from pathlib import Path
import json, re, sys
rom = json.dumps(str(Path(sys.argv[1]).resolve()))
for source, output in zip(('pilotwings64.us.toml', 'aspMain.us.toml'), sys.argv[2:]):
    text = Path(source).read_text()
    text, count = re.subn(r'^rom_file_path\s*=.*$', lambda _: 'rom_file_path = ' + rom, text, flags=re.M)
    if count != 1: raise SystemExit('Expected exactly one ROM input in ' + source)
    Path(output).write_text(text)
PY
"$tool_build/N64Recomp" "$game_config"
"$tool_build/RSPRecomp" "$rsp_config"
make -C patches CC=clang LD=ld.lld
"$tool_build/N64Recomp" patches.toml
