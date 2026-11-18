# The guidebook, as Markdown, from the bring-up rows (bin/render-pages.sh feeds it). Arguments, each a one-element
# array of the rows: stages, steps, edges, sources, chain (tad q bringup-chain: the steps in the order they need each other).
def esc: gsub("(?<c>[\\\\*_\\[\\]`{}])"; "\\" + .c) | gsub("<"; "&lt;");
def link: "[\(.)](#step-\(.))";
def code: "`\(.)`";
($stages[0] | sort_by(.ord)) as $stages
| $steps[0] as $steps
| $edges[0] as $edges
| ($sources[0] | map({key: .id, value: .}) | from_entries) as $src
| ($chain[0] | map({key: .step, value: .n}) | from_entries) as $n
| ($steps | map({key: .id, value: .}) | from_entries) as $by
| def needs($id): [$edges[] | select(.step == $id)] | sort_by(.kind != "hard", .requires);
  def enables($id): [$edges[] | select(.requires == $id) | .step] | sort_by($n[.]);
  def need_line:
    "  - \(.requires | link) - \(.kind)\(if .group then ", one of the alternatives " + (.group | code) else "" end): \(.why | esc)";
  def source_link: if $src[.] then "[\($src[.].title | esc)](\($src[.].url))" else code end;
  def step_block:
    . as $s
    | needs($s.id) as $nd
    | enables($s.id) as $en
    | [
        "<a id=\"step-\($s.id)\"></a>",
        "### \($s.title | esc)",
        "",
        "Step \($n[$s.id]) in the chain, id \($s.id | code), applies to \($s.applies | code), checked on \($s.checked_on)\(if $s.component then ", first light of the part " + ($s.component | code) else "" end).",
        "",
        (if ($s.guide | test("World gap")) then "**World gap** - the world has no open answer to this yet; the guide says what is missing.\n" else empty end),
        "- **Done when:** \($s.done_when | esc)",
        (if ($nd | length) == 0 then "- **Needs:** nothing"
         else "- **Needs:**\n" + ($nd | map(need_line) | join("\n")) end),
        "- **Enables:** \(if ($en | length) == 0 then "nothing" else ($en | map(link) | join(", ")) end)",
        "- **Proof:** \($s.proof | code), \($s.proof_kind)",
        "- **Helper:** \(if $s.helper then $s.helper | code else "no helper yet - a helper to write" end)",
        "- **Guide:** \($s.guide | esc)",
        (if $s.sources then "- **Sources:** \($s.sources | split(",") | map(gsub("^ +| +$"; "") | source_link) | join(", "))" else empty end),
        ""
      ] | join("\n");
  [
    "<!-- Generated from data/ by bin/render-pages.sh. Do not edit by hand. -->",
    "",
    "# Bring-up guidebook",
    "",
    "Every small step that makes Linux run on a phone, in the order a bring-up meets them: \($steps | length) steps in \($stages | length) stages, one chapter each. A step shows what done means, what it needs and what it enables, the proof that tests it, the helper that does it or the gap, and how it is done with the traps met so far. A **World gap** marks a step the world has no open answer to yet. The rows themselves are in the [steps table](bringup_steps.md).",
    "",
    "## The chapters",
    "",
    ($stages | map(. as $g | "\($g.ord). [\($g.title | esc)](#stage-\($g.id)) - \([$steps[] | select(.stage == $g.id)] | length) step\(if ([$steps[] | select(.stage == $g.id)] | length) == 1 then "" else "s" end)") | join("\n")),
    "",
    ($stages[] | . as $g
      | "<a id=\"stage-\($g.id)\"></a>\n## \($g.ord). \($g.title | esc)\n\n\($g.what | esc)\n\n"
        + ([$steps[] | select(.stage == $g.id)] | sort_by($n[.id]) | map(step_block) | join("\n")))
  ] | join("\n")
