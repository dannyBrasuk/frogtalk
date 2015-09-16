
DO $$

BEGIN

    RAISE INFO '>>> Review the Dimension table contents (except date and hour)';

    RAISE INFO '...stage.land_use';
    SELECT * FROM stage.land_use;

    RAISE INFO '...edw.anuran_calling_code';
    SELECT * FROM edw.anuran_calling_code ;

    RAISE INFO '...edw.anuran_species_dim';
    SELECT * FROM edw.anuran_species_dim;

    RAISE INFO '...edw.observed_site_condition_dim';
    SELECT * FROM edw.observed_site_condition_dim  ORDER BY observed_site_condition_pk;

    RAISE INFO '...edw.extraordinary_astronomical_event_dim';
    SELECT * FROM edw.extraordinary_astronomical_event_dim ;

    RAISE INFO '...edw.extraordinary_weather_event_dim';
    SELECT * FROM edw.extraordinary_weather_event_dim ;

    RAISE INFO '...edw.noise_level_dim';
    SELECT * FROM edw.noise_level_dim ;

    RAISE INFO '...edw.observer_dim';
    SELECT * FROM edw.observer_dim;



END ;
$$  language plpgsql;