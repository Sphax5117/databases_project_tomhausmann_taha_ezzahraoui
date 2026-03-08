/*
  Dune / House Harkonnen Spice Operations Database
  Target: Baron Vladimir Harkonnen, Siridar-Governor of Arrakis
  Purpose: Operations Monitoring, Efficiency Auditing, and Security Inspection
*/

-- 1. Get a list of all active harvester models (No duplicates)
SELECT DISTINCT harv_model 
FROM HARVESTER;

-- 2. Identify batch rating/value for facilities tied to Smugglers or Industrial sectors
SELECT batch_purity_rating, batch_value
FROM REFINING_BATCH
WHERE ref_facility_ID LIKE '%Smuggler%' 
   OR ref_facility_ID LIKE '%Industrial%';

-- 3. Identify harv_model and integrity for units failing (60-80% hull)
SELECT harv_hull_integrity, harv_model
FROM HARVESTER
WHERE harv_hull_integrity BETWEEN 60 AND 80;

-- 4. Screen crew for members of the "Tuek" smuggling family
SELECT member_id, member_name, cs_id
FROM CREW_MEMBER 
WHERE member_name LIKE '%Tuek';

-- 5. Cross-examine spotter and harvester data for high seismic risk sectors
SELECT sp_id, ms_id, sp_seismic_magnitude
FROM monitors m
JOIN HARVESTER h ON h.harv_ID = m.harv_ID
WHERE sp_seismic_magnitude IN ("High", "Critical")
ORDER BY sp_seismic_magnitude;

-- 6. Identify the two specific deaths in the REQ-URGENT harvester malfunction
-- Target: The commander and the ID immediately following (commander + 1)
SELECT member_name, cs_disciplinary_action_log
FROM CREW_MEMBER CM
JOIN HARVESTER H ON CM.cs_id = H.cs_id
JOIN CREW C ON CM.cs_ID = C.cs_id
WHERE H.harv_maintenance_request_id = "REQ-URGENT" 
  AND (member_id = member_id_commander OR member_id = member_id_commander + 1);

-- 7. Imperial Quota Check: Identify batch value vs targets and the responsible commander
SELECT 
    b.batch_id, 
    b.batch_value, 
    i.imp_target_amount,
    cm.member_name AS commander_name
FROM REFINING_BATCH b 
INNER JOIN IMPERIUM i ON b.imp_id = i.imp_id
INNER JOIN HARVESTER h ON b.harv_ID = h.harv_ID
INNER JOIN CREW_MEMBER cm ON h.cs_ID = cm.cs_ID
WHERE cm.member_id_commander IS NULL;

-- 8. List all Refineries and outputs (including those with zero processed batches)
SELECT 
    r.ref_facility_ID, 
    b.batch_id, 
    b.batch_spice_output
FROM REFINERY r
LEFT JOIN REFINING_BATCH b ON r.ref_facility_ID = b.ref_facility_ID;

-- 9. List crews with zero casualties and their assigned harvesters
SELECT 
    c.cs_ID, 
    c.cs_headcount_start, 
    h.harv_model
FROM CREW c
LEFT JOIN HARVESTER h ON c.cs_ID = h.cs_ID
WHERE c.cs_casualties = '0';


-- AGGREGATION FUNCTIONS (Auditor's Report)

-- 10. Find the least efficient refinery (Lowest output/raw material ratio)
SELECT 
    ref_facility_ID,
    SUM(batch_spice_output) AS total_yield,
    SUM(batch_raw_aggregate) AS total_raw_material,
    (SUM(batch_spice_output) / SUM(batch_raw_aggregate)) * 100 AS efficiency_percentage
FROM REFINING_BATCH
GROUP BY ref_facility_ID
ORDER BY efficiency_percentage ASC
LIMIT 1;

-- 11. Rank harvesters by total spice flow
SELECT harv_ID,
       SUM(CAST(batch_spice_output AS DECIMAL(15,2))) AS total_spice_output
FROM REFINING_BATCH
GROUP BY harv_ID
ORDER BY total_spice_output DESC;

-- 12. Facilities with a waste gap > 500 (Potential theft or refining issues)
SELECT ref_facility_ID,
       AVG(batch_raw_aggregate - CAST(batch_spice_output AS DECIMAL(15,2))) AS avg_waste
FROM REFINING_BATCH
GROUP BY ref_facility_ID
HAVING AVG(batch_raw_aggregate - CAST(batch_spice_output AS DECIMAL(15,2))) > 500
ORDER BY avg_waste DESC;

-- 13. Highlight carryalls with high fuel consumption (> 550)
SELECT ca_ID,
       AVG(ca_fuel_consumed) AS avg_fuel_consumption
FROM lift
GROUP BY ca_ID
HAVING AVG(ca_fuel_consumed) > 550
ORDER BY avg_fuel_consumption DESC;

-- 14. "King Harvester" - High wealth generators (> 700,000 value)
SELECT harv_ID,
       SUM(batch_value) AS total_batch_value
FROM REFINING_BATCH
GROUP BY harv_ID
HAVING SUM(batch_value) > 700000
ORDER BY total_batch_value DESC;

-- 15. Models pushed beyond safe limits (Avg integrity < 85%)
SELECT harv_model,
       ROUND(AVG(harv_hull_integrity), 2) AS avg_hull_integrity,
       COUNT(*) AS deployed_units
FROM HARVESTER
GROUP BY harv_model
HAVING AVG(harv_hull_integrity) < 85
ORDER BY avg_hull_integrity ASC;


-- NESTED QUERIES (Security Inspector)

-- 16. Inspect harvesters operated by crews flagged for smuggling
SELECT harv_ID, harv_model, cs_ID
FROM HARVESTER
WHERE cs_ID IN (
    SELECT cs_ID
    FROM CREW
    WHERE cs_smuggling_detected = TRUE
);

-- 17. Find idle crews (Not assigned to any harvester)
SELECT cs_ID
FROM CREW
WHERE cs_ID NOT IN (
    SELECT cs_ID
    FROM HARVESTER
);

-- 18. Facilities that have handled spice from smuggling-compromised crews
SELECT DISTINCT ref_facility_ID
FROM REFINING_BATCH rb
WHERE EXISTS (
    SELECT 1
    FROM HARVESTER h
    JOIN CREW c ON h.cs_ID = c.cs_ID
    WHERE h.harv_ID = rb.harv_ID
      AND c.cs_smuggling_detected = TRUE
);

-- 19. Identify "Ghost Harvesters" that have never triggered a worm alarm
SELECT harv_ID, harv_model
FROM HARVESTER h
WHERE NOT EXISTS (
    SELECT 1
    FROM monitors m
    WHERE m.harv_ID = h.harv_ID
      AND m.sp_worm_proximity_alarm = TRUE
);

-- 20. Batches exceeding the output of the suspicious 'Smuggler-Cove-Deep' facility
SELECT harv_ID, batch_id, batch_value, ref_facility_ID
FROM REFINING_BATCH
WHERE batch_value > ANY (
    SELECT batch_value
    FROM REFINING_BATCH
    WHERE ref_facility_ID = 'Smuggler-Cove-Deep'
);

-- 21. Find harvesters whose production exceeds the total maximum production of Harvester 8
SELECT DISTINCT harv_ID
FROM REFINING_BATCH
WHERE batch_value > ALL (
    SELECT batch_value
    FROM REFINING_BATCH
    WHERE harv_ID = 8
);

-- 22. Identify "Clean" refineries (Untouched by flagged smuggling crews)
SELECT ref_facility_ID
FROM REFINERY r
WHERE NOT EXISTS (
    SELECT 1
    FROM REFINING_BATCH rb
    JOIN HARVESTER h ON rb.harv_ID = h.harv_ID
    JOIN CREW c ON h.cs_ID = c.cs_ID
    WHERE rb.ref_facility_ID = r.ref_facility_ID
      AND c.cs_smuggling_detected = TRUE
);