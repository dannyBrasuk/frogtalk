DO $$

BEGIN

    
        RAISE INFO '...edw.extraordinary_astronomical_event_dim (with sample data)';

        INSERT INTO edw.extraordinary_astronomical_event_dim (extraordinary_astronomical_event_pk, extraordinary_astronomical_event_description)
            VALUES (0, 'None'), (1, 'Solar eclispe'), (2, 'Lunar eclispe');


        RAISE INFO '...edw.extraordinary_weather_event_dim';

        INSERT INTO edw.extraordinary_weather_event_dim (extraordinary_weather_event_pk, extraordinary_weather_event_description)
            VALUES (0, 'None'), (1, 'Hurricane'), (2, 'Excessive Lighting');


        RAISE INFO '...edw.observer_dim (with sample data)';

        INSERT INTO edw.observer_dim (observer_pk, observer_type_description, date_first_joined,affliation_description ) 
        VALUES
        (0, 'Unregistered', NULL, NULL),
        (1, 'Volunteer', '04/01/2013', NULL),
        (2, 'Volunteer', '05/01/2014', NULL),
        (3, 'Professional', '06/15/2010', 'Cobb County Water Authority')
        ;

        RAISE INFO '...edw.site_dim (with sample data)';

        INSERT INTO edw.site_dim (site_pk, watershed_official_name, watershed_admnistrative_id, habitat_label, land_use_description, longitude_wgs84, latitude_wgs84) 
        VALUES
        (0, '', '', '', '', NULL, NULL),
        (1,'Middle Chattahoochee-Lake Harding Watershed', '03130002' ,'Sope Creek tributary at Pinestream Drive', 'Urban Forest', -84.46965, 33.959393),
        (2,'Middle Chattahoochee-Lake Harding Watershed', '03130002' ,'', 'Private Backyard',  -84.465294, 33.960068)
        ;
      
        --Initialize with a default record plus my local record
        --Table itself is maintained in the ETL schema; hence the non-serial nature of the pk.
        --Lower level codes, such as USGS Feature ID to be housed in a collection of tables in the ETL schema.   It's assumed that they wont be needed in the EDW.
        --Levels refer to ISO levels.  So in the USA, level 1 is the state; level 2 is the county.
 
        RAISE INFO '...edw.geographic_administrative_level_dim (with sample data)';  

       INSERT INTO edw.geographic_administrative_level_dim (geographic_administrative_level_pk, country_code_iso3, adminstrative_level1_name, adminstrative_level2_name, adminstrative_level3_name)
        VALUES 
        (0,'', '', '',''),
        (1,'USA', 'Georgia', 'Cobb County','')
        ;


END ;
$$  language plpgsql;
