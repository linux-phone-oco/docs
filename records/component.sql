-- A part of a phone that can work or not (a component of that id is replaced): what support_status, the tests and the
-- bring-up steps' first lights name. A new part is not known yet on every device until its base claims it.
-- --id        string  a-short-name: gnss, gpu, battery, camera-front ...
-- --name      string  what it is called
-- --category  string  audio, display, input, connectivity, camera, power or other
DELETE FROM components WHERE id = $id;
INSERT INTO components (id, name, category) VALUES ($id, $name, $category);
