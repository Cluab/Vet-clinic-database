/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon%';
SELECT name	FROM animals WHERE date_of_birth BETWEEN '01/01/2016' AND '01/1/2019';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Pikachu', 'Agumon');
SELECT name,escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name NOT LIKE 'Gabumon%';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

BEGIN;

-- Update the animals table by setting the species column to 'unspecified'
UPDATE animals SET species = 'unspecified';

-- Verify that the change was made
SELECT COUNT(*) FROM animals WHERE species = 'unspecified';

-- Rollback the change
ROLLBACK;

-- Verify that the species columns went back to the state before the transaction
SELECT COUNT(*) FROM animals WHERE species = 'unspecified';

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


BEGIN;

-- Update the animals table by setting the species column to 'digimon' for all animals that have a name ending in 'mon'
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

-- Update the animals table by setting the species column to 'pokemon' for all animals that don't have species already set.
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

-- Commit the transaction
COMMIT;

-- Verify that the changes made in the transaction persist after the commit
SELECT * FROM animals WHERE species = 'digimon' OR species = 'pokemon'

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

BEGIN;

-- DELETE all animals data from the animals table
DELETE FROM animals;

-- Verify that the animals table is empty
SELECT * FROM animals;

-- Rollback the transaction action
ROLLBACK;

-- Verify that the animals table is not empty
SELECT COUNT(*) FROM animals 

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

BEGIN;

-- DELETE all animals data from the animals table who where born after Jan 1st, 2022
DELETE FROM animals WHERE date_of_birth > '2022-01-01';

-- create a savepoint
SAVEPOINT SP1;

-- Update the animals table by setting the weight_kg column to be negative for all animals.
UPDATE animals SET weight_kg = weight_kg * -1;

-- Verify that the change was made
SELECT weight_kg FROM animals;

-- Rollback to the savepoint
ROLLBACK TO SP1;

-- update the animals table by setting the weight_kg column to be multiplied by -1 for all animals who have a negative weight_kg
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;

-- Verify that the change was made
SELECT weight_kg FROM animals;

-- Commit the transaction
COMMIT;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- How many animals are there?
SELECT COUNT(*) FROM animals 

-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0

-- What is the average weight of animals?

SELECT AVG(weight_kg) FROM animals

-- Who escapes the most, neutered or not neutered animals?

SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered

-- What is the minimum and maximum weight of each type of animal?

SELECT MIN(weight_kg), MAX(weight_kg), species FROM animals GROUP BY species

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?

SELECT species,AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------