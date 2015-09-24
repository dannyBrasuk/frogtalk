/*
   Anuran land use codes and their descriptions.

   This data is part of the application itself, and therefore the data
   is maintained in MongoDB.  However, in the ETL its merged with Sites data.

*/

DROP TABLE IF EXISTS trnfm.land_use RESTRICT;


CREATE TABLE trnfm.land_use
(
    land_use_pk INT NOT NULL,
    land_use_description VARCHAR(255) NOT NULL,
    PRIMARY KEY (land_use_pk) WITH (FILLFACTOR=100) USING INDEX TABLESPACE myIndexSpace
)
WITH (FILLFACTOR=100)
TABLESPACE myDataSpace
;

