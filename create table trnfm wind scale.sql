/*
   Wind scale values.

    For the app itself, the list is maintained in a NoSQL "app data" document, which 
    is synced with the app.  In the ETL, the document is brought down and 
    checked for changes, which then get pushed to the EDW. 

   Treated as type 2 SCD. However, in the ETL the selection its merged to 
   form a "current conditions" type 4 SCD for the EDW.

*/

DROP TABLE IF EXISTS trnfm.wind_scale CASCADE;

CREATE TABLE trnfm.wind_scale
(
    wind_scale_pk INT NOT NULL,
    wind_scale_description VARCHAR(255) NOT NULL,
    date_added date NOT NULL,
    PRIMARY KEY (wind_scale_pk) WITH (FILLFACTOR=100) USING INDEX TABLESPACE myIndexSpace
)
WITH (FILLFACTOR=100)
TABLESPACE myDataSpace
;
