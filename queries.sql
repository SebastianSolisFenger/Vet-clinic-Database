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

SELECT owners.full_name as owner, count as Max_numberOfAnimals FROM (
    SELECT full_name, count(animals.owner_id) FROM owners
    JOIN animals ON owners.id = animals.owner_id
    GROUP BY owners.full_name
) AS owners
WHERE count = (
    SELECT MAX(count) FROM (
        SELECT full_name, count(animals.owner_id) FROM owners
        JOIN animals ON owners.id = animals.owner_id
        GROUP BY owners.full_name
    ) AS owners
);