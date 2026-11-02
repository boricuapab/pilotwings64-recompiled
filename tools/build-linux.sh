#!/usr/bin/env bash
set -euo pipefail
repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_dir"
rom_path=${1:?Usage: bash tools/build-linux.sh /path/to/your/rom}
bash tools/generate.sh "$rom_path"
cmake -S . -B build-linux -G Ninja -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="${CC:-clang}" -DCMAKE_CXX_COMPILER="${CXX:-clang++}" \
    -DPW_PREGENERATED_PATCHES=ON -DCMAKE_BUILD_RPATH_USE_ORIGIN=ON
cmake --build build-linux --target Pilotwings64Recompiled -j "${JOBS:-8}"
python3 tools/package-linux.py
