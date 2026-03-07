-- logical lattitude and longitude

ALTER TABLE HARVESTING_SECTOR 
ADD CONSTRAINT ck_latitude_range CHECK (ms_latitude BETWEEN -90 AND 90),
ADD CONSTRAINT ck_longitude_range CHECK (ms_long BETWEEN -180 AND 180);


-- You can't start a mission with negative people
ALTER TABLE CREW
ADD CONSTRAINT ck_crew_positive_start CHECK (cs_headcount_start >= 0);


ALTER TABLE IMPERIUM
-- target amount can't be negative or 0
ADD CONSTRAINT ck_imperium_target_positive CHECK (imp_target_amount > 0),
-- market value can't be negative
ADD CONSTRAINT ck_market_value_non_negative CHECK (imp_market_value >= 0);



ALTER TABLE HARVESTER
-- Hull integrity is a percentage ( so it can't be more than 100 and less than 0)
ADD CONSTRAINT ck_harv_hull_integrity CHECK (harv_hull_integrity BETWEEN 0 AND 100),
-- Storage capacity must exist and positive so the harvester can collect
ADD CONSTRAINT ck_harv_storage_positive CHECK (harv_max_storage > 0);

ALTER TABLE REFINING_BATCH
-- Ensure we aren't refining nothing
ADD CONSTRAINT ck_batch_raw_aggregate_positive CHECK (batch_raw_aggregate > 0),
-- The value of the batch cannot be negative
ADD CONSTRAINT ck_batch_value_non_negative CHECK (batch_value >= 0);

ALTER TABLE lift
-- we can't consume negative fuel
ADD CONSTRAINT ck_fuel_consumed_non_negative CHECK (ca_fuel_consumed >= 0);

ALTER TABLE CREW 
ADD CONSTRAINT ck_casualties_limit 
CHECK (cs_casualties <= cs_headcount_start); -- we cannot have more casualties than people you started out with

ALTER TABLE REFINING_BATCH 
ADD CONSTRAINT ck_output_less_than_input 
CHECK (batch_spice_output <= batch_raw_aggregate); -- we cannot have more spice than raw yield 

ALTER TABLE HARVESTING_SECTOR 
ADD CONSTRAINT ck_sector_format 
CHECK (ms_ID REGEXP '^[A-Z0-9-]+$'); -- ensure that the grid code follows a specific format






