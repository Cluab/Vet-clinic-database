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

------------------------------------------------

CREATE TABLE specializations (
    id SERIAL PRIMARY KEY,
    species_id INTEGER REFERENCES species(id),
    vet_id INTEGER REFERENCES vets(id)
);

------------------------------------------------

CREATE TABLE visits (
    id SERIAL PRIMARY KEY,
    animal_id INTEGER REFERENCES animals(id),
    vet_id INTEGER REFERENCES vets(id),
	date_of_visit DATE
);

-------------------------------------------------

-- performance audit

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);


-- create an index on the "animal_id" column of the visits table to improve the performance
CREATE INDEX animal_id_index ON visits (animal_id);

-- create and index on the "vet_id" column of the visits table to improve the performance
CREATE INDEX vet_id_index on visits (vet_id);
