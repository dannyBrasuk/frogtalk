/*
    Anuran species for the transform schema.

    For the app itself, the list is maintained in a NoSQL "app data" document, which 
    is synced with the app.  In the ETL, the document is brought down and 
    checked for changes, which then get pushed to the EDW.

    In the EDW it becomes a Type 2 SCD (but I suppose could become a type 3).

*/

DROP TABLE IF EXISTS trnfm.anuran_species CASCADE;

CREATE TABLE trnfm.anuran_species_dim  
(   
    anuran_species_pk INT NOT NULL,
    family VARCHAR(40) NULL,   
    genus VARCHAR(40) NULL, 
    species VARCHAR(40) NULL, 
    common_name  VARCHAR(40) NULL, 
    date_added date NOT NULL,
    PRIMARY KEY (anuran_species_pk)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;