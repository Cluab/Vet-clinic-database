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

-- What animals belong to Melody Pond?
 SELECT name, full_name FROM animals 
INNER JOIN owners
on animals.owner_id = owners.id where owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is pokemon).
SELECT animals.name, species.name
FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT full_name, name FROM owners
LEFT JOIN animals 
on owners.id = animals.owner_id

-- How many animals are there per species?
SELECT species.name,  COUNT(animals.name) FROM species
 JOIN animals 
on species.id = animals.species_id
GROUP BY species.name

-- List all Digimon owned by Jennifer Orwell.
SELECT full_name, name FROM owners
INNER JOIN animals 
on owners.id = animals.owner_id
WHERE owners.full_name = 'Jennifer Orwell' AND animals.species_id = 2

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT full_name, name FROM owners
INNER JOIN animals 
on owners.id = animals.owner_id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0

-- who owns the most animals.
SELECT full_name, COUNT(animals.name) name FROM owners
JOIN animals 
on owners.id = animals.owner_id
GROUP BY owners.full_name


----------------------------------------------------------------------------------


-- Who was the last animals seen by William Tatcher?
SELECT animals.name FROM animals where animals.id = 
(SELECT visits.animal_id FROM visits WHERE visits.vet_id = 1
ORDER BY visits.date_of_visit DESC LIMIT 1);	

-- How many different animals did Stiphen Mendez see?
SELECT COUNT(DISTINCT visits.animal_id) FROM visits WHERE visits.vet_id = 3

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name, species.name FROM vets
LEFT JOIN specializations
on vets.id = specializations.vet_id
LEFT JOIN species
on specializations.species_id = species.id

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name FROM animals 
join visits
on animals.id = visits.animal_id
WHERE visits.vet_id = 3
AND visits.date_of_visit BETWEEN '2020-4-1' AND '2020-8-30';

-- What animal has the most visits to vets?

SELECT animals.name, COUNT(visits.animal_id) name FROM visits
JOIN animals 
on visits.animal_id = animals.id
GROUP BY animals.name

-- Who was Maisy Smith's first visit?
SELECT animals.name FROM animals
JOIN visits
on animals.id = visits.animal_id
WHERE visits.vet_id = 2
ORDER BY visits.date_of_visit ASC LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.

SELECT animals.name, vets.name, visits.date_of_visit FROM visits
JOIN animals
on visits.animal_id = animals.id
JOIN vets
on visits.vet_id = vets.id
ORDER BY visits.date_of_visit DESC LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?

SELECT COUNT(visits.animal_id) FROM visits
JOIN animals
on visits.animal_id = animals.id
JOIN specializations
on visits.vet_id = specializations.vet_id
WHERE animals.species_id != specializations.species_id

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.

SELECT species.name, COUNT(visits.animal_id) name FROM visits
JOIN animals
on visits.animal_id = animals.id
JOIN specializations
on visits.vet_id = specializations.vet_id
JOIN species
on animals.species_id = species.id
WHERE animals.owner_id = 2
GROUP BY species.name
ORDER BY COUNT(visits.animal_id) DESC LIMIT 1;


-------------------------------------------------------------------------------------------------------------------------------------


-- performance audit

-- create an index on the "animal_id" column of the visits table to improve the performance of the following query:

SELECT COUNT(*) FROM visits where animal_id = 4;





