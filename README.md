# intelligence-packs

Open data that [phish.fi](https://phish.fi/) uses to recognise phishing and to
send each report to the organisation it imitates. A pack says, for one
country:

- which organisations scammers imitate, with their real domains and the names
  people see in messages;
- where each organisation wants phishing reports sent, with the public page
  that says so;
- which wording and links give a phishing message away (indicators).

Every fact cites a public source. Nothing here is trusted just because it was
merged: phish.fi verifies domains and reporting addresses independently before
it uses them (a report address, for example, must appear on the organisation's
verified website), and new detection rules run in shadow mode until they pass
a review gate.

The data is dedicated to the public domain under [CC0 1.0](LICENSE). Anyone may
use it. The bundled checker in `tools/` is under the [MIT License](tools/LICENSE).

**Want to add or fix an organisation?** Read [CONTRIBUTING.md](CONTRIBUTING.md),
or use the [web form](https://phish.fi/docs/packs/contribute), which checks your
entry and produces the file for you.

## Layout

The top-level folders are packs: one per country, named by its
[ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) code in lower
case, plus `global`. Inside a pack, every `.yaml` file is read and merged, so
files are split to keep each change small and each pull request about one
thing.

```text
intelligence-packs/
├── fi/                                  Finland
│   ├── pack.yaml                        name, languages, maintainers, shared sources (maintainer)
│   ├── organisations/
│   │   ├── <primary-domain>.yaml        one organisation per file: entry, report addresses, sources
│   │   └── banking.yaml, telecom.yaml…  earlier files that group several organisations by sector
│   ├── destinations.yaml                report addresses of the grouped organisations
│   ├── indicators/<sector>.yaml         detection rules (maintainer)
│   ├── identification.yaml              shared login systems, e.g. bank credentials (maintainer)
│   ├── hints.yaml, priorities.yaml      analysis hints and priorities (maintainer)
│   ├── retired.yaml                     ids that were removed and are never reused
│   └── tests/                           test cases for the indicators
├── global/                              organisations imitated in many countries (maintainer)
├── i18n/consent/<language>.yaml         consent wording shown before a report is sent
├── schema/pack.v2.schema.json           JSON Schema for editors
├── examples/                            not loaded; examples to copy
│   ├── contribution/fi/organisations/esimerkkikauppa.example.yaml
│   └── no/                              a complete example country pack
├── docs/pack-format.md                  format reference
└── tools/                               the checker, bundled (see tools/README.md)
```

### How it grows

| You want to add | Where it goes | Who |
| --- | --- | --- |
| A company or authority in one country | `<cc>/organisations/<primary-domain>.yaml`, e.g. `fi/organisations/verkkokauppa.com.yaml` | Anyone, by pull request |
| A fix to an organisation already listed | Edit its existing entry in place | Anyone, by pull request |
| One country's details for an organisation defined in `global` | `<cc>/organisations/<id>.yaml` with `extends: <id>` | Anyone, by pull request |
| A new country | `<cc>/pack.yaml` and a consent template for each new language | Maintainer; open an issue first |
| An organisation active in many countries | `global/` | Maintainer |
| Detection rules, hints, shared login systems | `<cc>/indicators/`, `<cc>/hints.yaml`, `<cc>/identification.yaml` | Maintainer |

Sectors are not folders. An organisation's sector is its `category` field
(`bank`, `telecom`, `retail`, …), so one file per organisation works for any
number of companies, and the path of a contribution never depends on how the
pack is grouped. The older sector files in `fi/organisations/` will be split
into per-organisation files over time; both forms load the same way.

## Checks

Every pull request is checked automatically:

- **Pack check**: schema, references, conflicts and privacy for the whole
  repository with the change applied, and the release still builds.
- **Contribution rules**: the change touches one organisation of one country
  pack, and that organisation meets the inclusion rules in
  [CONTRIBUTING.md](CONTRIBUTING.md).
- **DCO sign-off**: every commit carries a `Signed-off-by` line.

The checks run from the main branch, never from the pull request, and have no
access to secrets. Run them locally with Node.js 20 or newer; nothing needs to
be installed:

```sh
node tools/packs-check.cjs . --warnings
node tools/packs-contribution-check.cjs --base <clean checkout of main> --head .
```

## Releases

The maintainer builds and signs releases from `main`, and phish.fi imports
them; its automatic import refuses unsigned releases unless configured
otherwise for development. Each push to `main` also builds an unsigned release as a
workflow artifact, to show that the data compiles.
