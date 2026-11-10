-- Feed: the mobile shells' latest releases, from their own GitLab instances (Sxmo lives on
-- sourcehut, whose API needs a token: not here yet). Each run replaces the last.
CREATE TABLE IF NOT EXISTS shell_releases(id VARCHAR PRIMARY KEY, name VARCHAR NOT NULL, version VARCHAR NOT NULL,
  released DATE, link VARCHAR NOT NULL, CHECK(starts_with(link, 'https://')));
DELETE FROM shell_releases;
INSERT INTO shell_releases
SELECT 'phosh', 'Phosh', tag_name, CAST(CAST(released_at AS TIMESTAMPTZ) AS DATE),
       'https://gitlab.gnome.org/World/Phosh/phosh/-/releases/' || tag_name
FROM read_json('https://gitlab.gnome.org/api/v4/projects/World%2FPhosh%2Fphosh/releases?per_page=1');
INSERT INTO shell_releases
SELECT 'plasma-mobile', 'Plasma Mobile', name, CAST(CAST("commit".committed_date AS TIMESTAMPTZ) AS DATE),
       'https://invent.kde.org/plasma/plasma-mobile/-/tags/' || name
FROM read_json('https://invent.kde.org/api/v4/projects/plasma%2Fplasma-mobile/repository/tags?order_by=version&sort=desc&per_page=1');
