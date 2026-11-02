"""Create a Linux x64 ZIP from an explicit allowlist; never includes a ROM."""
from pathlib import Path
import hashlib
import shutil
import subprocess
import tempfile
import zipfile

root = Path(__file__).resolve().parents[1]
stage = Path(tempfile.mkdtemp(prefix='build-package-linux-', dir=root))
binary = stage/'Pilotwings64Recompiled'
shutil.copy2(root/'build-linux/Pilotwings64Recompiled', binary)
subprocess.run(['strip', '--strip-unneeded', str(binary)], check=True)
binary.chmod(0o755)
shutil.copytree(root/'assets', stage/'assets')
for name in ('LICENSE', 'PLAYING.txt', 'LINUX-README.md', 'recompcontrollerdb.txt'):
    shutil.copy2(root/name, stage/name)
licenses = stage/'third-party-licenses'
licenses.mkdir()
for source in (root/'lib').rglob('*'):
    if source.is_file() and (source.name.upper().startswith('LICENSE') or source.name.upper().startswith('COPYING')):
        shutil.copy2(source, licenses/'_'.join(source.relative_to(root/'lib').parts))
launch = stage/'launch.sh'
launch.write_text('''#!/bin/sh
set -eu
cd -- "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
exec ./Pilotwings64Recompiled "$@"
''')
launch.chmod(0o755)
releases = root/'releases'
releases.mkdir(exist_ok=True)
output = releases/'Pilotwings64Recompiled-Linux-x64.zip'
with zipfile.ZipFile(output, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
    for source in sorted(stage.rglob('*')):
        if source.is_file():
            name = source.relative_to(stage).as_posix()
            info = zipfile.ZipInfo.from_file(source, name)
            info.create_system = 3
            info.external_attr = (0o100755 if name in ('launch.sh', 'Pilotwings64Recompiled') else 0o100644) << 16
            info.compress_type = zipfile.ZIP_DEFLATED
            archive.writestr(info, source.read_bytes())
(releases/'SHA256SUMS.txt').write_text(''.join(
    hashlib.sha256(p.read_bytes()).hexdigest()+'  '+p.name+'\n'
    for p in sorted(releases.glob('*.zip'))
))
print('Packaged '+output.name)
