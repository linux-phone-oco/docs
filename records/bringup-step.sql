-- A step of bringing Linux up on a machine, for every machine it applies to (a step of that id is replaced).
-- Generic: what the step is, when it is done and how that is proven - never one device's state, which its own
-- base claims (its steps table) and docs pulls into step_status. What it needs goes in bringup-edge.
-- --id          string        a-short-name: kernel-reaches-init, shell-on-console ...
-- --title       string        what it is, in a few words
-- --stage       string        its stage: the id of a stage (tad sql "SELECT id FROM bringup_stages ORDER BY ord")
-- --ord         integer       its place in the stage, where the edges leave two steps unordered
-- --applies     string = any  any, or the class it holds for: boot:android, boot:uefi, usb:gadget, soc:qcom ...
-- --done-when   string        what done means, checkably
-- --proof       string        the test that proves it (a tests id, or the check a device's test must make)
-- --proof-kind  string        host-check, phone-suite, build-check, witness or research
-- --helper      string?       the lpoco command that does it; none yet is the gap a helper fills
-- --component   string?       the part of the catalogue whose first light it is
-- --guide       string        how it is done, and the traps met so far with the records that met them
-- --sources     string?       ids of the sources, comma-separated
-- --checked-on  date = today  when its text was last checked
SELECT CASE WHEN $sources IS NOT NULL AND EXISTS (SELECT 1 FROM unnest(string_split($sources, ',')) AS t(x) WHERE trim(t.x) NOT IN (SELECT id FROM sources))
    THEN error('sources names no source of this base: ' || (SELECT string_agg(trim(t.x), ', ') FROM unnest(string_split($sources, ',')) AS t(x) WHERE trim(t.x) NOT IN (SELECT id FROM sources)) || ' (tad r source records one)') END;
SELECT CASE WHEN $stage NOT IN (SELECT id FROM bringup_stages) THEN error('no stage ' || $stage || ' (ikb bringup-stage records one)') END;
DELETE FROM bringup_steps WHERE id = $id;
INSERT INTO bringup_steps (id, title, stage, ord, applies, done_when, proof, proof_kind, helper, component, guide, sources, checked_on)
VALUES ($id, $title, $stage, $ord, $applies, $done_when, $proof, $proof_kind, $helper, $component, $guide, $sources, $checked_on);
