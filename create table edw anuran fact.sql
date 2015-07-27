--  Anuran "fact" table for the EDW

USE frogtalk;
GO

DROP TABLE IF EXISTS edw.anuran_fact RESTRICT;

GO

CREATE TABLE edw.anuran_fact  ( 
	anuran_fact_pk                     	serial NOT NULL,
	local_datetime                     	timestamp NOT NULL,
	date_fk                            	int4 NOT NULL,
	time_fk                            	int4 NOT NULL,
	site_fk                            	int4 NOT NULL,
	registered_observer_fk            int4 NULL,
	anuran_species_fk                  	int4 NOT NULL,
	anuran_calling_code_fk             int4 NOT NULL,
	geographic_adminstrative_level_fk  	int4 NULL,
	extraordinary_astronomical_event_fk	int4 NULL,
	extraordinary_weather_event_fk     	int4 NULL,
	current_weather_condition_fk       	int4 NULL,
	noise_level_fk                                     int4 NULL,
	construction_indicator             	bool NULL,
	habitat_description_record_id      	int4 NULL,
	comments_record_id                 	int4 NULL,
	sound_recording_record_id          	int4 NULL,
            source_observation_document_id       varchar(24) NOT NULL,  
	PRIMARY KEY(anuran_fact_pk)
)
WITH (OIDS = FALSE, FILLFACTOR = 90)
TABLESPACE mydataspace
GO


