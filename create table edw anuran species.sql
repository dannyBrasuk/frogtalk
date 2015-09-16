/*
   Anuran species

*/
DROP TABLE IF EXISTS edw.anuran_species_dim CASCADE;

CREATE TABLE edw.anuran_species_dim  
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