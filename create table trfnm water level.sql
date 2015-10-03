/*
   Water level codes and their descriptions.

   This data is part of the application itself, and therefore the data
   is maintained in MongoDB.  However, in the ETL its merged with Sites data on
   the way to the EDW.

*/

DROP TABLE IF EXISTS trnfm.water_level RESTRICT;


CREATE TABLE trnfm.water_level
(
    water_level_pk INT NOT NULL,
    water_level_description VARCHAR(255) NOT NULL,
    date_updated date NOT NULL,
    PRIMARY KEY (water_level_pk) WITH (FILLFACTOR=100) USING INDEX TABLESPACE myIndexSpace
)
WITH (FILLFACTOR=100)
TABLESPACE myDataSpace
;

