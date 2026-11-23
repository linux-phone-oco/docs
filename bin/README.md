# bin - the base's scripts: installs, checks, feeds and page renders

`install-*.sh` (run by `make setup`), `check-*.sh` and `test-*.sh` (run by `make verify` and CI), `run-feeds.sh`
(the feeds that fill tables from other places), and the `.jq` and render scripts that make the face and the
guidebook. A tool with a program of its own belongs in lab-tools.
