/*
   Water level codes and their descriptions.

    For the app itself, the list is maintained in a NoSQL "app data" document, which 
    is synced with the app.  In the ETL, the document is brought down and 
    checked for changes, which then get pushed to the EDW.

   Treated as type 2 SCD. However, in the ETL the selection its merged to 
   form a "current conditions" type 4 SCD for the EDW.

*/

DROP TABLE IF EXISTS trnfm.water_level CASCADE;

CREATE TABLE trnfm.water_level
(
    water_level_pk INT NOT NULL,
    water_level_description VARCHAR(255) NOT NULL,
    date_added date NOT NULL,
    PRIMARY KEY (water_level_pk) WITH (FILLFACTOR=100) USING INDEX TABLESPACE myIndexSpace
)
WITH (FILLFACTOR=100)
TABLESPACE myDataSpace
;

