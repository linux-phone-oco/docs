# AGENTS.md - linux-phone-oco/docs

Linux Phones: what works on phones running mainline Linux, and how close each is to Android - one tad database
holding every record of every linux-phone-oco place (each row names its place in `project`).
Setup once: `make setup`. Editing the data: [`CONTRIBUTING.md`](CONTRIBUTING.md).

| linux-phone's own | Ask |
|---|---|
| what the phone keeper does next, in the author's order | `tad q phone-queue` |
| how the phone stands now | `tad q phone-stands` |
| what each device supports | `tad q coverage` |
| one place's work, decisions, research | `tad q backlog --project lab-tools` (also `decisions`, `research`) |
| the role briefs, the phone keeper, how records go here | [`ideal-agent-linux-phone-oco/`](ideal-agent-linux-phone-oco/README.md) |

Record with `ikb`: `ikb --help`, then `ikb help RECORD`. Records name their place: `ikb decision --project docs ...`.
`unknown` is not a weaker `broken`: it means nobody has checked.

<!-- idealkb:begin - kept by grenudi/ideal-knowledge-base at the release idealkb.toml names: change it there -->
## Finding what is known
Ask a query; never read `data/` or `docs/` to answer - they are the database's files and the pages for people.

| To know | Ask |
|---|---|
| how a subject stands, then all that is known of it | `tad q about --subject S` (`--whole true` for every record in full; `tad q about` lists the subjects, and where a summary is due) |
| the work ahead | `tad q next` (`--about S` for one subject) |
| where something is said | `tad q find --text WORDS` |
| one record whole | `tad q row --id ID` |
| what was recorded lately | `tad q recent` (`--days N`) |
| anything else | `tad statements`: every query and record, with its parameters |

At a task's start ask only about its subject (`about --subject S`, or `next --about S`) and act. Every
answer gives each record by its brief, its one line. Read deeper - `row --id`, `--whole true`, a file past
its first paragraph, another subject, `tad statements` - only when a step needs more. Long answers read best
with `--format csv`.

## Recording
Record with `ikb` (`sh bin/install-ikb.sh` once installs it): `ikb --help` lists the records of this base, one line each; `ikb help RECORD` gives the one you need, its options written from `records/*.sql` (`IKB.md` is the same for people to browse). Then `ikb RECORD --option value`: long text from a file or stdin (`--found @-`), the id made from the brief, canon and render done after - never SQL, never by hand. Each record names what it is about (`--about`) and, for a decision or a research, its brief (the record in one line; the title is the brief of the rest), then land. Where `tad q about` says a summary is due for a subject you recorded into, renew it: `ikb summary --about S --says ...` - how it stands now, naming the records that carry it.
A thing there are many of with one shape is a row; prose read once in order is a file (README, this entry,
a brief), and a file opens with its own brief: its first paragraph says what it holds. Research is both: its finding a row, its own material - notes, excerpts, measurements - a dated
folder the row names (`--material auto` makes `research/ABOUT/DATE/`); redone, a new row `--supersedes` the old.
Work headed to others (a patch, finding, correction or question for a project, list, wiki, standard, person or another base) is an upstream item: `tad q upstream` shows where each stands; record with `ikb upstream-item --from-work ID`.
<!-- idealkb:end -->
