# Maintaining this repository

A short cheat sheet for the maintainer. Contributors want
[CONTRIBUTING.md](CONTRIBUTING.md) instead.

## The one rule

**Nobody pushes to `main`, including you.** Every change goes through a pull
request (PR). GitHub enforces this: a direct push to `main` is refused. That
keeps a record of every change, and it means the checks run before anything
lands.

## Making a change (copy-paste recipe)

```sh
git switch main
git pull                                  # start from the latest main

git switch -c fi-fix-elisa-domains        # a new branch; name it after the change

# ...edit files...

node tools/packs-check.cjs . --warnings   # must say "0 errors"

git add -A
git commit -m "fi: fix Elisa domains"
git push -u origin fi-fix-elisa-domains

gh pr create --fill                       # opens the PR from your commit message
gh pr checks --watch                      # wait for the green ticks
gh pr merge --squash --delete-branch      # merge and clean up

git switch main
git pull                                  # bring the merge back to your PC
```

Without `gh`, do the PR steps on github.com instead: after the push, Git
prints a link that opens the PR page. Merge with **Squash and merge**.

## Reviewing a contributor's PR

1. **Read the checks first.** Click **Details** on the checks, then the run
   summary. **Contribution rules** lists exactly what changed: domains,
   addresses, names.
2. **Open every source URL** in the file yourself. The domain or the
   address must really be on that page. Don't trust the `supports` text.
3. **Check that the address belongs to the organisation's own domain.**
4. **Merge** with **Squash and merge** when everything is right. Otherwise
   leave a comment saying what to fix. Contributors are volunteers, so be
   kind.

To try a PR on your PC: `gh pr checkout <number>`, then run the check
command above. Run `git switch main` when you're done.

## Good habits

- **One topic per PR.** Small PRs are easy to review and easy to undo.
- **Always `git pull` on `main` before starting a branch.**
- **Never commit secrets or personal data:** no tokens, no people's names,
  no real phishing messages. Email addresses belong only in `destinations`.
- **Write commit messages that say what changed:** `fi: add verkkokauppa.com`,
  `docs: clarify sources`.
- **If Git gets confusing, stop.** Don't delete folders or run commands with
  `--force`. Your work is safe on your branch; ask for help.
- **Undoing a merged change** is just another PR: open the merged PR on
  GitHub and click **Revert**.

## Keeping sc-gateway in sync

The same pack data also lives in `sc-gateway/packs/`, and for now you sync
the two copies by hand.

- **After you merge a PR here,** copy the changed pack files to sc-gateway.
- **After you change packs in sc-gateway,** bring the change here as a PR.

The two copies differ on purpose in a few places: this repo has `docs/`,
`tools/`, `.github/` and the examples, and only sc-gateway has `fi/notes/`.

## Updating the checker

When the pack code in sc-gateway changes, rebuild the bundled checker on a
branch and merge it as a PR:

```sh
sh tools/build-toolchain.sh ../sc-gateway
```

The PR checks keep using the old checker until that PR is merged.

## When checks block you

- **Your own PRs** run **Pack check** only. **Contribution rules** and
  **DCO sign-off** apply to contributors' PRs, and on yours they show as
  skipped, which counts as passed.
- **If a check fails because of a bug in the workflow itself,** you can still
  merge as a repository admin: tick **Merge without waiting for requirements
  to be met (bypass rules)** on the PR page. Use it rarely, and fix the
  workflow next.
