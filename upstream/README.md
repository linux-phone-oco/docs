# upstream - work headed to other projects, one folder per item

`upstream/LIST/ITEM/`: LIST is where it goes (a mailing list, a project), ITEM its upstream-item id
(`tad q upstream`). It holds the send notes (`SEND-NOTES.md`: base, evidence, recipients, the command), the cover
letter and, per version sent, `vN/` - the patches made from the kernel branch `topic/ITEM` by `git format-patch`,
never edited by hand (decision 2026-11-23-structure-kernel-topics-and-integration). `ikb upstream-item --file
auto` makes the folder; any other place is refused. Nothing is sent without the author.
