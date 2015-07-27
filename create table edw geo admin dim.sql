--   Dimension table of geographic heirachy levels for the EDW

USE frogtalk;
GO

DROP TABLE IF EXISTS edw.geographic_administrative_level_dim RESTRICT;

GO
CREATE TABLE edw.geographic_administrative_level_dim 
( 
    geographic_administrative_level_pk         INT NOT NULL,
    country_code_iso3                                    VARCHAR(3) NOT NULL,
    adminstrative_level1_name                       VARCHAR(256) NOT NULL,
    adminstrative_level2_name                       VARCHAR(256) NULL,
    adminstrative_level3_name                       VARCHAR(256) NULL,
    adminstrative_level1_boundary_map_recordID    INT NULL,
    adminstrative_level2_boundary_map_recordID    INT NULL,
    adminstrative_level3_boundary_map_recordID    INT NULL,
    PRIMARY KEY (geographic_administrative_level_pk)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;
GO
--Initialize with a default record plus my local record
--Table itself is maintained in the ETL schema; hence the non-serial nature of the pk.
--Lower level codes, such as USGS Feature ID to be housed in a collection of tables in the ETL schema.   It's assumed that they wont be needed in the EDW.
--Levels refer to ISO levels.  So in the USA, level 1 is the state; level 2 is the county.
INSERT INTO edw.geographic_administrative_level_dim (geographic_administrative_level_pk, country_code_iso3, adminstrative_level1_name, adminstrative_level2_name, adminstrative_level3_name)
VALUES 
(0,'', '', '',''),
(1,'USA', 'Georgia', 'Cobb County','')
;

GO
SELECT * FROM edw.geographic_administrative_level_dim ;
