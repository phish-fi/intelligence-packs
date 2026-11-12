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
   [the example](examples/contribution/fi/organisations/esimerkkikauppa.example.yaml).
   To fix an organisation that is already listed, edit its existing entry
   wherever it is instead.
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

## What a contribution file contains

Exactly three sections, nothing else:

| Section | Contents |
| --- | --- |
| `organisations` | Exactly one entry: id, name, category, domains, aliases, threat categories |
| `destinations` | That organisation's reporting addresses |
| `sources` | The public pages the entries above cite |

Categories are `bank`, `identification_broker`, `payment_provider`,
`card_issuer`, `government_service`, `logistics`, `telecom`, `email_provider`,
`crypto_service`, `marketplace`, `retail` and `other`. Every field is
described in the [format reference](docs/pack-format.md).

## Inclusion rules

The **Contribution rules** check enforces these:

- **The id is the organisation's primary domain**: lower case, without scheme,
  path or trailing slash (`verkkokauppa.com`), and listed as an `owned` domain.
  Ids never change after publication.
- **Every further domain cites its own authoritative source**: the
  organisation's site, an official register, or a statement by the
  organisation. Redirects, shared branding and search results are not
  evidence. Use registrable domains only (`kela.fi`, not `asiointi.kela.fi`);
  subdomains are covered automatically.
- **At least one reporting address that the organisation documents on a page
  it publishes or endorses**, cited as that page (`official_site` or
  `organisation_statement`, with its URL). A reporting portal on another domain
  that the organisation's site links to is accepted with a review warning.
  Guessed addresses, search snippets and third-party directories don't count.
- **Role addresses** (`abuse@`, `phishing@`, `security@`) are fine. A general
  mailbox (`info@`, `contact@`, `asiakaspalvelu@`, …) is accepted only when
  the cited page asks for phishing or abuse reports there, and the source's
  `supports` text says so.
- **Domain evidence and address evidence are separate.** A domain never cites
  the page given for a reporting address.
- **No personal data.** Email addresses appear only in `destinations`; no
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
