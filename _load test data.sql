/*

These scripts are of date, as of Aug 21, 2105.  To be revised.

*/


INSERT INTO edw.site_dim (site_pk, watershed_official_name, watershed_admnistrative_id, habitat_label, land_use_description, longitude_wgs84, latitude_wgs84) 
VALUES
(0, '', '', '', '', NULL, NULL),
(1,'Middle Chattahoochee-Lake Harding Watershed', '03130002' ,'Sope Creek tributary at Pinestream Drive', 'Urban Forest', -84.46965, 33.959393),
(2,'Middle Chattahoochee-Lake Harding Watershed', '03130002' ,'', 'Private Backyard',  -84.465294, 33.960068)
;
GO
SELECT *  FROM edw.site_dim;

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
