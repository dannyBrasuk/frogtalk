/*

After changes to NoSQL collections are downloaded to PostGres Extract schema,
split off the sites and habitats records.

*/
drop table if exists trnfm.site_habitat cascade;

create table trnfm.site_habitat
(
	site_habitat_pk int not null,

	primary key (site_habitat_pk) with with (fillfactor=90) using indexspace tablespace myIndexSpace
)
	with (fillfactor=90)
	tablespace myDataSpace
	;