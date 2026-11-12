#!/usr/bin/env sh
# Rebuilds the bundled pack toolchain in tools/ from an sc-gateway checkout:
#   tools/build-toolchain.sh <path to sc-gateway>
# The bundles are plain Node.js files with their npm dependencies inlined,
# so CI runs them without `npm install`. Maintainer only: commit the result
# together with tools/TOOLCHAIN_VERSION.
set -eu
gateway="${1:?usage: tools/build-toolchain.sh <path to sc-gateway>}"
here="$(cd "$(dirname "$0")" && pwd)"
gateway="$(cd "$gateway" && pwd)"
esbuild="$gateway/node_modules/.bin/esbuild"
[ -x "$esbuild" ] || { echo "run npm ci in $gateway first" >&2; exit 1; }

for name in packs-check packs-contribution-check packs-release; do
  "$esbuild" "$gateway/scripts/$name.ts" \
    --bundle --platform=node --target=node20 --format=cjs \
    --legal-comments=eof --log-level=warning \
    --outfile="$here/$name.cjs"
done

# MIT/ISC notices of the inlined npm packages.
{
  echo "Third-party packages inlined in tools/*.cjs"
  for pkg in zod yaml tldts tldts-core; do
    dir="$gateway/node_modules/$pkg"
    version="$(sed -n 's/^  "version": "\([^"]*\)",*$/\1/p' "$dir/package.json")"
    printf '\n==== %s %s ====\n\n' "$pkg" "$version"
    cat "$dir"/LICENSE* 2>/dev/null || cat "$dir"/license*
  done
} > "$here/THIRD_PARTY_LICENSES.txt"

commit="$(git -C "$gateway" rev-parse HEAD)"
dirty=""
git -C "$gateway" diff --quiet HEAD -- src/packs scripts/packs-check.ts scripts/packs-contribution-check.ts scripts/packs-release.ts package-lock.json || dirty=" (with uncommitted pack toolchain changes)"
printf 'sc-gateway %s%s\nbuilt %s\n' "$commit" "$dirty" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$here/TOOLCHAIN_VERSION"
echo "Built tools/*.cjs from sc-gateway $commit$dirty"
