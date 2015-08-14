USE frogtalk;
GO

/*

Constraints on the Fact table.

Supporting indexes are included here for clarity.


*/

--**
--Keep the facts unique, to avoid double counting.  (Note that it's possible for two observers to record the same event
--at a very slightly different moment in time, which would essentially be a duplicate.. For now, we'll skip over this "feature."

DROP INDEX IF EXISTS edw.uniqueFact ;

CREATE UNIQUE INDEX uniqueFact  ON edw.anuran_fact USING btree
	(local_datetime, site_fk, anuran_species_fk)
WITH (FILLFACTOR=90) 
TABLESPACE myindexspace;

ALTER TABLE edw.anuran_fact
    DROP CONSTRAINT IF EXISTS fact_must_be_unique,
    ADD CONSTRAINT fact_must_be_unique UNIQUE USING INDEX uniqueFact;
    
GO
--*
-- "Site"  

DROP INDEX edw.anuran_site_index;
GO
CREATE INDEX anuran_site_index ON edw.anuran_fact USING btree (site_fk)
	WITH (FILLFACTOR = 90)
	TABLESPACE myindexspace;
GO
ALTER TABLE edw.anuran_fact
    DROP CONSTRAINT IF EXISTS fk_anuran_site,
    ADD CONSTRAINT fk_anuran_site
	FOREIGN KEY(site_fk)
	REFERENCES edw.site_dim(site_pk)
	ON DELETE SET NULL 
	ON UPDATE CASCADE;
GO
--*
-- "Observer"  
DROP INDEX IF EXISTS edw.anuran_observer_index;
GO
CREATE INDEX anuran_observer_index  ON edw.anuran_fact  USING btree  (observer_fk)
WITH (FILLFACTOR=90) 
TABLESPACE myindexspace;
GO
ALTER TABLE edw.anuran_fact
    DROP CONSTRAINT IF EXISTS fk_anuran_observer,
    ADD CONSTRAINT fk_anuran_observer
	FOREIGN KEY(observer_fk)
	REFERENCES edw.observer_dim(observer_pk)
	ON DELETE SET NULL 
	ON UPDATE CASCADE;
GO
--*
-- "Species"  
DROP INDEX IF EXISTS edw.anuran_species_index;

CREATE INDEX anuran_species_index  ON edw.anuran_fact  USING btree  (anuran_species_fk)
WITH (FILLFACTOR=90) 
TABLESPACE myindexspace;

ALTER TABLE edw.anuran_fact
    DROP CONSTRAINT IF EXISTS fk_anuran_species,
    ADD CONSTRAINT fk_anuran_species
	FOREIGN KEY(anuran_species_fk)
	REFERENCES edw.anuran_species_dim(anuran_species_pk)
	ON DELETE SET NULL 
	ON UPDATE CASCADE;
GO
--*
-- "Calling Code"    
DROP INDEX IF EXISTS edw.anuran_calling_code_index;

CREATE INDEX anuran_calling_code_index  ON edw.anuran_fact  USING btree  (anuran_calling_code)
WITH (FILLFACTOR=90) 
TABLESPACE myindexspace;

ALTER TABLE edw.anuran_fact
    DROP CONSTRAINT IF EXISTS fk_anuran_calling_code,
    ADD CONSTRAINT fk_anuran_calling_code
	FOREIGN KEY(anuran_calling_code)
	REFERENCES edw.anuran_calling_code(anuran_calling_code)
	ON DELETE SET NULL 
	ON UPDATE CASCADE;
GO
--*
-- "Date" (for reporting purposes);
DROP INDEX IF EXISTS edw.anuran_date_index;

CREATE INDEX anuran_date_index  ON edw.anuran_fact  USING btree  (date_fk)
WITH (FILLFACTOR=90) 
TABLESPACE myindexspace;

ALTER TABLE edw.anuran_fact
    DROP CONSTRAINT IF EXISTS fk_anuran_date,
    ADD CONSTRAINT fk_anuran_date
	FOREIGN KEY(date_fk)
	REFERENCES edw.date_dim(date_pk)
	ON DELETE SET NULL 
	ON UPDATE CASCADE;
GO
--*
-- "Hour" (for reporting purposes);
DROP INDEX IF EXISTS edw.anuran_hour_index;

CREATE INDEX anuran_hour_index  ON edw.anuran_fact  USING btree  (hour_fk)
WITH (FILLFACTOR=90) 
TABLESPACE myindexspace;

ALTER TABLE edw.anuran_fact
    DROP CONSTRAINT IF EXISTS fk_anuran_hour,
    ADD CONSTRAINT fk_anuran_hour
	FOREIGN KEY(hour_fk)
	REFERENCES edw.hour_dim(hour_pk)
	ON DELETE SET NULL 
	ON UPDATE CASCADE;

GO
--*
-- Geo / Admin Level 
DROP INDEX IF EXISTS edw.anuran_geographic_administrative_level_index;

CREATE INDEX anuran_geographic_administrative_level_index  ON edw.anuran_fact  USING btree  (geographic_administrative_level_fk)
WITH (FILLFACTOR=90) 
TABLESPACE myindexspace;

ALTER TABLE edw.anuran_fact
    DROP CONSTRAINT IF EXISTS fk_anuran_geographic_administrative_level,
    ADD CONSTRAINT fk_anuran_geographic_administrative_level
	FOREIGN KEY(geographic_administrative_level_fk)
	REFERENCES edw.geographic_administrative_level_dim(geographic_administrative_level_pk)
	ON DELETE SET NULL 
	ON UPDATE CASCADE;

GO
--*
-- Observed Site Condition
DROP INDEX IF EXISTS edw.anuran_observed_site_condition_index;

CREATE INDEX anuran_observed_site_condition_index  ON edw.anuran_fact  USING btree  (observed_site_condition_fk)
WITH (FILLFACTOR=90) 
TABLESPACE myindexspace;

ALTER TABLE edw.anuran_fact
    DROP CONSTRAINT IF EXISTS fk_anuran_observed_site_condition,
    ADD CONSTRAINT fk_anuran_observed_site_condition
	FOREIGN KEY(observed_site_condition_fk)
	REFERENCES edw.observed_site_condition_dim(observed_site_condition_pk)
	ON DELETE SET NULL 
	ON UPDATE CASCADE;


GO
--*
-- Nearest weather station
DROP INDEX IF EXISTS edw.anuran_weather_station_nearest_index;

CREATE INDEX anuran_weather_station_nearest_index  ON edw.anuran_fact  USING btree  (weather_station_nearest_fk)
WITH (FILLFACTOR=90) 
TABLESPACE myindexspace;

ALTER TABLE edw.anuran_fact
    DROP CONSTRAINT IF EXISTS fk_anuran_weather_station_nearest,
    ADD CONSTRAINT fk_anuran_weather_station_nearest
	FOREIGN KEY(weather_station_nearest_fk)
	REFERENCES edw.weather_station_nearest_dim(weather_station_nearest_pk)
	ON DELETE SET NULL 
	ON UPDATE CASCADE;

GO
--*
-- Extraordinary weather event type
DROP INDEX IF EXISTS edw.anuran_extraordinary_weather_event_index;

CREATE INDEX anuran_extraordinary_weather_event_index  ON edw.anuran_fact  USING btree  (extraordinary_weather_event_fk)
WITH (FILLFACTOR=90) 
TABLESPACE myindexspace;

ALTER TABLE edw.anuran_fact
    DROP CONSTRAINT IF EXISTS fk_anuran_extraordinary_weather_event,
    ADD CONSTRAINT fk_anuran_extraordinary_weather_event
	FOREIGN KEY(extraordinary_weather_event_fk)
	REFERENCES edw.extraordinary_weather_event_dim(extraordinary_weather_event_pk)
	ON DELETE SET NULL 
	ON UPDATE CASCADE;


GO
--*
-- Extraordinary astronomical event type
DROP INDEX IF EXISTS edw.anuran_extraordinary_astronomical_event_index;

CREATE INDEX anuran_extraordinary_astronomical_event_index  ON edw.anuran_fact  USING btree  (extraordinary_astronomical_event_fk)
WITH (FILLFACTOR=90) 
TABLESPACE myindexspace;

ALTER TABLE edw.anuran_fact
    DROP CONSTRAINT IF EXISTS fk_anuran_extraordinary_astronomical_event,
    ADD CONSTRAINT fk_anuran_extraordinary_astronomical_event
	FOREIGN KEY(extraordinary_astronomical_event_fk)
	REFERENCES edw.extraordinary_astronomical_event_dim(extraordinary_astronomical_event_pk)
	ON DELETE SET NULL 
	ON UPDATE CASCADE;

GO
--*
-- Noise level observed at the site
DROP INDEX IF EXISTS edw.anuran_noise_level_index;

CREATE INDEX anuran_noise_level_index  ON edw.anuran_fact  USING btree  (noise_level_fk)
WITH (FILLFACTOR=90) 
TABLESPACE myindexspace;

ALTER TABLE edw.anuran_fact
    DROP CONSTRAINT IF EXISTS fk_anuran_noise_level,
    ADD CONSTRAINT fk_anuran_noise_level
	FOREIGN KEY(noise_level_fk)
	REFERENCES edw.noise_level_dim(noise_level_pk)
	ON DELETE SET NULL 
	ON UPDATE CASCADE;

