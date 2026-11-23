# upstream - work headed to other projects, one folder per item

`upstream/LIST/ITEM/`: LIST is where it goes (a mailing list, a project), ITEM its upstream-item id, without a
version (`tad q upstream`). It holds the send notes (`SEND-NOTES.md`: the base sha, the commit that was tested,
evidence, recipients, the command), the cover letter, the prepared unsigned `vN-draft/` (made from the kernel
branch `topic/ITEM` with `git format-patch`) and, once the author has signed and sent it, `vN/` from his signed
branch - never edited by hand (decision 2026-11-23-structure-kernel-topics-and-integration). `ikb upstream-item
--file auto` makes the folder; any other place is refused. Only the author signs and sends.
