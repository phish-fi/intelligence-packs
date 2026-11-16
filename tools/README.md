# Toolchain

The checker that validates packs, bundled into plain Node.js files (Node 20 or
newer) with their dependencies inlined, so nothing needs to be installed:

Run them from the repository root:

| Command | What it does |
| --- | --- |
| `node tools/packs-check.cjs . --warnings` | Schema, references, conflicts and privacy for every pack |
| `node tools/packs-contribution-check.cjs --base <dir> --head <dir>` | The single-organisation contribution rules for a change between two checkouts (`--base` a clean checkout of `main`, `--head` your branch, for example `.`; add `--json` for machine-readable output) |
| `node tools/packs-release.cjs --root . --out <file>` | Builds a release into `<file>` (optional: `--commit <sha>`, and `--key <pem> --key-id <id>` to sign) |

The source lives in the phish.fi gateway. `TOOLCHAIN_VERSION` records the
commit the bundles were built from. Maintainers rebuild them with
`tools/build-toolchain.sh <path to sc-gateway>`.

Pull request checks always run these files from `main`, never from the pull
request, so a change here takes effect only after review and merge.

These files are licensed under the [MIT License](LICENSE); the CC0
dedication in the main [LICENSE](../LICENSE) covers the pack data only. The
inlined npm packages and their licences are listed in
[THIRD_PARTY_LICENSES.txt](THIRD_PARTY_LICENSES.txt).
