/*
   Rain in the last 48 hours level: codes and their descriptions.

    For the app itself, the list is maintained in a NoSQL "app data" document, which 
    is synced with the app.  In the ETL, the document is brought down and 
    checked for changes, which then get pushed to the EDW.

   Treated as type 2 SCD. However, in the ETL the selection its merged to 
   form a "current conditions" type 4 SCD for the EDW.

*/

DROP TABLE IF EXISTS trnfm.rain_48hours CASCADE;

CREATE TABLE trnfm.rain_48hours  
(   
    rain_48hours_pk INT NOT NULL,
    rain_48hours_description VARCHAR(40) NOT NULL,
    date_added date NOT NULL,
    PRIMARY KEY (rain_48hours_pk)  WITH (FILLFACTOR=100) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;