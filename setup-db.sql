-- Delete the tables if they exist.
-- Disable foreign key checks, so the tables can
-- be dropped in arbitrary order.

PRAGMA foreign_keys=OFF;

DROP TABLE IF EXISTS theaters;
DROP TABLE IF EXISTS performances;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS customers;

PRAGMA foreign_keys=ON;

-- Create the tables.

CREATE TABLE theaters (
  theater_name		TEXT,
  capacity		INT,
  PRIMARY KEY  (theater_name)
);


CREATE TABLE movies (
  imdb_key		TEXT,
  movie_name		TEXT,
  production_year	INT,
  running_time		INT,
  PRIMARY KEY (imdb_key)
);


CREATE TABLE performances (
  performance_id   TEXT DEFAULT (lower(hex(randomblob(16)))),
  start_time		TIME,
  start_date		DATE,
  theater_name		TEXT,
  imdb_key		TEXT,
  PRIMARY KEY (performance_id),
  FOREIGN KEY (theater_name) REFERENCES theaters(theater_name),
  FOREIGN KEY (imdb_key) REFERENCES movies(imdb_key)
);



CREATE TABLE customers(
  username		TEXT,
  full_name		TEXT,
  password		TEXT,
  PRIMARY KEY (username)
);

CREATE TABLE tickets (
  t_id			TEXT DEFAULT (lower(hex(randomblob(16)))),
  username		TEXT,
  performance_id        INT,
  PRIMARY KEY (t_id),
  FOREIGN KEY (performance_id) REFERENCES performances(performance_id),
  FOREIGN KEY (username) REFERENCES customers(username)
);







