DO $$

BEGIN

        RAISE INFO '>>> Populate the Dimension tables (except date and hour)';

        RAISE INFO '...appdata.land_use';

        INSERT INTO appdata.land_use(land_use_pk, land_use_description) 
        VALUES
        (0,	'None'),
        (1,	'Urban Open Space'),
        (2,	'Urban Forest'),
        (3,	'Private Backyard'),
        (4,	'Nature Park'),
        (5,	'Rural')
        ;

        RAISE INFO '...edw.anuran_calling_code';

        INSERT INTO edw.anuran_calling_code (anuran_calling_code, anuran_calling_code_description)
            VALUES
                    (1,'Individuals can be counted; there is space between calls.'),
                    (2,'Calls of individuals can be distinguished, but there are some overlapping calls.'),
                    (3,'Full chorus, calls are constant, continuous and overlapping.')
        ;

        RAISE INFO '...edw.anuran_species_dim (with samples only)';

        INSERT INTO edw.anuran_species_dim (anuran_species_pk, family, genus, species,  common_name)
        VALUES
        (1, 'Ranidae',  'Rana', 'Rana catesbeiana', 'Bullfrog'),
        (2, 'Ranidae',  'Rana', 'Rana clamitans', 'Green frog')
        ;

        RAISE INFO '...edw.observed_site_condition_dim (with cross joins)';

        INSERT INTO edw.observed_site_condition_dim (observed_site_condition_pk, current_condition_description, wind_scale_description, rain_last_48_hours_description, water_level_description)
            SELECT ROW_NUMBER() OVER(ORDER BY cc_code, ws_code, r_code, wl_code) as ID, current_condition_description, wind_scale_description, rain_last_48_hours_description, water_level_description
            FROM
            (VALUES
                    (0,'Not recorded'),
                    (1,'Sunny and clean'),
                    (2,'Partly cloudy or variable sky'),
                    (3,'Overcast'),
                    (4,'Fog or smoke'),
                    (5,'Drizzle / light rain')
            ) AS current_conditions (cc_code, current_condition_description)
            CROSS JOIN
            (VALUES
            (0,'Not recorded or observed'),
            (1,'Calm'),
            (2,'Light Breeze'),
            (3,'Gentle Breeze'),
            (4,'Moderate Breeze'),
            (5,'Fresh Breeze')
            ) AS wind_scale_conditions (ws_code, wind_scale_description)
            CROSS JOIN
            (VALUES
            (0,'None'),
            (1,'Light (less than 1/2 inch)'),
            (2,'Moderate (1/2 - 1 inch)'),
            (3,'Heavy (< 1 inch)')
            ) AS rain_conditions (r_code, rain_last_48_hours_description)
            CROSS JOIN
            (VALUES
            (0,'Not observed or unobservable'),
            (1,'Extremely dry - drought conditions'),
            (2,'Moist, but no standing water'),
            (3,'Shallow water (less than 1 foot)'),
            (4,'Deep water (more than 1 foot)'),
            (5,'Permanent Water')
            ) AS later_level_conditions (wl_code, water_level_description);


        RAISE INFO '...edw.extraordinary_astronomical_event_dim (with sample data)';

        INSERT INTO edw.extraordinary_astronomical_event_dim (extraordinary_astronomical_event_pk, extraordinary_astronomical_event_description)
            VALUES (0, 'None'), (1, 'Solar eclispe'), (2, 'Lunar eclispe');



        RAISE INFO '...edw.extraordinary_weather_event_dim';

        INSERT INTO edw.extraordinary_weather_event_dim (extraordinary_weather_event_pk, extraordinary_weather_event_description)
            VALUES (0, 'None'), (1, 'Hurricane'), (2, 'Excessive Lighting');


        RAISE INFO '...edw.noise_level_dim';

        INSERT INTO edw.noise_level_dim (noise_level_pk, noise_level_description)
            VALUES 
                    (0,'Not recorded or observed'),
                    (1,'No effect (owl calling)'),
                    (2,'Slight effect (distant traffic, dog barking)'),
                    (3,'Moderate effect (nearby traffic, 2-5 cars passing)'),
                    (4,'Serious effect (continuous traffic nearby, 6-10 cars passing)'),
                    (5,'Profound effect (continuous traffic passing, construction noise)')
            ;



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

/*

Sample species
Bullfrog

Kingdom:	Animalia
Phylum:	Chordata
Subphylum:	Vertebrata
Class:              Amphibia
Order:             Anura
Family:	Ranidae
Genus:             Rana
Species:	Rana. catesbeiana


*/