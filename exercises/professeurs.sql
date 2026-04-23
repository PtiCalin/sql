-- SQL script to create and populate the 'professeurs' table

-- Drop the table if it already exists to avoid errors
DROP table IF EXISTS professeurs;

-- Create the 'professeurs' table with the specified columns and constraints
CREATE table professeurs (
    matricule int not null primary key,
    nom char(50) not null,
    prenom char(50) not null,
    position char(50),
    cours char(50),
    annee_entree int,
);

-- Insert sample data into the 'professeurs' table
INSERT INTO professeurs (matricule, nom, prenom, position, cours, annee_entree) VALUES
(1, 'Smith', 'John', 'Professor', 'Mathematics', 2010),
(2, 'Doe', 'Jane', 'Associate Professor', 'Physics', 2012),
(3, 'Brown', 'Charlie', 'Assistant Professor', 'Chemistry', 2015);

-- Query to select all records from the 'professeurs' table
SELECT * FROM professeurs;


-- End of the SQL script for the 'professeurs' table