-- Feed: kernel work on surya's device tree in sm7150-mainline/linux (its default branch), newest
-- first - what changed upstream for this phone. GitHub is the source: the latest 30 replace the last.
CREATE TABLE IF NOT EXISTS kernel_activity(id VARCHAR PRIMARY KEY, name VARCHAR NOT NULL, day DATE NOT NULL,
  author VARCHAR, link VARCHAR NOT NULL, CHECK(starts_with(link, 'https://')));
DELETE FROM kernel_activity;
INSERT INTO kernel_activity
SELECT substr(sha, 1, 12), split_part(commit.message, chr(10), 1), CAST(commit.author.date AS DATE), commit.author.name, html_url
FROM read_json('https://api.github.com/repos/sm7150-mainline/linux/commits?per_page=30&path=arch/arm64/boot/dts/qcom/sm7150-xiaomi-surya.dtsi')
ORDER BY 3 DESC, 1;
