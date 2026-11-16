# Contributing

Thank you for helping. The most useful contribution is one organisation: its
real domains, the names scammers use for it, and the address where it wants
phishing reports. One pull request adds or fixes one organisation.

## Why contribute

When someone reports a phishing message to [phish.fi](https://phish.fi/), the
report is most useful at the organisation being imitated. A bank, a shop or an
authority can warn its customers, block the fake site and request a takedown. phish.fi can only do that when it knows:

- **who the real organisation is**: its own domains, so a look-alike domain
  stands out and the real one is never flagged;
- **what people call it**: the names in a message's sender or subject that
  claim to be that organisation;
- **where it takes reports**: an abuse or phishing address the organisation
  publishes itself.

If an organisation is missing, reports about scams that imitate it reach no
one there.

Good reasons to contribute:

- **You work for the organisation** and want reports to reach your security
  or abuse team. Make sure the address is published on your website first:
  that page is the evidence.
- **You keep seeing scams that imitate an organisation** that isn't listed.
- **An entry is wrong or out of date**: an address moved, a domain changed
  hands, or a name is missing.

The data is public (CC0), so the same entries help anyone else who fights
phishing.

## Two ways to send a change

### 1. The web form (no Git needed)

[phish.fi/docs/packs/contribute](https://phish.fi/docs/packs/contribute) walks
you through the organisation, its domains and its reporting address. It runs
the same checks as this repository and gives you the finished file. You can
then open a pull request with it (step 3 below), or give the file to someone
who can.

### 2. A pull request

1. **Fork** this repository and create a branch.
2. **Write one file**, `<cc>/organisations/<primary-domain>.yaml`, for
   example `fi/organisations/verkkokauppa.com.yaml`. Start from
   [the example](examples/contribution/fi/organisations/esimerkkikauppa.example.yaml)
   and see [How to write the file](#how-to-write-the-file) below.
   To fix an organisation that is already listed, edit its existing file (or
   its entry in an older file that groups several organisations) instead.
3. **Check it locally** (Node.js 20 or newer, nothing to install):

   ```sh
   node tools/packs-check.cjs . --warnings
   ```

4. **Commit with a sign-off**, which certifies the
   [Developer Certificate of Origin](https://developercertificate.org/):

   ```sh
   git commit -s -m "fi: add verkkokauppa.com"
   ```

5. **Open a pull request** against `main` and fill in the template. The checks
   run automatically; their output is on the pull request's **Checks** tab,
   in the run summary.

The country pack must already exist. To start a pack for a new country, open
an issue first: a new pack needs its languages, consent wording and a
maintainer.

## How to write the file

One file describes one organisation. The **file name is the organisation's
primary domain** (its main website): lower case, without `https://`, path or
trailing slash, for example `verkkokauppa.com.yaml`. You never invent an id.
Ids never change after publication.

Next to each domain and each reporting address you write the **evidence**: the
public page that shows it. Here is a complete file, made up on the reserved
`.example` domain:

```yaml
name: Esimerkkikauppa
category: retail
domains:
  - domain: esimerkkikauppa.example          # the first domain is the primary one
    evidence: https://www.esimerkkikauppa.example/
    checked: 2026-11-12
    says: Esimerkkikauppa's own website
aliases:
  - Esimerkkikauppa Oy
reportTo:
  - email: abuse@esimerkkikauppa.example
    evidence: https://www.esimerkkikauppa.example/turvallisuus/huijaukset
    checked: 2026-11-12
    says: Security page asks customers to report scams to this address
```

The same file with comments is in
[the example](examples/contribution/fi/organisations/esimerkkikauppa.example.yaml).

**Editor help.** Open this folder in VS Code and install the YAML extension it
recommends (`redhat.vscode-yaml`). While you edit a file in
`<cc>/organisations/`, hover over a key to read what it means, and press
Ctrl+Space to see the allowed values with their meanings. Mistakes are
underlined as you type.
Every field and value is also listed in the generated
[organisation file reference](docs/organisation-file.md).

Your file may contain only the keys explained below, plus the optional
organisation keys `threatCategories`, `organisationType`, `sector` and
`additionalSectors`, which are described only in the
[organisation file reference](docs/organisation-file.md). Anything else is
reported as an error that lists the allowed keys. Existing files may also hold
a few keys that the maintainer sets (for example `publicSourceUrl` or
`notes`); when you correct a file, leave those as they are.

### `name` and `category` (required)

`name` is the organisation's usual name, as customers know it.

#### Categories

`category` says what kind of organisation it is. phish.fi groups organisations
by it; it does not change which names or domains match. Pick the closest one:

| Value | Meaning |
| --- | --- |
| `bank` | A bank or other credit institution. |
| `identification_broker` | A service that relays strong electronic identification to other services. |
| `payment_provider` | A payment service, such as a payment app, payment processor or parking payment service. |
| `card_issuer` | A payment card issuer or card network. |
| `government_service` | A government agency or public service. |
| `logistics` | A postal, parcel or delivery company. |
| `telecom` | A mobile, broadband or other telecom operator. |
| `email_provider` | An email or webmail provider. |
| `crypto_service` | A cryptocurrency exchange or wallet service. |
| `marketplace` | An online marketplace where others sell. |
| `retail` | A shop or online store. |
| `other` | Anything else. |

### `domains` (required, at least one)

The domains the organisation really uses. The first one is the primary domain
and must match the file name. Use registrable domains only (`kela.fi`, not
`asiointi.kela.fi`); subdomains are covered automatically. Each entry needs
`domain` and its evidence (see [Evidence](#evidence)). It may also have a
`relationship`:

| Value | Meaning |
| --- | --- |
| `owned` | The organisation owns the domain and uses it itself. |
| `authorized` | Someone else runs the domain for the organisation, with its permission (for example a service provider). |
| `associated` | Linked to the organisation but not its own. phish.fi does not treat it as the organisation's domain, and a reporting address cannot be on it. |

The primary domain must be `owned`.

### `aliases` (optional)

Other names people and scammers use for the organisation: brands, app names,
login service names. The organisation's `name` is added automatically, so do
not repeat it. Phish.fi looks for these names in the sender name and subject
of a reported message. An alias is usually just text:

```yaml
aliases:
  - Esimerkkikauppa Oy
  - value: Esimerkki
    match: token_stem
    weight: low
    kind: app
```

Besides `value`, an alias has three optional keys: `match`, `weight` and `kind`.
Leave them out unless you have a reason.

`match` (default `token_exact`):

| Value | Meaning |
| --- | --- |
| `token_exact` | The words of the name must appear exactly (the default). |
| `token_stem` | The last word of the name is a stem, so inflected forms also match ("Kela" matches "Kelalta"). The last word needs at least 4 characters. |

`weight` (default `low` for names of 4 characters or fewer, otherwise
`medium`). The checker warns if a name of 3 characters or fewer is not `low`:

| Value | Meaning |
| --- | --- |
| `low` | A weak hint: the name alone does not count as a sign that a message claims to be from the organisation. Use it for short or common names. |
| `medium` | A moderate hint: the name alone counts as a sign that a message claims to be from the organisation (the default for names longer than 4 characters). |
| `high` | A strong hint. It is never the default; use it only for a long, unmistakable name. |

`kind` (no default):

| Value | Meaning |
| --- | --- |
| `brand` | A brand or trading name. |
| `auth_product` | The name of an identification or sign-in product. |
| `app` | The name of a mobile or desktop app. |
| `service` | The name of a service the organisation offers. |
| `former_name` | A name the organisation used before. |

### `reportTo` (required for a new organisation)

Where phishing reports for this organisation should go. Each entry is one
mailbox on one of the organisation's own domains, with evidence that the
organisation publishes it for this purpose.

| Key | Required | Default | Meaning |
| --- | --- | --- | --- |
| `email` | yes | | The address. It must be on an `owned` or `authorized` domain of the organisation. |
| `payload` | no | `structured_only` | What phish.fi sends to this address; the three values are explained below. Keep the default unless the organisation's page asks for the original message. |
| `acceptsAutomatedReports` | no | `false` | `true` only if the cited page explicitly welcomes automated or third-party reports. |
| `threatCategories` | no | `[phishing]` | The kinds of scam the organisation wants at this address. List others only if the page says so. |
| `name` | no | `<name> phishing reports` | A label for the address. |

Phish.fi shows the `name` on the consent page where a person agrees to share a
report, so keep it plain.

`payload`:

| Value | Meaning |
| --- | --- |
| `original_required` | Only send a report that includes the original message. |
| `original_preferred` | Include the original message when the reporter agrees; otherwise send the structured details. |
| `structured_only` | Send only the structured details (sender, links, findings), never the original message. |

#### Threat categories

The allowed values are:

| Value | Meaning |
| --- | --- |
| `phishing` | The general category: tricking people into giving away credentials, codes, card details or personal data. |
| `credential_theft` | Stealing login credentials. |
| `credential_theft.online_banking` | Stealing online banking credentials. |
| `credential_theft.email_account` | Stealing email account credentials. |
| `credential_theft.national_eid` | Stealing national electronic identification credentials. |
| `authentication_abuse` | Misusing strong sign-in: getting the victim to hand over a one-time code or approve a sign-in. |
| `authentication_abuse.code_theft` | Getting the victim to hand over a one-time or verification code. |
| `authentication_abuse.approval` | Getting the victim to approve a sign-in or payment in an app. |
| `payment_card_theft` | Stealing payment card details. |
| `personal_data_theft` | Stealing personal data such as identity numbers or addresses. |
| `brand_impersonation` | Pretending to be the organisation, whatever the goal. |
| `payment_fraud` | Tricking people into paying money. |
| `payment_fraud.invoice` | Fake or altered invoices. |
| `payment_fraud.advance_fee` | Asking for a small payment up front to release something larger. |
| `malware_delivery` | Getting people to install malware or open a malicious file. |

### Evidence

Every `domains` and `reportTo` entry carries its own proof:

| Key | Required | Meaning |
| --- | --- | --- |
| `evidence` | yes | The full link to the public page. Open it without logging in. |
| `checked` | yes | The day you opened that page, as `YYYY-MM-DD`. |
| `says` | yes | One line saying what the page shows, so the reviewer knows what to look for. Do not put email addresses here. |
| `evidenceKind` | no | What kind of page it is, from the table below. Default `official_site`. |

`evidenceKind`:

| Value | Meaning |
| --- | --- |
| `official_site` | A page on the organisation's own website (the default). |
| `official_register` | An entry in an official register, such as a company register. For domains only; a reporting address cannot cite it. |
| `organisation_statement` | A public statement the organisation publishes or endorses outside its own website. |

If two entries use the same page, write `checked` and `says` once and give the
second only `evidence: <same link>`. If the repeated entry gives a different
`checked` or `says`, the check reports an error naming both lines.

Domain evidence and address evidence are separate pages, see the rules below.

## Inclusion rules

The **Contribution rules** check enforces these:

- **The primary domain is the first domain and the file name**, and is listed
  as an `owned` domain. A new organisation's file name must be that domain.
- **Every further domain cites its own authoritative source**: the
  organisation's site, an official register, or a statement by the
  organisation. Redirects, shared branding and search results are not
  evidence. Use registrable domains only (`kela.fi`, not `asiointi.kela.fi`);
  subdomains are covered automatically.
- **At least one reporting address that the organisation documents on a page
  it publishes or endorses**, cited as that page's `evidence` (with
  `evidenceKind` `official_site` or `organisation_statement`). A reporting portal on another domain
  that the organisation's site links to is accepted with a review warning.
  Guessed addresses, search snippets and third-party directories don't count.
- **Role addresses** (`abuse@`, `phishing@`, `security@`) are fine. A general
  mailbox (`info@`, `contact@`, `asiakaspalvelu@`, …) is accepted only when
  the cited page asks for phishing or abuse reports there, and your `says`
  text says so.
- **Domain evidence and address evidence are separate.** A domain never cites
  the page given for a reporting address.
- **No personal data.** Email addresses appear only in `reportTo`; no
  names of people, no phone numbers, no message samples.
- **Only the maintainer changes** `pack.yaml`, the `global` pack, indicators
  and other detection rules, and anything outside the country packs. A pull
  request that touches them fails the check; open an issue to suggest such a
  change.

## What happens after you open a pull request

1. **Automatic checks**: the pack check, the contribution rules and the
   sign-off. They run from `main`, never from your branch. Fix what they
   report and push again.
2. **Review**: the maintainer opens your sources and compares them with the
   entry.
3. **Merge and release**: merged changes go into the next signed release.
4. **Independent verification**: passing the checks grants no trust. phish.fi
   treats new domains as claims and new addresses as unverified until it
   confirms them itself. For example, a reporting address is used only when it
   appears on the organisation's verified website, on one of its own domains,
   and has working mail servers. Until then, nothing is sent to it.

## Reporting a problem without a pull request

[Open an issue](../../issues/new/choose) using the **Wrong or outdated
information** form. Include a page from the organisation that shows the
correct information. Don't include personal data or the content of phishing
messages.

## Licence

By contributing, you agree that your contribution is dedicated to the public
domain under [CC0 1.0](LICENSE), and you certify with your sign-off that you
have the right to submit it.
