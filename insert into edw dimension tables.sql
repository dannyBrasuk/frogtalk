DO $$

BEGIN

    
        RAISE INFO '...edw.anuran_species_dim (with samples only)';

        INSERT INTO edw.anuran_species_dim (anuran_species_pk, family, genus, species,  common_name)
        VALUES
        (1, 'Ranidae',  'Rana', 'Rana catesbeiana', 'Bullfrog'),
        (2, 'Ranidae',  'Rana', 'Rana clamitans', 'Green frog')
        ;

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

END ;
$$  language plpgsql;

