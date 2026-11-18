-- A subject's prior art: each research about it (one a later research supersedes leaves the answer, as in about)
-- and, for each source it cites, what we take from it. Prior art is kept where it is - sources (one per document,
-- with its takes) and research (per question) - and this reads it by subject; no table of its own.
-- --about  string  the subject (a component, feature, milestone, device or backlog item: tad q about lists them)
SELECT r.id AS research, trim(s.x) AS source, so.title, so.year, so.url, so.takes
FROM research r
CROSS JOIN LATERAL unnest(string_split(r.sources, ',')) AS s(x)
LEFT JOIN sources so ON so.id = trim(s.x)
WHERE r.about = $about AND r.sources IS NOT NULL
  AND r.id NOT IN (SELECT supersedes FROM research WHERE supersedes IS NOT NULL)
ORDER BY r.date DESC NULLS LAST, r.id, source;
