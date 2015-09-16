/*
Anuran "fact" table for the EDW.  The grain is an observation of a specific species at a specific time and place and by a specific person.

*/

DROP TABLE IF EXISTS edw.anuran_fact  RESTRICT;
--DROP TABLE IF EXISTS edw.anuran_fact CASCADE;


CREATE TABLE edw.anuran_fact  ( 

    --surrogate key
	anuran_fact_pk INT NOT NULL,

    --Grain  
    --  (We could conceivably use these columns as the primary key, to avoid duplicate observiations. 
    --  Would make sense to prevent duplication. However, the observer key is likely to be unknown. 
    --  Therefore, we best use the surrogate..)
	local_datetime TIMESTAMP NOT NULL,
	site_fk INT NOT NULL,
	observer_fk  INT NOT NULL,
	anuran_species_fk INT NOT NULL,    

    --Fact (non-additive, yes, but there's no other practical way to measure)
    observation_type_id INT NOT NULL,       --heard, seen alive, seed dead
	anuran_calling_code INT NOT NULL,       --analagous to the quanttiy.  need to reconcile with inclination to "sum"

    --Dimensions
	date_fk INT NOT NULL,
    hour_fk  INT NOT NULL,                                   --derived from timestamp; used for aggregation.

    observed_site_condition_fk INT NULL,                        --condition of site per observer, against a mini dimensions

    weather_station_nearest_fk  INT NULL,                       --official weather measurements
    weather_station_temperature_in_celsius INT NULL,
    weather_station_precipitation_in_cm NUMERIC(4,1) NULL,
    weather_station_wind_speed_in_kph NUMERIC(4,1) NULL,
    weather_station_relative_humidty_percent INT NULL,
    weather_station_barometric_pressure numeric(5,1) NULL,

	extraordinary_weather_event_fk INT NULL,             --e.g., hurricane
	extraordinary_astronomical_event_fk	INT NULL,        --eclipse

    after_sunset_indicator BOOLEAN NULL,                    --computed during the ETL.  false if after sunrise is true.
    after_sunrise_indicator BOOLEAN NULL,                   --computed during the ETL.  false if afer sunet is true
	noise_level_fk INT NULL,                                             -- see table
	construction_indicator BOOLEAN NULL,                    --that disturbs habitat

    --raw source data
    notable_site_changes_indicator BOOLEAN NULL,            --does the source document record notable events?
    source_observation_document_id VARCHAR(24) NOT NULL,    --MongoDB id
	sound_recording_record_id  INT NULL,

	PRIMARY KEY(anuran_fact_pk) WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace
)
WITH (FILLFACTOR = 90)
TABLESPACE mydataspace;


COMMENT ON TABLE edw.anuran_fact IS 'An anuran "fact" is a single observation. The grain is an observation of a specific species at a specific time and place (site) and by a specific person (observer).';


COMMENT ON COLUMN edw.anuran_fact.anuran_fact_pk IS 'This is a surrogate key.';

COMMENT ON COLUMN edw.anuran_fact.local_datetime IS 'A component of the grain.';
COMMENT ON COLUMN edw.anuran_fact.site_fk IS 'A component of the grain.';
COMMENT ON COLUMN edw.anuran_fact.observer_fk IS 'A component of the grain.';
COMMENT ON COLUMN edw.anuran_fact.anuran_species_fk IS 'A component of the grain.';

COMMENT ON COLUMN edw.anuran_fact.anuran_calling_code IS 'In conventional EDWs, the "calling code" is equivalent to a "quantity." Of course, though, calling codes cannot be summed. ';
COMMENT ON COLUMN edw.anuran_fact.observation_type_id IS 'Valid entries are heard, seen alive, seen dead';
COMMENT ON COLUMN edw.anuran_fact.weather_station_nearest_fk IS 'Source of the official weather measurements from the nearest station.';
COMMENT ON COLUMN edw.anuran_fact.after_sunset_indicator IS 'Computed during the ETL.  False if after sunrise is true.';
COMMENT ON COLUMN edw.anuran_fact.after_sunrise_indicator IS 'Computed during the ETL.  False if afer sunet is true.';
COMMENT ON COLUMN edw.anuran_fact.notable_site_changes_indicator IS 'Does the source document record (in MongoDB) notable events?';