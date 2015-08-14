/*
Anuran "fact" table for the EDW.  The grain is an observation of a specific species at a specific time and place and by a specific person.

*/

USE frogtalk;
GO
DROP TABLE IF EXISTS edw.anuran_fact  RESTRICT;
--DROP TABLE IF EXISTS edw.anuran_fact CASCADE;

GO

CREATE TABLE edw.anuran_fact  ( 

            --surrogate key
	anuran_fact_pk INT NOT NULL,

            --grain  (We could conceivably use these columns as the primary key, to avoid duplicate observiations. 
            --            Would make sense to prevent duplication. However, the observer key is likely to be unknown. 
            --             Therefore, we best use the surrogate..)
	local_datetime TIMESTAMP NOT NULL,
	site_fk INT NOT NULL,                                               --label, watershed, etc.
	observer_fk  INT NOT NULL,
	anuran_species_fk INT NOT NULL,

            --fact (non-additive, yes, but there's no other practical way to measure)
	anuran_calling_code INT NOT NULL,                    --analagous to the quanttiy.  need to reconcile with inclination to "sum"

            --dimensions
	date_fk INT NOT NULL,
            hour_fk  INT NOT NULL,                                             --derived from timestamp; used for aggregation.

	geographic_administrative_level_fk INT NULL,             --country, state/province, county

            observed_site_condition_fk INT NULL,                        --condition of site per observer, against a mini dimensions

            weather_station_nearest_fk  INT NULL,                       --official weather measurements
            weather_station_temperature_in_celsius INT NULL,
            weather_station_precipitation_in_cm NUMERIC(4,1) NULL,
            weather_station_wind_speed_in_kph NUMERIC(4,1) NULL,
            weather_station_relative_humidty_percent INT NULL,
            weather_station_barometric_pressure numeric(5,1) NULL,

	extraordinary_weather_event_fk INT NULL,                --e.g., hurricane
	extraordinary_astronomical_event_fk	INT NULL,        --eclipse

            after_sunset_indicator BOOLEAN NULL,                    --computed during the ETL.  false if after sunrise is true.
            after_sunrise_indicator BOOLEAN NULL,                   --computed during the ETL.  false if afer sunet is true
	noise_level_fk INT NULL,                                             -- see table
	construction_indicator BOOLEAN NULL,                    --that disturbs habitat

            --raw source data
	habitat_description_record_id INT NULL,                     --link to text data record
	comments_record_id INT NULL,
	sound_recording_record_id  INT NULL,
            source_observation_document_id VARCHAR(24) NOT NULL,  

	PRIMARY KEY(anuran_fact_pk) WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace
)
WITH (FILLFACTOR = 90)
TABLESPACE mydataspace
GO


