# AGENTS.md - how to work in this repository

This repo is a small versioned "database" kept as plain files. The data lives as JSON lines, its tables
declared in `tables.toml`; [tad](https://github.com/creation-guidelines/tad-engine), a released Rust tool,
checks it, keeps it canonical and renders it, and CI enforces that it stays so. **Work on the content.**

## Setup (once per session)
```
make setup    # installs tad, the data engine, from its pinned release (its checksum checked)
make verify   # exactly what CI runs
```

## Layout
| Path | What | Who writes it |
|---|---|---|
| `tables.toml` | every table declared as data - fields, types, allowed values, patterns - and the rules across tables | you, by hand (see below) |
| `data/<table>.json` | one JSON object per line (JSONL despite the extension) | `tad` only |
| `about` table | the index page's heading and introduction (`title`, `summary`); one row, and not a page of its own | you, with `tad set` |
| `feeds/*.sql` | scheduled feeds: each fetches public data and reshapes it with SQL into one table (`feeds/x-y.sql` fills `x_y`) | you |
| `docs/*.md` (or `docs/*.rst`) | rendered pages, in the format `DOCS_FORMAT` names (published to GitHub Pages when Markdown) | `make render` only |

## Rules
1. **Never hand-edit `data/*.json` or anything in `docs/`.** Change a row with `tad set`: it checks the whole repository and keeps nothing that breaks a rule. Then `make render`.
2. **Always finish with `make verify`**: tad must write the final bytes (`tad canon`), or CI fails on a non-canonical diff.
3. **Integrity lives in `tables.toml`**: ids unique across tables (`unique_ids`), both ends of a relation existing (`references`), everything cited (`appears_in`). `tad check` runs every rule.
4. **Commits follow Conventional Commits** and are linted on the PR; see [`CONTRIBUTING.md`](CONTRIBUTING.md) for the type/scope convention this repo uses and why it matters (it drives the automated release and changelog).
5. **New or changed factual claims need a source**, if your schema has a sources-like table (columns `title`, `url`); tad renders the citations by detecting that shape.

## Output format
Pages are written as Markdown by default. `DOCS_FORMAT=rst make render` writes reStructuredText instead, and
`DOCS_FORMAT=md,rst` writes both. Set it once for the repository by changing the `?=` default in the `Makefile`
(`export DOCS_FORMAT ?= rst`), and delete the pages of the format you stopped using: CI checks that the pages in
`docs/` are exactly what the data renders to. The data is written once, in Markdown inline syntax (`code`,
`[text](url)`, `**bold**`, `*emphasis*`); tad converts and escapes it for reStructuredText.

## Feeds
`make feeds` runs every `feeds/*.sql` through DuckDB's standalone binary (pinned, its fingerprint checked in
`bin/run-feeds.sh`): SQL is a good language for reshaping fetched JSON. DuckDB writes the rows; tad then
canonicalizes and checks them, so a feed cannot write what `tables.toml` does not allow. The `feeds` workflow
runs them every Monday and commits any change.

## This repository's schema
`devices` (one phone each), `components` (a fixed vocabulary of hardware features: audio-speaker, touchscreen, wifi, ...),
`support_status` (the matrix: one row per device x component, `status` in works/partial/broken/unknown/not-applicable, with
`notes` saying how we know), `device_sources` (citations, the same convention as any `*_sources` join table), plus the
template's own `backlog` and `session_log`.

**`unknown` is not a weaker form of `broken`.** It means nobody has checked. Do not infer a status from a device's reputation,
a similar device's status, or silence in a source - only from something that actually tested or stated it. When in doubt,
`unknown`, with a note saying what would settle it.

## Recipes
Add or change content:
```
tad set components --key id --set "name=Name" --set category=audio
tad set support_status --key xiaomi-surya --key audio-mic --set status=works --set "notes=..." --set updated=$(date +%F)
make render && make verify
```
A new field: declare it in `tables.toml` (a `[[tables.<table>.fields]]` entry with its `name` and `type`, and `required`, `enum` or `pattern` if it has them), then `make canon`: every line gains the field, empty. A required field is then given a value on every row with `tad set` before `make verify` passes.

Rename a field: `mlr -I --ijsonl --ojsonl rename old,new data/<table>.json`, make the same change in `tables.toml`, then `make canon` (forgetting the declaration is caught by `make check`).

## The wider process
This repository holds the *data*: what is known, and the history of deciding it. The engineering *process* - how work is
planned, logged, guarded, and shipped across this org's repositories (this one and the code repos it documents) - follows
[`ideal-project-playbook`](https://github.com/creation-guidelines/ideal-project-playbook)'s
[`kit/AGENT-INSTRUCTIONS.rst`](https://github.com/creation-guidelines/ideal-project-playbook/blob/main/kit/AGENT-INSTRUCTIONS.rst).
In particular: a code repository's own `AGENTS.md` points back here for the facts and the log, rather than keeping a second,
divergent copy; `session_log` here is this org's development log, in the playbook's sense, not a local one per repository.

## Why it is built this way
- The data is plain text in git: one JSON object per line, so a change to one row is a one-line diff, readable without any tool.
- `tables.toml` declares the tables as data (after Frictionless Data's Table Schema): a person reads it, and [tad](https://github.com/creation-guidelines/tad-engine) checks every row and every rule across tables against it.
- The renderer is schema-agnostic: it detects shapes (a relation table, a sources table, a status grid) structurally, not by name, so a new table needs no configuration.
- tad replaced a vendored Python engine (DuckDB) on 2026-11-11, after giving the same verdicts, the same canonical bytes and the same documents on this repository and three others.
