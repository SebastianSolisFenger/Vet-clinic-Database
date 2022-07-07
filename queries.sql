/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-01-01';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

BEGIN TRANSACTION;

UPDATE animals SET species = 'unspecified';

SELECT * FROM animals;

ROLLBACK;

BEGIN TRANSACTION;

UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

COMMIT TRANSACTION;

SELECT * FROM animals;

BEGIN TRANSACTION;

DELETE FROM animals;

ROLLBACK;

SELECT * FROM animals;

-- 'Inside a transaction:'

BEGIN TRANSACTION;

DELETE FROM animals WHERE date_of_birth > '2022-01-01';

SAVEPOINT save_point;

UPDATE animals SET weight_kg = weight_kg * -1;

SELECT * FROM animals;

ROLLBACK TO save_point;

SELECT * FROM animals;

UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;

SELECT * FROM animals;

COMMIT TRANSACTION;

SELECT * FROM animals;

-- 'QUERIES'

--// How many animals are there?

SELECT COUNT(*) FROM animals;

--// How many animals have never tried to escape?

SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

--// What is the average weight of animals?

SELECT AVG(weight_kg) FROM animals;

--// Who escapes the most, neutered or not neutered animals?

SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY neutered;

--// What is the minimum and maximum weight of each type of animal?

SELECT species, MAX(weight_kg), MIN(weight_kg) FROM animals GROUP BY species;

--// What is the average number of escape attempts per animal type of those born between 1990 and 2000?

SELECT species, MAX(weight_kg), MIN(weight_kg) FROM animals GROUP BY species;

--// What is the average number of escape attempts per animal type of those born between 1990 and 2000?

SELECT species, AVG(escape_attempts) FROM animals 
WHERE date_of_birth <= '2000-12-31' AND date_of_birth >= '1990-01-01' 
GROUP BY species;

-- What animals belong to Melody Pond?

SELECT full_name AS owner, name AS animal FROM owners JOIN animals ON owners.id = animals.owner_id 
WHERE owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon)

SELECT animals.name AS pokemon_type FROM animals JOIN species ON animals.species_id = species.id 
WHERE species_id = 1;

-- List all owners and their animals, remember to include those that don't own any animal

SELECT name, full_name FROM animals RIGHT JOIN owners ON animals.owner_id = owners.id;

-- How many animals are there per species?

SELECT species.name AS Species, COUNT (animals.name) AS Total_number 
FROM species JOIN animals ON species.id =  animals.species_id 
GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell

SELECT name AS list_of_digimons FROM animals JOIN owners ON animals.owner_id = owners.id 
WHERE full_name = 'Jennifer Orwell' AND species_id = 2;

-- List all animals owned by Dean Winchester that haven't tried to escape

SELECT name AS AnimalsThatDidnotEscape FROM animals JOIN owners ON animals.owner_id = owners.id
WHERE full_name = 'Dean Winchester' AND escape_attempts = 0;

-- Who owns the most animals?

SELECT owners.full_name AS name, COUNT(*) AS animals_count
FROM owners JOIN animals
ON animals.owner_id = owners.id
GROUP BY  owners.full_name
ORDER BY animals_count DESC
LIMIT 1;

--MANY TO MANY

-- QUERIES FOR QUESTIONS 

-- Who was the last animal seen by William Tatcher?

SELECT vets.name, animals.name, visits.date_of_visit
FROM animals JOIN visits
ON animals.id = visits.animal_id
JOIN vets
ON vets.id =  visits.vet_id
WHERE vets.id = 1
ORDER BY date_of_visit DESC
LIMIT 1

-- How many different animals did Stephanie Mendez see?

SELECT COUNT(DISTINCT animals.name)
FROM animals JOIN visits
on animals.id =  visits.animal_id
JOIN vets
ON vets.id = visits.vet_id
WHERE vets.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.

SELECT vets.id, vets.name AS Vet_name, 
species.name AS specialty_covered 
FROM vets LEFT JOIN specializations 
ON vets.id = specializations.vet_id
LEFT JOIN species
ON specializations.species_id = species.id; 

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.

SELECT vets.name AS VET, animals.name AS animal, visits.date_of_visit AS date
FROM vets JOIN visits
ON vets.id = visits.vet_id
JOIN animals
ON visits.animal_id = animals.id
WHERE vets.name = 'Stephanie Mendez' 
AND visits.date_of_visit >='2020-04-04' AND  visits.date_of_visit <= '2020-08-30'

-- What animal has the most visits to vets?

SELECT animals.name, COUNT(visits.animal_id) AS Max_number_of_visits
FROM animals JOIN visits
ON animals.id = visits.animal_id
GROUP BY animals.name
ORDER BY COUNT(visits.animal_id) DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT vets.name AS VET, animals.name AS Maria_first_visit, visits.date_of_visit FROM animals 
JOIN visits
ON animals.id = visits.animal_id
JOIN vets
ON vets.name  = 'Maisy Smith'
ORDER BY visits.date_of_visit
LIMIT 1

-- Details for most recent visit: animal information, vet information, and date of visit.

ON animals.id = visits.animal_id
JOIN vets
ON vets.id = visits.vet_id
ORDER BY visits.date_of_visit DESC
limit 1;

-- How many visits were with a vet that did not specialize in that animal's species?

SELECT COUNT(*) AS visits FROM visits
JOIN vets
ON vets.id = visits.vet_id
WHERE vets.name = 'Maisy Smith';

-- OR

SELECT count(*)
FROM visits
JOIN vets ON vets.id = visits.vet_id
JOIN animals ON animals.id = visits.animal_id
WHERE animals.species_id NOT IN (
SELECT coalesce(specializations.species_id,3)
    FROM vets
    LEFT JOIN specializations ON specializations.vet_id = vets.id
    WHERE vets.id = visits.vet_id
)

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.

SELECT species.name AS specialty_MAISY_should_get, COUNT(visits.animal_id) as Total_amount
FROM visits JOIN vets
on visits.vet_id = vets.id
JOIN animals
on animals.id =  visits.animal_id
JOIN species
ON species.id = animals.species_id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
LIMIT 1

