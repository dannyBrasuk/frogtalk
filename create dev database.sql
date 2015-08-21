-- create the development database.  use to create both the EDW and it's ETL

DROP DATABASE IF EXISTS frogtalk;  
GO
CREATE DATABASE frogtalk
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'en_US.UTF-8'
       LC_CTYPE = 'en_US.UTF-8'
       CONNECTION LIMIT = -1;
GO
GRANT CONNECT, TEMPORARY ON DATABASE frogtalk TO public;
GRANT ALL ON DATABASE frogtalk TO postgres;
GRANT ALL ON DATABASE frogtalk TO danny;
GO
