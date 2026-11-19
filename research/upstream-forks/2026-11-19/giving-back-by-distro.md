# Giving back, by candidate base distribution (2026-11-19)

This note covers, for each candidate base distro, where our device work would go, who reviews it,
the candidate's AI policy, and its sign-off rules. It was asked for by base-distro-research through
orchestration. A researcher subagent gathered the sources. I checked the SourceHut clause myself on
man.sr.ht/terms.md, 2026-11-19.

## The finding for this lane

SourceHut's terms prohibit "original content written with or which facilitates the use of LLMs
(large language models) or other generative AI technologies". The clause is live on
https://man.sr.ht/terms.md and has been in force since 2026-09-10
(https://sourcehut.org/blog/2026-08-27-tos-changes-and-llms/).

What it means for us:
- sxmo's list (~mil/sxmo-devel@lists.sr.ht) is hosted there, so our agent-written sxmo patches cannot
  be mailed to it. That covers the suspend series: 2bb2500, 1156bb6, 6432ef9.
- The surya device profile was mailed there on 2026-11-17, after the clause took effect, and applied
  in 1fd7822. What to do about it is the author's call.
- sxmo's own pages carry no AI rule; the block comes from its host.

## Candidates

| Candidate | AI policy | Sign-off | Notes |
|---|---|---|---|
| Debian / Mobian (Salsa) | Allows: GR 2026-08 "Responsible Use of Generative AI"; the contributor is responsible; disclosure encouraged | no CLA/DCO | Mobian already merged SM7150 images (mobian-recipes !152, 2025-12-04) |
| Fedora (Mobility SIG, Pocketblue) | Allows (2025-10-22): disclose, Assisted-by recommended | FPCA required | the SIG may be inactive |
| nixpkgs / mobile-nixos | Allows (2026-05-18), Assisted-by required; since 2026-11-15, PR text and commit bodies must not contain LLM output | none | few mobile maintainers |
| Linux kernel | Allows with the human's SoB; Assisted-by in v7.3, dropped in next, disclosure kept | DCO | — |
| Nura (ex-postmarketOS) | Forbids | — | decision 2026-11-19-nura-relation |
| DanctNix | Forbids (2026-07-13) | — | PinePhone only |
| Gentoo | Forbids (2024-04-14) | GLEP 76 SoB | reference |
| SourceHut-hosted (sxmo) | Forbids (ToS, 2026-09-10) | — | see above |
| Alpine aports | Under discussion: council #697, #703 open | no DCO | — |
| openSUSE, Arch / ALARM, Manjaro ARM, UBports, Droidian, mobile-nixos itself | none adopted or found | — | UBports and Droidian are Halium only |

The sources are in the researcher's table, as relayed in the upstreams lane's message to
orchestration.
