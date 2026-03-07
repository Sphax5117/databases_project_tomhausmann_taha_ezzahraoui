USE Dune;

-- 1. BASE TABLES (No Foreign Keys)

-- HARVESTING_SECTOR (Min 5 rows)
-- Constraint: latitude between -90 and 90, longitude between -180 and 180, ms_ID format ^[A-Z0-9-]+$
INSERT INTO HARVESTING_SECTOR (ms_ID, ms_latitude, ms_long, ms_surface_temp) VALUES 
('SECTOR-DEEP-DESERT-1', 15.4523, 45.1234, '140F'),
('SECTOR-SHIELD-WALL-N', 42.1005, -12.5532, '115F'),
('SECTOR-MINOR-ERG-BETA', -22.5112, 110.8876, '135F'),
('SECTOR-HAGAA-BASIN-9', 5.9921, -170.1122, '145F'),
('SECTOR-TROUGH-DELTA', -65.1111, 44.9912, '100F');

-- CREW (Min 10 rows)
-- Constraint: cs_headcount_start >= 0, cs_casualties <= cs_headcount_start
INSERT INTO CREW (cs_ID, cs_headcount_start, cs_casualties, cs_smuggling_detected, cs_disciplinary_action_log) VALUES 
('CRW-ALPHA-01', 5, '0', FALSE, 'Clear'),
('CRW-BETA-02', 4, '1', FALSE, 'Minor insubordination noted'),
('CRW-GAMMA-03', 6, '0', TRUE, 'Suspicious spice residue found in personal quarters'),
('CRW-DELTA-04', 5, '2', FALSE, 'Tragic harvester malfunction'),
('CRW-EPSILON-05', 4, '0', FALSE, 'Clear'),
('CRW-ZETA-06', 7, '0', FALSE, 'Commended for efficiency'),
('CRW-ETA-07', 5, '1', FALSE, 'Standard rotation incident'),
('CRW-THETA-08', 4, '0', TRUE, 'Guild contractor flagged for audit'),
('CRW-IOTA-09', 5, '0', FALSE, 'Clear'),
('CRW-KAPPA-10', 6, '0', FALSE, 'Clear');

-- SPOTTER (Min 5 rows)
INSERT INTO SPOTTER (sp_ID) VALUES 
('SPOTTER-BIRD-1'),
('SPOTTER-EYE-2'),
('SPOTTER-HAWK-3'),
('SPOTTER-WING-4'),
('SPOTTER-DUNE-5');

-- CARRYALL (Min 5 rows)
INSERT INTO CARRYALL (ca_ID) VALUES 
('LIFTER-HEAVY-A'),
('LIFTER-HEAVY-B'),
('LIFTER-PRIME-C'),
('LIFTER-GUILD-D'),
('LIFTER-AUX-E');

-- REFINERY (Min 5 rows)
INSERT INTO REFINERY (ref_facility_ID) VALUES 
('Arrakeen-Central'),
('Carthag-Industrial'),
('Sietch-Tabr-Outpost'),
('Smuggler-Cove-Deep'),
('Guild-Orbital-Transfer');

-- IMPERIUM (Min 5 rows)
-- Constraint: imp_target_amount > 0, imp_market_value >= 0
INSERT INTO IMPERIUM (imp_id, imp_target_amount, imp_market_value) VALUES 
(1, 15000.00, 4500000.00),
(2, 20000.00, 6200000.00),
(3, 18000.00, 5400000.00),
(4, 25000.00, 7500000.00),
(5, 10000.00, 3100000.00);


-- 2. CHILD TABLES (Level 1 Dependencies)

-- HARVESTER (Min 10 rows)
-- Constraints: harv_hull_integrity BETWEEN 0 AND 100, harv_max_storage > 0, cs_ID is UNIQUE
INSERT INTO HARVESTER (harv_ID, harv_model, harv_hull_integrity, harv_max_storage, harv_maintenance_request_id, cs_ID, ms_ID) VALUES 
(1, 'Crawler-Mk-I', 95, 1200.00, NULL, 'CRW-ALPHA-01', 'SECTOR-DEEP-DESERT-1'),
(2, 'Crawler-Mk-II', 88, 1500.00, 'REQ-099', 'CRW-BETA-02', 'SECTOR-SHIELD-WALL-N'),
(3, 'Heavy-Tread-X', 75, 2000.00, 'REQ-102', 'CRW-GAMMA-03', 'SECTOR-MINOR-ERG-BETA'),
(4, 'Crawler-Mk-I', 60, 1200.00, 'REQ-URGENT', 'CRW-DELTA-04', 'SECTOR-HAGAA-BASIN-9'),
(5, 'Guild-Spec-Harv', 100, 1800.00, NULL, 'CRW-EPSILON-05', 'SECTOR-TROUGH-DELTA'),
(6, 'Crawler-Mk-II', 92, 1500.00, NULL, 'CRW-ZETA-06', 'SECTOR-DEEP-DESERT-1'),
(7, 'Heavy-Tread-X', 81, 2000.00, 'REQ-011', 'CRW-ETA-07', 'SECTOR-SHIELD-WALL-N'),
(8, 'Smuggler-Mod-V', 70, 900.00, NULL, 'CRW-THETA-08', 'SECTOR-MINOR-ERG-BETA'),
(9, 'Crawler-Mk-I', 98, 1200.00, NULL, 'CRW-IOTA-09', 'SECTOR-HAGAA-BASIN-9'),
(10, 'Crawler-Mk-II', 85, 1500.00, 'REQ-088', 'CRW-KAPPA-10', 'SECTOR-TROUGH-DELTA');

-- CREW_MEMBER (Min 40 rows. 1 Commander per crew, 3 subordinates referencing the commander)
-- We explicitly set member_id to cleanly manage the member_id_commander foreign key relationships.

-- Crew 1 (Alpha) - Local Fremen
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES (1, 'Stilgar', NULL, 'CRW-ALPHA-01');
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES 
(2, 'Jamis', 1, 'CRW-ALPHA-01'), (3, 'Chani', 1, 'CRW-ALPHA-01'), (4, 'Otheym', 1, 'CRW-ALPHA-01');

-- Crew 2 (Beta) - House Atreides Contractors
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES (5, 'Gurney Halleck', NULL, 'CRW-BETA-02');
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES 
(6, 'Duncan Idaho', 5, 'CRW-BETA-02'), (7, 'Lanville', 5, 'CRW-BETA-02'), (8, 'Elto', 5, 'CRW-BETA-02');

-- Crew 3 (Gamma) - Guild Contractors (Suspected Smugglers)
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES (9, 'Esmar Tuek', NULL, 'CRW-GAMMA-03');
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES 
(10, 'Staban Tuek', 9, 'CRW-GAMMA-03'), (11, 'Korba', 9, 'CRW-GAMMA-03'), (12, 'Farok', 9, 'CRW-GAMMA-03');

-- Crew 4 (Delta) - Harkonnen Remnants
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES (13, 'Glossu Rabban', NULL, 'CRW-DELTA-04');
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES 
(14, 'Piter De Vries', 13, 'CRW-DELTA-04'), (15, 'Captain Iakin', 13, 'CRW-DELTA-04'), (16, 'Guard Kryubi', 13, 'CRW-DELTA-04');

-- Crew 5 (Epsilon) - Independent Specialists
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES (17, 'Liet Kynes', NULL, 'CRW-EPSILON-05');
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES 
(18, 'Shadout Mapes', 17, 'CRW-EPSILON-05'), (19, 'Harah', 17, 'CRW-EPSILON-05'), (20, 'Geoff', 17, 'CRW-EPSILON-05');

-- Crew 6 (Zeta) - Fremen Fedaykin
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES (21, 'Paul MuadDib', NULL, 'CRW-ZETA-06');
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES 
(22, 'Buer', 21, 'CRW-ZETA-06'), (23, 'Turok', 21, 'CRW-ZETA-06'), (24, 'Kael', 21, 'CRW-ZETA-06');

-- Crew 7 (Eta) - Off-World Mercenaries
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES (25, 'Vandrag', NULL, 'CRW-ETA-07');
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES 
(26, 'Sardaukar-1', 25, 'CRW-ETA-07'), (27, 'Sardaukar-2', 25, 'CRW-ETA-07'), (28, 'Sardaukar-3', 25, 'CRW-ETA-07');

-- Crew 8 (Theta) - Smuggler Ring
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES (29, 'Garm', NULL, 'CRW-THETA-08');
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES 
(30, 'Rulf', 29, 'CRW-THETA-08'), (31, 'Drisq', 29, 'CRW-THETA-08'), (32, 'Marn', 29, 'CRW-THETA-08');

-- Crew 9 (Iota) - Water Sellers
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES (33, 'Lingar Bewt', NULL, 'CRW-IOTA-09');
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES 
(34, 'Tarek', 33, 'CRW-IOTA-09'), (35, 'Varis', 33, 'CRW-IOTA-09'), (36, 'Nef', 33, 'CRW-IOTA-09');

-- Crew 10 (Kappa) - Imperial Observers
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES (37, 'Fenring', NULL, 'CRW-KAPPA-10');
INSERT INTO CREW_MEMBER (member_id, member_name, member_id_commander, cs_ID) VALUES 
(38, 'Margot', 37, 'CRW-KAPPA-10'), (39, 'Observer-A', 37, 'CRW-KAPPA-10'), (40, 'Observer-B', 37, 'CRW-KAPPA-10');


-- 3. CHILD TABLES (Level 2 Dependencies)

-- REFINING_BATCH (Min 30 rows. 3 per Harvester)
-- Constraints: batch_raw_aggregate > 0, batch_value >= 0, batch_spice_output <= batch_raw_aggregate
-- Note: Arrakeen-Central reflects low waste (Spice Output is close to Raw Aggregate).
--       Carthag-Industrial reflects high volume, high waste (Spice Output is much lower than Raw Aggregate).
INSERT INTO REFINING_BATCH (harv_ID, batch_id, batch_date, batch_purity_rating, batch_raw_aggregate, batch_spice_output, batch_value, imp_id, ref_facility_ID) VALUES 
(1, 'B-001', '10191-01-01 08:00:00', 'Grade A', 1000.00, '950.00', 250000.00, 1, 'Arrakeen-Central'),
(1, 'B-002', '10191-01-02 08:00:00', 'Grade A', 900.00, '860.00', 225000.00, 1, 'Arrakeen-Central'),
(1, 'B-003', '10191-01-03 08:00:00', 'Grade A', 1100.00, '1050.00', 275000.00, 1, 'Arrakeen-Central'),

(2, 'B-004', '10191-01-01 10:00:00', 'Grade C', 2000.00, '1200.00', 200000.00, 2, 'Carthag-Industrial'),
(2, 'B-005', '10191-01-02 10:00:00', 'Grade C', 1800.00, '1000.00', 180000.00, 2, 'Carthag-Industrial'),
(2, 'B-006', '10191-01-03 10:00:00', 'Grade C', 2200.00, '1300.00', 220000.00, 2, 'Carthag-Industrial'),

(3, 'B-007', '10191-01-01 12:00:00', 'Grade B', 1500.00, '1100.00', 190000.00, 3, 'Smuggler-Cove-Deep'),
(3, 'B-008', '10191-01-02 12:00:00', 'Grade B', 1400.00, '1050.00', 185000.00, 3, 'Smuggler-Cove-Deep'),
(3, 'B-009', '10191-01-03 12:00:00', 'Grade B', 1600.00, '1200.00', 205000.00, 3, 'Smuggler-Cove-Deep'),

(4, 'B-010', '10191-01-04 08:00:00', 'Grade C', 1900.00, '1100.00', 190000.00, 4, 'Carthag-Industrial'),
(4, 'B-011', '10191-01-05 08:00:00', 'Grade C', 2100.00, '1250.00', 215000.00, 4, 'Carthag-Industrial'),
(4, 'B-012', '10191-01-06 08:00:00', 'Grade C', 2050.00, '1200.00', 210000.00, 4, 'Carthag-Industrial'),

(5, 'B-013', '10191-01-04 10:00:00', 'Grade A', 1200.00, '1150.00', 290000.00, 5, 'Arrakeen-Central'),
(5, 'B-014', '10191-01-05 10:00:00', 'Grade A', 1150.00, '1100.00', 280000.00, 5, 'Arrakeen-Central'),
(5, 'B-015', '10191-01-06 10:00:00', 'Grade A', 1250.00, '1190.00', 295000.00, 5, 'Arrakeen-Central'),

(6, 'B-016', '10191-01-07 08:00:00', 'Grade B', 1300.00, '1100.00', 210000.00, 1, 'Sietch-Tabr-Outpost'),
(6, 'B-017', '10191-01-08 08:00:00', 'Grade B', 1400.00, '1200.00', 220000.00, 1, 'Sietch-Tabr-Outpost'),
(6, 'B-018', '10191-01-09 08:00:00', 'Grade B', 1350.00, '1150.00', 215000.00, 1, 'Sietch-Tabr-Outpost'),

(7, 'B-019', '10191-01-07 10:00:00', 'Grade C', 2500.00, '1500.00', 250000.00, 2, 'Carthag-Industrial'),
(7, 'B-020', '10191-01-08 10:00:00', 'Grade C', 2400.00, '1400.00', 240000.00, 2, 'Carthag-Industrial'),
(7, 'B-021', '10191-01-09 10:00:00', 'Grade C', 2600.00, '1550.00', 260000.00, 2, 'Carthag-Industrial'),

(8, 'B-022', '10191-01-10 08:00:00', 'Grade D', 800.00, '400.00', 80000.00, 3, 'Smuggler-Cove-Deep'),
(8, 'B-023', '10191-01-11 08:00:00', 'Grade D', 850.00, '420.00', 85000.00, 3, 'Smuggler-Cove-Deep'),
(8, 'B-024', '10191-01-12 08:00:00', 'Grade D', 900.00, '450.00', 90000.00, 3, 'Smuggler-Cove-Deep'),

(9, 'B-025', '10191-01-10 10:00:00', 'Grade A', 1050.00, '1000.00', 260000.00, 4, 'Arrakeen-Central'),
(9, 'B-026', '10191-01-11 10:00:00', 'Grade A', 1100.00, '1050.00', 270000.00, 4, 'Arrakeen-Central'),
(9, 'B-027', '10191-01-12 10:00:00', 'Grade A', 950.00, '900.00', 240000.00, 4, 'Arrakeen-Central'),

(10, 'B-028', '10191-01-13 08:00:00', 'Grade B', 1450.00, '1200.00', 220000.00, 5, 'Sietch-Tabr-Outpost'),
(10, 'B-029', '10191-01-14 08:00:00', 'Grade B', 1500.00, '1250.00', 230000.00, 5, 'Sietch-Tabr-Outpost'),
(10, 'B-030', '10191-01-15 08:00:00', 'Grade B', 1400.00, '1150.00', 210000.00, 5, 'Sietch-Tabr-Outpost');

-- lift (Min 20 rows. 2 lifts per harvester)
-- Constraint: ca_fuel_consumed >= 0
INSERT INTO lift (harv_ID, ca_ID, ca_evacuation_ROS, ca_fuel_consumed) VALUES 
(1, 'LIFTER-HEAVY-A', 'Successful-Standard', 450.50),
(1, 'LIFTER-PRIME-C', 'Successful-Emergency', 600.00),
(2, 'LIFTER-HEAVY-B', 'Successful-Standard', 420.00),
(2, 'LIFTER-GUILD-D', 'Aborted-Dust-Storm', 150.25),
(3, 'LIFTER-AUX-E', 'Successful-Standard', 380.00),
(3, 'LIFTER-HEAVY-A', 'Successful-Emergency', 550.00),
(4, 'LIFTER-HEAVY-B', 'Failed-Hull-Breach', 200.00),
(4, 'LIFTER-PRIME-C', 'Successful-Recovery', 750.00),
(5, 'LIFTER-GUILD-D', 'Successful-Standard', 500.00),
(5, 'LIFTER-AUX-E', 'Successful-Standard', 480.00),
(6, 'LIFTER-HEAVY-A', 'Successful-Standard', 460.00),
(6, 'LIFTER-HEAVY-B', 'Successful-Emergency', 620.00),
(7, 'LIFTER-PRIME-C', 'Successful-Standard', 440.00),
(7, 'LIFTER-GUILD-D', 'Successful-Standard', 490.00),
(8, 'LIFTER-AUX-E', 'Successful-Evasive', 800.00),
(8, 'LIFTER-HEAVY-A', 'Successful-Standard', 410.00),
(9, 'LIFTER-HEAVY-B', 'Successful-Standard', 430.00),
(9, 'LIFTER-PRIME-C', 'Successful-Emergency', 590.00),
(10, 'LIFTER-GUILD-D', 'Successful-Standard', 475.00),
(10, 'LIFTER-AUX-E', 'Successful-Standard', 465.00);

-- monitors (Min 20 rows. 2 monitors per harvester)
INSERT INTO monitors (harv_ID, sp_ID, sp_seismic_magnitude, sp_worm_proximity_alarm, sp_time_to_worm_impact) VALUES 
(1, 'SPOTTER-BIRD-1', 'Low', FALSE, 'N/A'),
(1, 'SPOTTER-EYE-2', 'High', TRUE, '2 mins'),
(2, 'SPOTTER-HAWK-3', 'Medium', FALSE, 'N/A'),
(2, 'SPOTTER-WING-4', 'Critical', TRUE, '30 secs'),
(3, 'SPOTTER-DUNE-5', 'Low', FALSE, 'N/A'),
(3, 'SPOTTER-BIRD-1', 'High', TRUE, '4 mins'),
(4, 'SPOTTER-EYE-2', 'Critical', TRUE, '15 secs'),
(4, 'SPOTTER-HAWK-3', 'High', TRUE, '1 min'),
(5, 'SPOTTER-WING-4', 'Low', FALSE, 'N/A'),
(5, 'SPOTTER-DUNE-5', 'Low', FALSE, 'N/A'),
(6, 'SPOTTER-BIRD-1', 'Medium', FALSE, 'N/A'),
(6, 'SPOTTER-EYE-2', 'High', TRUE, '3 mins'),
(7, 'SPOTTER-HAWK-3', 'Low', FALSE, 'N/A'),
(7, 'SPOTTER-WING-4', 'Medium', FALSE, 'N/A'),
(8, 'SPOTTER-DUNE-5', 'Critical', TRUE, '45 secs'),
(8, 'SPOTTER-BIRD-1', 'High', TRUE, '2 mins'),
(9, 'SPOTTER-EYE-2', 'Low', FALSE, 'N/A'),
(9, 'SPOTTER-HAWK-3', 'Medium', FALSE, 'N/A'),
(10, 'SPOTTER-WING-4', 'Low', FALSE, 'N/A'),
(10, 'SPOTTER-DUNE-5', 'High', TRUE, '5 mins');


