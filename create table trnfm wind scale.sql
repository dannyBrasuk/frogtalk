/*
   Wind scale values.

   This data is part of the application itself, and therefore the data
   is maintained in MongoDB. ETL process would download the current settings
   and check for changes.  Assumed to be type 2 SCD.

   In the ETL the selection its merged to form current conditions dim.

*/

DROP TABLE IF EXISTS trnfm.wind_scale RESTRICT;


CREATE TABLE trnfm.wind_scale
(
    wind_scale_pk INT NOT NULL,
    wind_scale_description VARCHAR(255) NOT NULL,
    PRIMARY KEY (wind_scale_pk) WITH (FILLFACTOR=100) USING INDEX TABLESPACE myIndexSpace
)
WITH (FILLFACTOR=100)
TABLESPACE myDataSpace
;
