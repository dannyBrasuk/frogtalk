/*

In practice, w'd have multiple databsases, one for the EDW itself, and one
for the processing of the observations as they come in from the app (i.e., the ETL).

for dev and testing I'm assuming one database.

*/

--EDW

CREATE SCHEMA IF NOT EXISTS edw;
GO
CREATE SCHEMA IF NOT EXISTS stage;      --prior to merging with fact and dim tables

--ETL

GO
CREATE SCHEMA IF NOT EXISTS extr;       --extract and validation
GO
CREATE SCHEMA IF NOT EXISTS trnfm;      --transform and enhance
GO
CREATE SCHEMA IF NOT EXISTS load;       --load to edw stage; 
GO

SELECT * FROM information_schema.schemata;