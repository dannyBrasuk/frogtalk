/*
   Anuran species

*/

USE frogtalk;
GO

DROP TABLE IF EXISTS edw.anuran_species RESTRICT;

GO

CREATE TABLE edw.anuran_species  
(   
    anuran_species_pk INT NOT NULL,
    family VARCHAR(40) NULL,   
    genus VARCHAR(40) NULL, 
    species VARCHAR(40) NULL, 
    common_name  VARCHAR(40) NULL, 

    PRIMARY KEY (anuran_species_pk)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;

GO

INSERT INTO edw.anuran_species (anuran_species_pk, family, genus, species,  common_name)
VALUES
(1, 'Ranidae',  'Rana', 'Rana catesbeiana', 'Bullfrog'),
(2, 'Ranidae',  'Rana', 'Rana clamitans', 'Green frog')
;

GO
SELECT * FROM edw.anuran_species;

/*

Sample:'
Bullfrog

Kingdom:	Animalia
Phylum:	Chordata
Subphylum:	Vertebrata
Class:              Amphibia
Order:             Anura
Family:	Ranidae
Genus:             Rana
Species:	Rana. catesbeiana


*/