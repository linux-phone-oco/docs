-- A phone the project tracks (a device of that id is replaced). Its soc joins it to the SoC families view,
-- so write the soc as the other phones of its chip family do: Qualcomm CHIP (Snapdragon NAME).
-- --id        string  vendor-codename
-- --name      string  the phone's marketing name
-- --codename  string  its codename
-- --soc       string  Qualcomm CHIP (Snapdragon NAME)
-- --notes     string? what is known of the phone as a whole, and where it is not measured here
DELETE FROM devices WHERE id = $id;
INSERT INTO devices (id, name, codename, soc, notes) VALUES ($id, $name, $codename, $soc, $notes);
