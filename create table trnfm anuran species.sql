/*
    Anuran species for the transform schema.

    So the list kept in the application database in MongoDB get sync'd with this list, before
    moving into the EDW as a Type 2 SCD.

*/
DROP TABLE IF EXISTS trnfm.anuran_species RESTRICT;

CREATE TABLE trnfm.anuran_species_dim  
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