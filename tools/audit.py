"""Check publishable files and decompressed ZIPs; never reads Git internals."""
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
import argparse
import hashlib
import json
import re
import subprocess
import zipfile

root = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--forbid', action='append', default=[], help='Additional private path prefix to reject (not saved).')
parser.add_argument('--releases-only', action='store_true')
args = parser.parse_args()
forbidden = [s.encode().lower() for s in args.forbid]
rom_hash = 'ec771aedf54ee1b214c25404fb4ec51cfd43191a'
rom_extensions = {'.z64', '.v64', '.n64', '.rom'}
rom_headers = {bytes.fromhex(s) for s in ('80371240','37804012','40123780')}
private_paths = re.compile(rb'(?i)(?:[a-z]:[\\/](?:users[\\/]|githubprojs[\\/]|n64recomp[^\\/]*[\\/])|/home/[a-z0-9_.-]+/|/mnt/[a-z]/)')
# These fixtures/SDKs were checked against their pinned upstream Git objects.
# Exceptions apply only while their canonical contents remain unchanged.
upstream = json.loads((root/'tools/audit-upstream-paths.json').read_text())

def inspect(name, data):
    errors = []
    if Path(name).suffix.lower() in rom_extensions:
        errors.append(f'ROM extension: {name}')
    if data[:4] in rom_headers or hashlib.sha1(data).hexdigest() == rom_hash:
        errors.append(f'ROM content: {name}')
    variants = (data, data[::2] if b'\x00' in data[:2000] else b'')
    for content in variants:
        if any(token in content.lower() for token in forbidden):
            errors.append(f'Forbidden private path: {name}')
            break
    if any(private_paths.search(content) for content in variants):
        digest = hashlib.sha256(data.replace(b'\r\n', b'\n')).hexdigest()
        if upstream.get(name) != digest:
            errors.append(f'Private absolute path: {name}')
    return errors

def check_file(name):
    path = root/name
    if not path.is_file(): return 0, []
    data = path.read_bytes()
    errors = inspect(name, data)
    count = 1
    if path.suffix.lower() == '.zip':
        with zipfile.ZipFile(path) as archive:
            for item in archive.infolist():
                if item.is_dir(): continue
                if item.filename.startswith(('/', '\\')) or '..' in Path(item.filename).parts:
                    errors.append(f'Unsafe ZIP path: {item.filename}')
                errors += inspect(f'{name}:{item.filename}', archive.read(item))
                count += 1
    return count, errors

if args.releases_only:
    names = [p.relative_to(root).as_posix() for p in (root/'releases').glob('*') if p.is_file()]
else:
    names = subprocess.check_output(['git','ls-files','-z','--cached','--others','--exclude-standard'], cwd=root).decode().split('\0')
names = sorted(set(filter(None, names)))
count, errors = 0, []
with ThreadPoolExecutor(max_workers=8) as workers:
    for checked, found in workers.map(check_file, names):
        count += checked
        errors += found
if errors: raise SystemExit('\n'.join(errors))
print(f'PASS: {count} files and ZIP entries checked; no ROMs or unapproved private paths found.')
