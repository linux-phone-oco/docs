-- A chip, a panel, a storage part, a PMIC block: what is known of the part itself, whatever product it sits in (a chip
-- of that id is replaced). The row keeps only what no open base keeps - where its driver stands across homes, how to
-- tell it is there, its firmware's provenance, its quirks, the boards met carrying it, the bring-up steps and proofs
-- of its procedure - and links up to the homes that keep the rest (mainline, the list, a fork, a status page), never
-- copying them. Its research, decisions and work name it in --about; tad q about --subject ID reads it whole.
-- --id            string        maker-part, lower case: ti-tas2557, samsung-s6e3fa5, qcom-pm8998
-- --part          string        the part number as its maker writes it: TAS2557
-- --maker         string        its maker: Texas Instruments
-- --kind          string        audio-amp, audio-codec, haptics, display-panel, touch, storage, pmic, charger, fuel-gauge, sensor, camera-sensor, wireless, modem, nfc or other
-- --compatible    string?       its devicetree compatible(s), each with where it stands when not mainline: ti,tas2557 (on the list)
-- --identify      string?       how to tell it is there on any board: bus, addresses it can take, id register and value
-- --driver-stage  string        the furthest its driver has reached: mainline, in-review, fork, downstream or none
-- --homes         string        where its knowledge lives upstream, one https link per home: mainline file, list thread, fork commit, status page
-- --firmware      string?       what it needs to run: file name, where it comes from, licence, may it be shipped - never the file
-- --quirks        string?       what a second board must know, each with the record or link that met it
-- --boards        string?       boards known to carry it, any product: board (bus, address; evidence) - a claim until a test reads it back
-- --steps         string?       the bring-up steps its procedure chains: bringup_steps ids, comma-separated
-- --proof         string?       the tests or checks that prove it works on a board
-- --tools         string?       the lpoco commands and library steps that do it; none yet = the gap
-- --datasheet     string?       its datasheet or product page: a source of this base
-- --sources       string?       ids of the sources it rests on, comma-separated
-- --checked-on    date = today  when its facts were last checked
SELECT CASE WHEN $homes NOT LIKE '%https://%' THEN error('homes links up: give at least one https:// link to where its knowledge lives (mainline, the list, a fork, a status page)') END;
SELECT CASE WHEN $driver_stage IN ('mainline', 'in-review') AND $compatible IS NULL
    THEN error('a driver in mainline or on the list has a compatible: give --compatible') END;
SELECT CASE WHEN $datasheet IS NOT NULL AND $datasheet NOT IN (SELECT id FROM sources) THEN error('datasheet names no source of this base: ' || $datasheet || ' (tad r source records one)') END;
SELECT CASE WHEN $sources IS NOT NULL AND EXISTS (SELECT 1 FROM unnest(string_split($sources, ',')) AS t(x) WHERE trim(t.x) NOT IN (SELECT id FROM sources))
    THEN error('sources names no source of this base: ' || (SELECT string_agg(trim(t.x), ', ') FROM unnest(string_split($sources, ',')) AS t(x) WHERE trim(t.x) NOT IN (SELECT id FROM sources)) || ' (tad r source records one)') END;
SELECT CASE WHEN $steps IS NOT NULL AND EXISTS (SELECT 1 FROM unnest(string_split($steps, ',')) AS t(x) WHERE trim(t.x) NOT IN (SELECT id FROM bringup_steps))
    THEN error('steps names no bring-up step: ' || (SELECT string_agg(trim(t.x), ', ') FROM unnest(string_split($steps, ',')) AS t(x) WHERE trim(t.x) NOT IN (SELECT id FROM bringup_steps)) || ' (tad q bringup-chain lists them)') END;
DELETE FROM chips WHERE id = $id;
INSERT INTO chips (id, part, maker, kind, compatible, identify, driver_stage, homes, firmware, quirks, boards, steps, proof, tools, datasheet, sources, checked_on)
VALUES ($id, $part, $maker, $kind, $compatible, $identify, $driver_stage, $homes, $firmware, $quirks, $boards, $steps, $proof, $tools, $datasheet, $sources, $checked_on);
