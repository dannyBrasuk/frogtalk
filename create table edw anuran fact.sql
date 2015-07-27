--  Anuran "fact" table for the EDW

USE frogtalk;
GO
DROP TABLE IF EXISTS edw.anuran_fact RESTRICT;

GO

CREATE TABLE edw.anuran_fact  ( 
	anuran_fact_pk                     	SERIAL NOT NULL,
	local_datetime                     	TIMESTAMP NOT NULL,
	date_fk                            	INT NOT NULL,
	time_fk                            	INT NOT NULL,
	site_fk                            	INT NOT NULL,
	registered_observer_fk            INT NULL,
	anuran_species_fk                  	INT NOT NULL,
	anuran_calling_code_fk             INT NOT NULL,
	geographic_adminstrative_level_fk  	INT NULL,
	extraordinary_astronomical_event_fk	INT NULL,
	extraordinary_weather_event_fk     	INT NULL,
	current_weather_condition_fk       	INT NULL,
	noise_level_fk                                     INT NULL,
	construction_indicator             	BOOLEAN NULL,
	habitat_description_record_id      	INT NULL,
	comments_record_id                 	INT NULL,
	sound_recording_record_id          	INT NULL,
            source_observation_document_id       VARCHAR(24) NOT NULL,  
	PRIMARY KEY(anuran_fact_pk)    WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace
)
WITH (FILLFACTOR = 90)
TABLESPACE mydataspace
GO


