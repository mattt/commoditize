#!/bin/bash
set -euo pipefail

fixture=$(mktemp -d)
trap 'rm -rf "$fixture"' EXIT
export fixture
mkdir "$fixture/bin"

cat > "$fixture/bin/mktemp" <<'STUB'
#!/bin/bash
mkdir "$fixture/work" && echo "$fixture/work"
STUB
cat > "$fixture/bin/skopeo" <<'STUB'
#!/bin/bash
printf '%s\0' "$@" > "$fixture/actual"
STUB
for cmd in hdiutil open; do
    printf '#!/bin/bash\nexit 0\n' > "$fixture/bin/$cmd"
done
chmod +x "$fixture/bin/"*
export PATH="$fixture/bin:$PATH"

uri=docker://registry.invalid/example:latest
check_copy() {
    printf '%s\0' copy "$@" "$uri" "dir:$fixture/work/contents" > "$fixture/expected"
    ./commoditize "$uri" "$@"
    cmp "$fixture/expected" "$fixture/actual"
}

check_copy
check_copy --all --authfile 'fixture path/*.json' --src-cert-dir 'certs with spaces'
