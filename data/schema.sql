CREATE TABLE about(title VARCHAR NOT NULL, summary VARCHAR NOT NULL);;
CREATE TABLE backlog(id VARCHAR PRIMARY KEY, title VARCHAR NOT NULL, status VARCHAR NOT NULL, note VARCHAR, opened DATE NOT NULL, CHECK(regexp_matches(id, '^[a-z0-9]+(-[a-z0-9]+)*$')), CHECK((status IN ('open', 'in-progress', 'done'))));;
CREATE TABLE components(id VARCHAR PRIMARY KEY, "name" VARCHAR NOT NULL, category VARCHAR NOT NULL, CHECK(regexp_matches(id, '^[a-z0-9]+(-[a-z0-9]+)*$')), CHECK((category IN ('audio', 'display', 'input', 'connectivity', 'camera', 'power', 'other'))));;
CREATE TABLE devices(id VARCHAR PRIMARY KEY, "name" VARCHAR NOT NULL, codename VARCHAR NOT NULL, soc VARCHAR NOT NULL, notes VARCHAR, CHECK(regexp_matches(id, '^[a-z0-9]+(-[a-z0-9]+)*$')));;
CREATE TABLE device_sources(device_id VARCHAR, source_id VARCHAR, PRIMARY KEY(device_id, source_id));;
CREATE TABLE session_log(id VARCHAR PRIMARY KEY, entry_date DATE NOT NULL, title VARCHAR NOT NULL, done VARCHAR NOT NULL, considered VARCHAR, rejected VARCHAR, CHECK(regexp_matches(id, '^[a-z0-9]+(-[a-z0-9]+)*$')));;
CREATE TABLE sources(id VARCHAR PRIMARY KEY, title VARCHAR NOT NULL, url VARCHAR NOT NULL, author VARCHAR, "year" INTEGER, CHECK(regexp_matches(id, '^[a-z0-9]+(-[a-z0-9]+)*$')), CHECK(starts_with(url, 'https://')));;
CREATE TABLE support_status(device_id VARCHAR, component_id VARCHAR, status VARCHAR NOT NULL, notes VARCHAR, updated DATE NOT NULL, PRIMARY KEY(device_id, component_id), CHECK((status IN ('works', 'partial', 'broken', 'unknown', 'not-applicable'))));;

