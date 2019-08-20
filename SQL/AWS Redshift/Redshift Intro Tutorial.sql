-- Create table
CREATE TABLE flights (
  year           smallint,
  month          smallint,
  day            smallint,
  carrier        varchar(80) DISTKEY,
  origin         char(3),
  dest           char(3),
  aircraft_code  char(3),
  miles          int,
  departures     int,
  minutes        int,
  seats          int,
  passengers     int,
  freight_pounds int
);
CREATE TABLE aircraft (
  aircraft_code CHAR(3) SORTKEY,
  aircraft      VARCHAR(100)
);
CREATE TABLE airports (
  airport_code CHAR(3) SORTKEY,
  airport      varchar(100)
);
-- COPY Command to load data
COPY aircraft
FROM 's3://us-west-2-aws-training/awsu-spl/spl17-redshift/static/data/lookup_aircraft.csv'
IAM_ROLE 'arn:aws:iam::872526172707:role/Redshift-Copy-Unload'
IGNOREHEADER 1
DELIMITER ','
REMOVEQUOTES
TRUNCATECOLUMNS
REGION 'us-west-2';
COPY flights
FROM 's3://us-west-2-aws-training/awsu-spl/spl17-redshift/static/data/flights-usa'
IAM_ROLE 'arn:aws:iam::872526172707:role/Redshift-Copy-Unload'
GZIP
DELIMITER ','
REMOVEQUOTES
REGION 'us-west-2';
COPY airports
FROM 's3://us-west-2-aws-training/awsu-spl/spl17-redshift/static/data/lookup_airports.csv'
IAM_ROLE 'arn:aws:iam::872526172707:role/Redshift-Copy-Unload'
IGNOREHEADER 1
DELIMITER ','
REMOVEQUOTES
TRUNCATECOLUMNS
REGION 'us-west-2';
-- Counting
select count(*) from aircraft;
select * from aircraft limit 10;
-- Truncate
-- truncate table aircraft;
-- Grouping
select aircraft, sum(departures) as trips
from flights
  inner join aircraft on flights.aircraft_code = aircraft.aircraft_code
group by aircraft
order by trips desc
limit 10;
-- Analyze Performance | Use "Explain" to see how Redshift runs query
SET enable_result_cache_for_session TO OFF;
EXPLAIN
SELECT
  aircraft,
  SUM(departures) AS trips
FROM flights
JOIN aircraft using (aircraft_code)
GROUP BY aircraft
ORDER BY trips DESC
LIMIT 10;

-- Analyze data stored in compression
analyze compression flights;
analyze compression aircraft;
/*
  1.  Redshift stores data as columns (faster than rows based, because normally we just use a few columns per table)
  2.  "GZIP" compress data, and we can see how many percentage the data is reduced
    =>  Difference between flights and aircraft
*/
-- Create table as (CTAS)
CREATE TABLE vegas_flights
  DISTKEY (origin)
  SORTKEY (origin)
AS
SELECT
  flights.*,
  airport
FROM flights
  JOIN airports ON origin = airport_code
WHERE dest = 'LAS';
select * from vegas_flights limit 10;

-- Check disk capacity has been used
SELECT
  owner AS node,
  diskno,
  used,
  capacity,
  used/capacity::numeric * 100 as percent_used
FROM stv_partitions
WHERE host = node
ORDER BY 1, 2;
-- Check how much space has been used by each table
  --  Example: Table "flights": 1546 ~ 1.5GB
SELECT
  name,
  count(*)
FROM stv_blocklist
  JOIN (SELECT DISTINCT name, id as tbl from stv_tbl_perm) USING (tbl)
GROUP BY name;

------------------------------------------------------
-- SCD Type 2 with Redshift
select count(*) from airports;
select * from airports limit 10;
-- insert to redshift
insert into airports values ('11A', 'Vinny Testing 1A'), ('11B', 'Vinny Testing 1B');
update airports set airport = 'Vinny Testing 1B Data updated' where airport_code = '11B';
select * from airports where airport like '%Vinny%' limit 10;
