# intelligence-packs

**Run an organisation that scammers love to impersonate? Add your abuse address
and your names here, and [phish.fi](https://phish.fi/) will send you the phishing
it catches pretending to be you.**

---

## TL;DR

- Scammers copy your bank, shop or agency, send the fake to thousands of people,
  and you hear about it last.
- People report phishing to phish.fi. When a report imitates *you*, phish.fi
  can send it straight to your abuse inbox, but only if it knows who you are
  and where that inbox is.
- This repo is where you tell it. One YAML file per organisation, one pull
  request, and you're done.
- It's open data (CC0). No account, no contract, no sales call.

## Why should I bother?

Because right now, reports about phishing that imitates you probably go nowhere
near you. The person who got the scam deletes it, or forwards it to some generic
"info@" that nobody reads, and the fake login page stays up for another week.

With an entry in a pack:

- **Reports about your brand land in your inbox,** with the evidence attached:
  the original message, or only structured findings if that's what you prefer.
  You choose in your entry.
- **Your real domains stop looking suspicious.** phish.fi knows they're yours,
  so look-alikes stand out and your real site doesn't get flagged.
- **Scams that use your name get attributed to you.** The names you list
  ("OP", "OP-mobiili", "Elisa Viihde"…) are what phish.fi looks for in sender
  names and subjects.

## What do I actually add?

Three things, in one file at `<country>/organisations/<your-domain>.yaml`:

| What | Example | Why |
| --- | --- | --- |
| **Your domains** | `esimerkkikauppa.example` | So we know what's real |
| **Your names** | `Esimerkkikauppa`, `Esimerkkikauppa Oy` | The names scammers type into their fakes |
| **Your abuse address** | `abuse@esimerkkikauppa.example` | Where the reports go |

Plus the public pages that prove each of them, usually your own website. Copy
[the example](examples/contribution/fi/organisations/esimerkkikauppa.example.yaml),
replace the values, and open a pull request.

**Don't do Git?** Use the [web form](https://phish.fi/docs/packs/contribute). It
checks your entry and gives you the finished file.

Full walkthrough and the rules: [CONTRIBUTING.md](CONTRIBUTING.md).

## "Can't anyone just add a fake address?"

No, and that's on purpose.

- **Every fact needs a public source.** Domains, names and addresses each cite
  a page. Passing CI proves the file is well formed. It doesn't make anything
  trusted.
- **phish.fi verifies everything itself after release.** A report address is
  used only when it appears on the organisation's verified website, on one of
  its own domains, with working mail servers. Until then, nothing is sent to it.
- **Right now a human reviews reports before they go out.** Automation is the
  goal, not the starting point.
- **People who report phishing consent** before their report is shared with
  you.

## What's in here

The top-level folders are packs: one per country, named by its
[ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) code in lower
case, plus `global` for organisations imitated everywhere. Every `.yaml` file
inside a pack is merged, so each organisation gets its own small file.

```text
intelligence-packs/
├── fi/                                  Finland
│   ├── pack.yaml                        pack header (maintainer)
│   ├── organisations/
│   │   ├── <your-domain>.yaml           ← contributions go here: one organisation per file
│   │   └── banking.yaml, telecom.yaml…  older files grouping several organisations
│   ├── destinations.yaml                report addresses for the grouped organisations
│   ├── indicators/                      detection rules (maintainer)
│   ├── identification.yaml, hints.yaml, priorities.yaml   (maintainer)
│   ├── retired.yaml                     removed ids, never reused
│   └── tests/                           test cases for the indicators
├── global/                              organisations imitated in many countries (maintainer)
├── i18n/consent/                        consent wording, one file per language
├── examples/                            copy-paste examples (not loaded)
├── docs/pack-format.md                  every field explained
├── schema/                              JSON Schema for your editor
└── tools/                               the checker CI runs, bundled
```

| You want to… | Do this |
| --- | --- |
| Add your organisation | PR a new `<cc>/organisations/<your-domain>.yaml` |
| Fix your existing entry | PR an edit to it, wherever it is now |
| Add your country details to a global brand | PR `<cc>/organisations/<id>.yaml` with `extends: <id>` |
| Add a whole new country | Open an issue first; the maintainer sets up the pack |
| Suggest detection rules | Open an issue; rules are maintainer-only for now |

Your sector isn't a folder. It's the `category` field (`bank`, `retail`,
`telecom`, …), so the file always lives at the same place.

## The robots that check your PR

Every pull request gets three checks:

- **Pack check:** schema, references, conflicts, privacy, and the release still
  builds.
- **Contribution rules:** one organisation, one country, and it meets the
  [inclusion rules](CONTRIBUTING.md#inclusion-rules).
- **DCO sign-off:** commit with `git commit -s`.

They run from `main`, never from your branch, and they can't see any secrets.
Want to know before you push? Node 20+, nothing to install:

```sh
node tools/packs-check.cjs . --warnings
node tools/packs-contribution-check.cjs --base <clean checkout of main> --head .
```

## Releases

The maintainer builds and signs releases from `main`, and phish.fi imports
them. Each push to `main` also builds an unsigned test release as a workflow
artifact, just to prove the data compiles.

## Licence

Pack data: [CC0 1.0](LICENSE), public domain, use it for anything. The bundled
checker in `tools/`: [MIT](tools/LICENSE).
