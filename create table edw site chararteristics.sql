/*

Characters of the site.

Type 4 mini dimension SCD, because the site characteristcs could change over time


*/

DROP TABLE IF EXISTS edw.site_characteristics_dim CASCADE;

CREATE TABLE edw.site_characteristics_dim  
(   

    site_characteristics_pk INT NOT NULL,
    site_fk INT NOT NULL,                                 --to be enforced foreign key on the site table
 
    protected_land_indicator BOOLEAN NULL,                --wildlife sancturary, national or state park, etc.
    water_source_description VARCHAR(40) NULL,            --permanent, intermittent, ehphermal
    land_use_description VARCHAR(255) NULL,
    construction_indicator BOOLEAN NULL,                  --that disturbs the site

    date_added date NOT NULL,
    date_updated date NOT NULL,
    PRIMARY KEY (site_characteristics_pk)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;

