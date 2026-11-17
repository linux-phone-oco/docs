# Research

The material of research kept as it was written - notes, excerpts, prior-art files, measurements - not
generated, not rendered, and not what an agent reads first. Each folder belongs to one research row in the
database, which holds its finding and names the folder in `material` (idealkb 0.2.0, decision
2026-11-17-research-aside there):

    research/SUBJECT/YYYY-MM-DD/

Ask the row first (`tad q about --subject SUBJECT`, `tad q row --id ID`); open the folder only when the
finding is questioned. Research redone goes in a new dated folder with a new row that supersedes the old;
the old folder stays.

- `open-handset-commons/2026-11-10/` - the Open Handset Commons model (research row
  open-handset-commons-model): nine structural concepts a daily-driver phone needs, the map of Android, iOS
  and the open ecosystem against them, and the prior-art files for Android/AOSP, iOS and GrapheneOS. It is
  the *why* layer of [the grand picture](../docs/picture.md). The method it was made with is domain-free and
  lives in open-commons-observatory/method. Next: the prior-art files become data here (a table per project,
  with sources), so the matrix can cite them row by row.
