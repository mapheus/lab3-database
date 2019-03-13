-- Delete the tables if they exist.
-- Disable foreign key checks, so the tables can
-- be dropped in arbitrary order.

PRAGMA foreign_keys=OFF;

DROP TABLE IF EXISTS restocks;
DROP TABLE IF EXISTS ingredients;
DROP TABLE IF EXISTS ingredients_used;
DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS recipe_used;
DROP TABLE IF EXISTS pallets;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

PRAGMA foreign_keys=ON;

-- Create the tables.

CREATE TABLE restocks (
  stock_id        TEXT DEFAULT (lower(hex(randomblob(16)))),
  arrival_date    TEXT,
  amount          INT,
  ingredient_name TEXT,
  PRIMARY KEY (stock_id),
  FOREIGN KEY (ingredient_name) REFERENCES ingredients(ingredient_name)
);


CREATE TABLE ingredients (
  ingredient_name TEXT,
  unit            TEXT,
  PRIMARY KEY (ingredient_name)
);

CREATE TABLE ingredients_used (
  amount          INT,
  ingredient_name	TEXT,
  recipe_name     TEXT,
  FOREIGN KEY (ingredient_name) REFERENCES ingredients(ingredient_name),
  FOREIGN KEY (recipe_name) REFERENCES ingredients(recipe_name)
);

CREATE TABLE recipes (
  recipe_name     TEXT,
  PRIMARY KEY (recipe_name)
);

CREATE TABLE recipe_used(
  recipe_name     TEXT,
  order_id        TEXT,
  FOREIGN KEY (recipe_name) REFERENCES recipes(recipe_name),
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE orders (
  order_id            TEXT DEFAULT (lower(hex(randomblob(16)))),
  amount              INT,
  order_date          DATE,
  last_delivery_date  DATE,
  delivered           INT,
  customer_name       TEXT,
  PRIMARY KEY (order_id),
  FOREIGN KEY (customer_name) REFERENCES customers(customer_name)
);

CREATE TABLE pallets (
  pallet_id        TEXT DEFAULT (lower(hex(randomblob(16)))),
  production_date  DATE,
  expiration_date  DATE,
  blocked          INT,
  state            TEXT,
  recipe_name      TEXT,
  PRIMARY KEY (pallet_id),
  FOREIGN KEY (recipe_name) REFERENCES recipes(recipe_name)
);


CREATE TABLE customers (
  customer_name    TEXT,
  customer_address TEXT,
  PRIMARY KEY (customer_name),
);







