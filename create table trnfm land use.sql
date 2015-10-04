/*
   Anuran land use codes and their descriptions.

    For the app itself, the list is maintained in a NoSQL "app data" document, which 
    is synced with the app.  In the ETL, the document is brought down and 
    checked for changes, which then get pushed to the EDW.

   Treated as type 2 SCD in the EDW.
   
*/

DROP TABLE IF EXISTS trnfm.land_use CASCADE;

CREATE TABLE trnfm.land_use
(
    land_use_pk INT NOT NULL,
    land_use_description VARCHAR(255) NOT NULL,
    date_added date NOT NULL,
    PRIMARY KEY (land_use_pk) WITH (FILLFACTOR=100) USING INDEX TABLESPACE myIndexSpace
)
WITH (FILLFACTOR=100)
TABLESPACE myDataSpace
;

