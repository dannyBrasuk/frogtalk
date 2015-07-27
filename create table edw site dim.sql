--   Dimension table of habitat sites for the EDW

USE frogtalk;
GO

DROP TABLE IF EXISTS edw.site_dim RESTRICT;

GO

--Because Postgres does not support computed columns, compute the Point object in the ETL - if i decide I need it in EDW

CREATE TABLE edw.site_dim  
(   
    site_pk                                         INT NOT NULL,
    watershed_official_name             VARCHAR(255) NULL,               --official, in USA, from the USGS GNIS database.
    watershed_admnistrative_id        VARCHAR(9) NULL,                   --official, from the USGS GNIS database. Should reference boundary
    habitat_label                                VARCHAR(255) NULL,                          --defined by observer
    habitat_description                      VARCHAR(255) NULL,                          --defined by observer
    land_use_description                   VARCHAR(255) NULL,
    longitude_wgs84                         NUMERIC(11,6) NULL,
    latitude_wgs84                            NUMERIC(11,6)  NULL,

    PRIMARY KEY (site_pk)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;
GO
INSERT INTO edw.site_dim (site_pk, watershed_official_name, watershed_admnistrative_id, habitat_label, land_use_description, longitude_wgs84, latitude_wgs84) 
VALUES
(0, '', '', '', '', NULL, NULL),
(1,'Middle Chattahoochee-Lake Harding Watershed', '03130002' ,'Sope Creek tributary at Pinestream Drive', 'Urban Forest', -84.46965, 33.959393),
(2,'Middle Chattahoochee-Lake Harding Watershed', '03130002' ,'', 'Private Backyard',  -84.465294, 33.960068)
;
GO
SELECT *  FROM edw.site_dim;
