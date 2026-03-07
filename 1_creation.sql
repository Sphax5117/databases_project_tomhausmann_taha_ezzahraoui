CREATE SCHEMA IF NOT EXISTS Dune;
USE Dune;

CREATE TABLE HARVESTING_SECTOR(
   ms_ID VARCHAR(50),
   ms_latitude DECIMAL(18,15),
   ms_long DECIMAL(18,15),
   ms_surface_temp VARCHAR(50),
   PRIMARY KEY(ms_ID)
);

CREATE TABLE CREW(
   cs_ID VARCHAR(50),
   cs_headcount_start INT,
   cs_casualties VARCHAR(50),
   cs_smuggling_detected BOOLEAN,
   cs_disciplinary_action_log VARCHAR(200),
   PRIMARY KEY(cs_ID)
);

CREATE TABLE SPOTTER(
   sp_ID VARCHAR(50),
   PRIMARY KEY(sp_ID)
);

CREATE TABLE CARRYALL(
   ca_ID VARCHAR(50),
   PRIMARY KEY(ca_ID)
);

CREATE TABLE REFINERY(
   ref_facility_ID VARCHAR(50),
   PRIMARY KEY(ref_facility_ID)
);

CREATE TABLE IMPERIUM(
   imp_id INT AUTO_INCREMENT,
   imp_target_amount DECIMAL(15,2),
   imp_market_value DECIMAL(15,2),
   PRIMARY KEY(imp_id)
);

-- 3. CHILD TABLES (Referential Integrity)
CREATE TABLE CREW_MEMBER(
   member_id INT AUTO_INCREMENT,
   member_name VARCHAR(50),
   member_id_commander INT,
   cs_ID VARCHAR(50) NOT NULL,
   PRIMARY KEY(member_id),
   FOREIGN KEY(member_id_commander) REFERENCES CREW_MEMBER(member_id) ON DELETE SET NULL, -- if the commander is deleted, we set the crew's commander value to NULL
   FOREIGN KEY(cs_ID) REFERENCES CREW(cs_ID) ON DELETE CASCADE -- if a crew is deleted, we deleted all of his members
);

CREATE TABLE HARVESTER(
   harv_ID INT AUTO_INCREMENT,
   harv_model VARCHAR(50),
   harv_hull_integrity INT,
   harv_max_storage DECIMAL(15,2),
   harv_maintenance_request_id VARCHAR(50),
   cs_ID VARCHAR(50) NOT NULL,
   ms_ID VARCHAR(50),
   PRIMARY KEY(harv_ID),
   UNIQUE(cs_ID), -- only one crew per harvester
   FOREIGN KEY(cs_ID) REFERENCES CREW(cs_ID) ON DELETE RESTRICT,
   FOREIGN KEY(ms_ID) REFERENCES HARVESTING_SECTOR(ms_ID) ON DELETE SET NULL
);



CREATE TABLE REFINING_BATCH(
   harv_ID INT,
   batch_id VARCHAR(50),
   batch_date VARCHAR(50), -- This is not a date field, because, Dune is set 10000 years later from our time (which MySQL doesn't like)
   batch_purity_rating VARCHAR(50),
   batch_raw_aggregate DECIMAL(15,2),
   batch_spice_output VARCHAR(50),
   batch_value DECIMAL(15,2),
   imp_id INT NOT NULL,
   ref_facility_ID VARCHAR(50) NOT NULL,
   PRIMARY KEY(harv_ID, batch_id),
   FOREIGN KEY(harv_ID) REFERENCES HARVESTER(harv_ID) ON DELETE CASCADE, -- if we delete a harvester, the associated batches are deleted
   FOREIGN KEY(imp_id) REFERENCES IMPERIUM(imp_id) ON DELETE RESTRICT,-- can't delete imperium record; without deleting batches
   FOREIGN KEY(ref_facility_ID) REFERENCES REFINERY(ref_facility_ID) ON DELETE RESTRICT -- as long as there is a batch, we can't delete the refinery
);

CREATE TABLE lift(
   harv_ID INT,
   ca_ID VARCHAR(50),
   ca_evacuation_ROS VARCHAR(50),
   ca_fuel_consumed DECIMAL(15,2),
   PRIMARY KEY(harv_ID, ca_ID),
   FOREIGN KEY(harv_ID) REFERENCES HARVESTER(harv_ID) ON DELETE CASCADE, --
   FOREIGN KEY(ca_ID) REFERENCES CARRYALL(ca_ID) ON DELETE CASCADE
);

CREATE TABLE monitors(
   harv_ID INT,
   sp_ID VARCHAR(50),
   sp_seismic_magnitude VARCHAR(50),
   sp_worm_proximity_alarm BOOLEAN,
   sp_time_to_worm_impact VARCHAR(50),
   PRIMARY KEY(harv_ID, sp_ID),
   FOREIGN KEY(harv_ID) REFERENCES HARVESTER(harv_ID) ON DELETE CASCADE,
   FOREIGN KEY(sp_ID) REFERENCES SPOTTER(sp_ID) ON DELETE CASCADE
);