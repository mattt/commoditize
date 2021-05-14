#!/bin/bash

set -r

set -o errexit
set -o pipefail
set -o nounset

required_commands=(
    hdiutil
    skopeo
    open
)

for cmd in "${required_commands[@]}"; do
    if ! [ -x "$(command -v "$cmd")" ]; then
        echo "error: $cmd command not available." >&2
        exit 1
    fi
done

if [[ $# -eq 0 ]]; then
    echo 'usage: commoditize docker-image-url [skopeo-copy options]' >&2
    exit 0
fi

function volname_from_uri {
    # Adapted from https://tools.ietf.org/html/rfc3986#appendix-B
    readonly URI_REGEX='^(([^:/?#]+):)?(//((([^:/?#]+)@)?([^:/?#]+)(:([0-9]+))?))?(/([^?#]*))(\?([^#]*))?(#(.*))?'
    #                    ↑↑            ↑  ↑↑↑            ↑         ↑ ↑            ↑ ↑        ↑  ↑        ↑ ↑
    #                    |2 scheme     |  ||6 userinfo   7 host    | 9 port       | 11 rpath |  13 query | 15 fragment
    #                    1 scheme:     |  |5 userinfo@             8 :…           10 path    12 ?…       14 #…
    #                                  |  4 authority
    #                                  3 //…

    [[ "$1" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[7]}${BASH_REMATCH[10]}" | tr ':' '_'
}

uri="$1"
tmpdir=$(mktemp -d)
checksum=$(echo "$uri" | shasum -a 256 | cut -d' ' -f 1)
volname=$(volname_from_uri "$uri")

function cleanup {
    rm -rf "$tmpdir"
}
trap cleanup EXIT

skopeo copy "$uri" dir:"$tmpdir/contents"
hdiutil create -srcfolder "$tmpdir/contents" "$tmpdir/$checksum.dmg" -volname "$volname"
hdiutil attach "$tmpdir/$checksum.dmg"
open -a "Finder" "/Volumes/$(echo "$volname" | tr '/' ':')"
