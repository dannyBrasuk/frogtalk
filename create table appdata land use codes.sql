--   app lookup table; to be used ETL

USE frogtalk;
GO

DROP TABLE IF EXISTS appdata.land_use RESTRICT;
GO

CREATE TABLE appdata.land_use
(
    land_use_pk INT NOT NULL,
    land_use_description VARCHAR(255) NOT NULL,
    PRIMARY KEY (land_use_pk) WITH (FILLFACTOR=100) USING INDEX TABLESPACE myIndexSpace
)
WITH (FILLFACTOR=100)
TABLESPACE myDataSpace
;
GO
INSERT INTO appdata.land_use(land_use_pk, land_use_description) 
VALUES
(0,	'None'),
(1,	'Urban Open Space'),
(2,	'Urban Forest'),
(3,	'Private Backyard'),
(4,	'Nature Park'),
(5,	'Rural')
;
GO
SELECT * FROM appdata.land_use;