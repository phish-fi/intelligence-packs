# Pack format reference (`phish.fi-pack/2`)

The reference for writing and reviewing pack files. For how to send a change,
see [CONTRIBUTING.md](../CONTRIBUTING.md); for the repository layout, see the
[README](../README.md). The [JSON Schema](../schema/pack.v2.schema.json) gives
editors completion and basic validation for pack files (add
`# yaml-language-server: $schema=../../schema/pack.v2.schema.json` at the top
of a file, adjusting the path); the full rules are in the checker
(`node tools/packs-check.cjs . --warnings`).

## Layout of a pack

`pack.yaml` holds `format`, `country`, `name`, `languages`, `maintainers` and
`sources`. Every other `.yaml` file may hold any of `sources`,
`organisations`, `identificationSystems`, `indicators`, `hints`,
`priorities`, `destinations`, `destinationGroups`, `cases` and `retired`;
files are merged, so split them however keeps pull requests small. Unknown
keys are errors.

- Ids of indicators, hints, priorities, identification systems, groups and
  cases start with `<pack id>.`. Organisation ids are global and
  region-neutral (`nordea`, never `fi.nordea`). Ids are permanent: list a
  removed id in `retired` so it is never reused.
- Every fact cites a source. `maintainer_attestation` is accepted but never
  anchors a domain, never makes a communication policy decisive and never
  verifies a destination; those need a public source
  (`official_site`, `official_register`, `organisation_statement`).
- `extends: <organisation id>` adds this country's profile (domains,
  aliases, policy) to an organisation defined elsewhere, usually `global`.

## What the platform trusts

| Claim | Trusted when | Until then |
| --- | --- | --- |
| A domain is the organisation's own | Wikidata lists it as the official website of an item with the organisation's name, an official register lists it, or an anchored sibling domain's page links to it; and it is older than 180 days | Neutral: not ownership evidence, not a lookalike of that organisation |
| A report address | Published on the organisation's anchored site, on an anchored domain, with MX records | Exists, never routed |
| A shared-intake group | A public source on a member organisation's anchored site | Members are routed independently |
| An indicator or hint | Its promotion gate passed (admin, with a gate record) | Shadow: recorded, never a reason |

## Organisations and aliases

- Domains: registrable domains only (`kela.fi`, not `asiointi.kela.fi`);
  subdomains match automatically. A domain may belong to one organisation
  only.
- Aliases decide attribution. A `medium` or `high` alias in the display name
  or subject is a sender claim; anywhere else only a mention. `low` aliases
  never claim. Short or common words (≤ 4 characters, "Tori") must be `low`;
  that is the default for them.
- `match: token_exact` (default) matches every word exactly;
  `match: token_stem` treats the last word as a stem ("Kela" also matches
  "Kelan"); the stemmed word needs at least 4 characters. Stems do not cover
  consonant gradation: add the other form as another alias.
- Hyphenated compounds: the tokenizer emits "fi-tunnistus" before its parts,
  so "Suomi.fi" does not match "Suomi.fi-tunnistuksella". Add the compound as
  its own alias with `token_stem`.
- `communicationPolicy.neverContains` lists the links an organisation never
  emails (`link_login`, `link_identify`, `link_payment`,
  `link_credential_update`). A message claiming to be from it with such a
  link is a policy violation.

## Indicators

Every indicator states `expectedMatching` and `falsePositiveRisks` in real
sentences and should carry `tests.match` / `tests.noMatch` examples.

- `phrase` / `sender_claim` / `link_purpose`: ordered token patterns within a
  word window. A pattern is `word`, `stem~` (≥ 4 fixed characters),
  `~inner~` (≥ 5) or `a|b` (up to 4 alternatives), optionally
  `{ pattern: …, folded: true }` for ä/ö-insensitive matching. No regular
  expressions. `link_purpose` adds `purpose` and is matched against a link's
  anchor text, the sentence before it and its URL path words.
- `url_pattern`: a bounded glob (`*`, `?`) on host plus path, lowercase host
  and path characters only, for kit paths. Short review period (3 months).
- `lookalike_seed`: a host imitating the organisation. Both sides are folded
  (case, ä → a, `1`/`I` → `l`, `0` → `o`, `rn` → `m`, Cyrillic and Greek
  look-alikes). Tokens of 3–5 characters match only a whole label or hyphen
  part; from 6 characters also inside a label or 1 edit away; from 9
  characters 2 edits away. List the organisation's other real domains, or
  they become false lookalikes.

## Identification systems

When one set of credentials logs people in across many services, declare it
once (`fi.bank_eid`): `credentialIssuers` (category `bank` for
`bank_credentials`), `brokers` (category `identification_broker`),
`relyingParties`, and `flowMarkers` (indicator ids that recognise the flow).
The engine reports a flow when a flow marker fires together with a relying
party, broker, claimed issuer, a page naming at least 3 issuers, or another
impersonated sender with a credential-specific marker.

## Destinations

`kind: organisation` reports impersonation of `organisation` to its own
mailbox; `kind: national` is a CERT or authority with `scope` conditions,
used by default only when no organisation mailbox takes the report. The
address must be on an owned domain of the organisation and published on its
site. `payload` says whether the original message is required, preferred or
never sent; tenants consent per destination with the wording generated from
`i18n/consent/<lang>.yaml`. A pack language without a consent template fails
the checks.
