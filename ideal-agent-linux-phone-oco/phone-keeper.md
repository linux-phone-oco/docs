# The phone keeper: one owner of surya, taking the next thing the phone needs

The domain part, for linux-phone-oco's phone surya, of ideal-agent's keeper of a shared resource
(grenudi/ideal-agent): read that first - what a keeper is, how it hands over and ends - and this for
what is surya's. ideal-agent's skills `change-a-device` and `bring-up-a-part` are how each change is
made; `prompts/bring-up.md` (moving here, with the other prompts) is the phone's own detail.

## The role

One session at a time keeps the phone. It owns the phone's flow: it takes up the phone's queue, one
change at a time, and nothing else changes the phone. devlab still holds the phone for every single
change (`hold`); the keeper is who decides what the next change is. Research, expert and conveyor
sessions never change the phone: they put what needs it on the queue, each item with the test whose
pass proves it -

    tad r backlog-needs --project PLACE --id ITEM --needs phone --proof TEST

(or a new item: `tad r backlog ... --needs phone --proof TEST`). Reading the phone stays open to all
(`devlab phone sh`, `devlab suite run`, `devlab suite latest`).

The keeper is a role filled by successive sessions, each fresh: a session starts from the record, not
from a long conversation, and ends when its piece has landed or its context has grown large.

## A keeper session

1. Start as every lab session starts (ideal-agent `lab-session-start`), signed
   `export OCOECO_BY=phone-keeper`.
2. Take the lease, with this session's name: `devlab keeper take NAME` (from surya-lab, or with
   `--device`). Refused: another keeper is live - say so and end. Renew it at each landing
   (`devlab keeper renew NAME`); a lease left unrenewed for 90 minutes lapses.
3. Read how the phone stands - `tad q phone-stands` in docs (the last keeper's hand-over) - then the
   queue, `tad q phone-queue` (in progress first, then what nothing outside holds back, then what names
   its proof, then the oldest; also on the face: "The phone's queue"), and `devlab suite latest`.
4. Take the first item that can be done now. Work it to its proof: the test first if it is missing, the
   change through devlab (a test kernel tried once; `kernel try NAME --dtb FILE` for a device tree;
   `kernel keep` once proven), the phone's own health report after each change, the item done in docs
   with what proved it. What needs the author's hands or word (a SIM, a call to someone, a microphone
   placed, a message upstream in his name) is said on the board and the next item taken.
5. End: write how the phone stands - what runs (kernel kept or stock), what is healthy, what was in
   hand and its next step, anything the next keeper must not undo -

       tad r session-log --project surya-lab --id YYYY-MM-DD-HHMM-how-the-phone-stands \
         --title "How the phone stands" --done "..." --considered "next: ..."

   land it, `devlab keeper release NAME`, and end the session.

## The waker

A scheduled task, `linux-phone-keeper-waker` (on the lab, while the Claude app is open), looks every
hour: when the queue has work and `devlab keeper status` says free, it becomes the keeper itself - this
brief, from step 1. Two never overlap: whoever takes the lease first is the keeper, the other ends.

## The first keeper's first job

Tidy the queue: items from 2026-11-10 (first-real-boot, verify-headphone-mic-earpiece and the like) that
are done or overtaken are closed with what settled them; "microphone" (it works on the kept kernel) is
closed with its proof; every item that needs the phone has `--needs phone` and a proof. Then, by the
queue: the six deep-sleep steps, the sensors, off-state charging.
