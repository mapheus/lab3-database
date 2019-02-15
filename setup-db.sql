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
  theater		TEXT,
  capacity		INT,
  PRIMARY KEY  (theater)
);


CREATE TABLE movies (
  imdbKey		TEXT,
  title		TEXT,
  year	INT,
  running_time		INT,
  PRIMARY KEY (title, year)
);


CREATE TABLE performances (
  performanceId   TEXT DEFAULT (lower(hex(randomblob(16)))),
  time		TIME,
  date		DATE,
  remaining   INT,
  theater		TEXT,
  title     TEXT,
  year      INT,
  PRIMARY KEY (performanceId),
  FOREIGN KEY (theater) REFERENCES theaters(theater),
  FOREIGN KEY (title, year) REFERENCES movies(title, year)
);



CREATE TABLE customers(
  username		TEXT,
  full_name		TEXT,
  password		TEXT,
  nbrOfTickets  INT,
  PRIMARY KEY (username)
);

CREATE TABLE tickets (
  t_id			TEXT DEFAULT (lower(hex(randomblob(16)))),
  username		TEXT,
  performanceId        INT,
  PRIMARY KEY (t_id),
  FOREIGN KEY (performanceId) REFERENCES performances(performanceId),
  FOREIGN KEY (username) REFERENCES customers(username)
);







