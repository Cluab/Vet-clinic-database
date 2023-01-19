/* Database schema to keep the structure of entire database. */

---- day 1
CREATE TABLE animals(
  id            INT GENERATED ALWAYS AS IDENTITY,
  name     	    VARCHAR(250),
  date_of_birth       date,
  escape_attempts       INT,
  neutered           BOOLEAN,
  weight_kg          DECIMAL(10,2),
  PRIMARY KEY(id)
);

----- day 2

ALTER TABLE animals
ADD COLUMN species VARCHAR(250);

----- day 3

ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals
 ADD COLUMN species_id  INT references species(id);

 ALTER TABLE animals 
 ADD COLUMN owner_id  INT references owners(id);

 
------------------------------------------------
CREATE TABLE owners (
    id			SERIAL PRIMARY KEY,
	full_name	VARCHAR(250),
	age 		INT
)
------------------------------------------------
CREATE TABLE species (
    id			SERIAL PRIMARY KEY,
	name	    VARCHAR(250)
)
------------------------------------------------

CREATE TABLE vets (
	id 					        INT GENERATED ALWAYS AS IDENTITY,
	name 				        VARCHAR(250),
	age					        INT,
	date_of_graduation	DATE,
	PRIMARY KEY (id)
)