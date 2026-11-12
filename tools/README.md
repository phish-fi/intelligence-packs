# Toolchain

The checker that validates packs, bundled into plain Node.js files (Node 20 or
newer) with their dependencies inlined, so nothing needs to be installed:

| File | What it does |
| --- | --- |
| `packs-check.cjs <root> [--warnings]` | Schema, references, conflicts and privacy for every pack |
| `packs-contribution-check.cjs --base <dir> --head <dir> [--json]` | The single-organisation contribution rules for a change between two checkouts |
| `packs-release.cjs --root <dir> --out <file> [--commit <sha>] [--key <pem> --key-id <id>]` | Builds a release; signs it when a key is given |

The source lives in the phish.fi gateway. `TOOLCHAIN_VERSION` records the
commit the bundles were built from. Maintainers rebuild them with
`tools/build-toolchain.sh <path to sc-gateway>`.

Pull request checks always run these files from `main`, never from the pull
request, so a change here takes effect only after review and merge.

These files are licensed under the [MIT License](LICENSE); the CC0
dedication in the main [LICENSE](../LICENSE) covers the pack data only. The
inlined npm packages and their licences are listed in
[THIRD_PARTY_LICENSES.txt](THIRD_PARTY_LICENSES.txt).
