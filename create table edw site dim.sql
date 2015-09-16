/*
Dimension table of habitat sites for the EDW
*/


DROP TABLE IF EXISTS edw.site_dim RESTRICT;


--Because Postgres does not support computed columns, compute the Point object in the ETL - if i decide I need it in EDW

CREATE TABLE edw.site_dim  
(   
    site_pk INT NOT NULL,
    site_label VARCHAR(255) NULL,                         --defined by observer
    site_description VARCHAR(255) NULL,                   --defined by observer

    protected_land_indicator BOOLEAN NULL,                --wildlife sancturary, national or state park, etc.
    water_source_description VARCHAR(40) NULL             --permanent, intermittent, ehphermal
    land_use_description VARCHAR(255) NULL,

    watershed_official_name VARCHAR(255) NULL,            --official, in USA, from the USGS GNIS database.
    watershed_admnistrative_id VARCHAR(9) NULL,           --official, from the USGS GNIS database. Should reference boundary

    country_code_iso3 VARCHAR(3) NOT NULL,
    adminstrative_level1_name VARCHAR(256) NOT NULL,      --The State name, in the US
    adminstrative_level2_name VARCHAR(256) NULL,          --The county name, in the US
    adminstrative_level3_name VARCHAR(256) NULL,
    adminstrative_level1_boundary_map_recordID INT NULL,
    adminstrative_level2_boundary_map_recordID INT NULL,
    adminstrative_level3_boundary_map_recordID INT NULL,

    site_longitude_wgs84 NUMERIC(11,6) NULL,
    site_latitude_wgs84 NUMERIC(11,6)  NULL,

    PRIMARY KEY (site_pk)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;

