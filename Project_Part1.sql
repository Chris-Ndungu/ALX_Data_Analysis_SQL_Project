/* Understanding our tables in md_water_services database */
SELECT * FROM md_water_services.location;
SELECT * FROM md_water_services.visits;
SELECT * FROM md_water_services.water_source ws ;
SELECT * FROM md_water_services.data_dictionary ;


/* Dive into sources */
SELECT * FROM md_water_services.water_source ;

-- Check the types of water sources
SELECT DISTINCT type_of_water_source 
FROM md_water_services.water_source;


/* Unpack the visits to water sources */
SELECT * FROM md_water_services.visits;

-- Check records with abnormal queue time (>500)
SELECT * FROM md_water_services.visits 
WHERE time_in_queue>500
ORDER BY time_in_queue DESC ;

SELECT * FROM md_water_services.water_source 
WHERE source_id IN ('AkRu05234224','HaZa21742224','AkKi00881224','SoRu37635224','SoRu36096224');

/* Assess the quality of water sources */
SELECT * FROM md_water_services.water_quality;

-- Identify records with errors (homes with clean water source and had 2 visits)
SELECT count(record_id) 
FROM md_water_services.water_quality 
WHERE subjective_quality_score =10 AND visit_count =2;

/* Investigate pollution issues */
SELECT *
FROM md_water_services.well_pollution 
LIMIT 5;

-- Identify records with results as 'Clean' but biological > 0.01
SELECT *
FROM md_water_services.well_pollution 
WHERE results='Clean' AND biological > 0.01;

-- Identify the records wrongly labelled as 'Clean'
SELECT *
FROM md_water_services.well_pollution 
WHERE description LIKE 'Clean_%';

-- Fix the descriptions
UPDATE md_water_services.well_pollution 
SET description = 'Bacteria: E.coli'
WHERE description = 'Clean Bacteria: E. coli';

UPDATE md_water_services.well_pollution 
SET description = 'Bacteria: Giardia Lamblia'
WHERE description = 'Clean Bacteria: Giardia Lamblia';

UPDATE md_water_services.well_pollution 
SET results = 'Contaminated: Biological'
WHERE results = 'Clean' AND biological > 0.01;

/* MCQ */
SELECT address  
FROM md_water_services.employee 
WHERE employee_name = 'Bello Azibo';

SELECT * 
FROM md_water_services.employee
WHERE `position` = 'Micro Biologist';

SELECT *
FROM md_water_services.water_source 
ORDER BY number_of_people_served DESC 
LIMIT 3;

SELECT * 
FROM md_water_services.data_dictionary ;

SELECT * 
FROM md_water_services.global_water_access;

SELECT *
FROM md_water_services.employee
WHERE position = 'Civil Engineer' AND (province_name = 'Dahabu' OR address LIKE '%Avenue%');

SELECT *
FROM md_water_services.employee 
WHERE `position` = 'Field Surveyor'
AND (employee_name LIKE '% A%' OR employee_name LIKE '% M%')
AND (phone_number LIKE '%86%' OR phone_number LIKE '%11%');

SELECT *
FROM md_water_services.well_pollution
WHERE description LIKE 'Clean_%' OR results = 'Clean' AND biological < 0.01;

SELECT count(source_id)
FROM md_water_services.well_pollution 
WHERE description LIKE 'Clean_%' OR results = 'Clean' AND biological < 0.01; 

SELECT * 
FROM md_water_services.water_quality 
WHERE visit_count >= 2 AND subjective_quality_score = 10;

SELECT count(source_id)  
FROM md_water_services.well_pollution
WHERE description
IN ('Parasite: Cryptosporidium', 'biologically contaminated')
OR (results = 'Clean' AND biological > 0.01);