-- Create a table 
DROP TABLE IF EXISTS `auditor_report`;
CREATE TABLE `auditor_report` (
`location_id` VARCHAR(32),
`type_of_water_source` VARCHAR(64),
`true_water_source_score` int DEFAULT NULL,
`statements` VARCHAR(255)
);

-- Show the data 
select * from auditor_report;

-- Is there a difference in the scores?
select
	location_id,
    true_water_source_score
from 
	auditor_report;
    
-- Join Visit table and Auditor report table
select 
	auditor_report.location_id as audit_id,
    auditor_report.true_water_source_score,
    visits.location_id as visit_id,
    visits.record_id
from 
	auditor_report
join 
	visits 
	on auditor_report.location_id=visits.location_id;

-- Join Visit table, Auditor report table and water quality table
select 
	auditor_report.location_id,
    visits.record_id,
    auditor_report.true_water_source_score as auditor_score,
    water_quality.subjective_quality_score as employee_score
from 
	auditor_report
join 
	visits 
	on auditor_report.location_id=visits.location_id
join
	water_quality
    on visits.record_id = water_quality.record_id;
    
-- Check whether auditor's score and employee's score agree
select 
	visits.location_id,
    visits.record_id,
    auditor_report.true_water_source_score as auditor_score,
    water_quality.subjective_quality_score as employee_score
from
	auditor_report
join
	visits
on 
	auditor_report.location_id = visits.location_id
join 
	water_quality
on 
	visits.record_id = water_quality.record_id
where
	auditor_report.true_water_source_score != water_quality.subjective_quality_score
    and 
    visits.visit_count = 1
limit 10000;

-- Linking records to employees 
with Incorrect_records AS (
select 
	visits.location_id,
    visits.record_id,
    employee.employee_name,
    auditor_report.true_water_source_score as auditor_score,
    water_quality.subjective_quality_score as employee_score
from
	auditor_report
join
	visits
on 
	auditor_report.location_id = visits.location_id
join 
	water_quality
on 
	visits.record_id = water_quality.record_id
join 
	employee
on visits.assigned_employee_id = employee.assigned_employee_id
where
	auditor_report.true_water_source_score != water_quality.subjective_quality_score
    and 
    visits.visit_count = 1
) SELECT
	distinct employee_name,
    count(employee_name) as error_count
    FROM Incorrect_records
    group by employee_name
    order by count(employee_name) desc;

-- Create a view
CREATE VIEW Incorrect_records AS (
SELECT
auditor_report.location_id,
visits.record_id,
employee.employee_name,
auditor_report.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS employee_score,
auditor_report.statements AS statements
FROM
auditor_report
JOIN
visits
ON auditor_report.location_id = visits.location_id
JOIN
water_quality AS wq
ON visits.record_id = wq.record_id
JOIN
employee
ON employee.assigned_employee_id = visits.assigned_employee_id
WHERE
visits.visit_count =1
AND auditor_report.true_water_source_score != wq.subjective_quality_score);

select * from Incorrect_records;

-- Convert query error_count into a CTE
WITH error_count AS ( -- This CTE calculates the number of mistakes each employee made
SELECT
employee_name,
COUNT(employee_name) AS number_of_mistakes
FROM
Incorrect_records
/*
Incorrect_records is a view that joins the audit report to the database
for records where the auditor and
employees scores are different*/
GROUP BY
employee_name)
-- Query
SELECT * FROM error_count
order by number_of_mistakes desc;

with suspect_list as ( 
select *
from 
Incorrect_records
where 
statements = "“Suspicion coloured villagers\' descriptions of an official's aloof demeanour and apparent laziness. 
The reference to cash transactions casts doubt on their motives.”"


) 
select * from suspect_list;

WITH error_count AS ( -- This CTE calculates the number of mistakes each employee made
SELECT
employee_name,
COUNT(employee_name) AS number_of_mistakes
FROM
Incorrect_records
/*
Incorrect_records is a view that joins the audit report to the database
for records where the auditor and
employees scores are different*/
GROUP BY
employee_name),
suspect_list AS (-- This CTE SELECTS the employees with above−average mistakes
SELECT
employee_name,
number_of_mistakes
FROM
error_count
WHERE
number_of_mistakes > (SELECT AVG(number_of_mistakes) FROM error_count))
-- This query filters all of the records where the "corrupt" employees gathered data.
SELECT
employee_name,
location_id,
statements
FROM
Incorrect_records
WHERE
employee_name in (SELECT employee_name FROM suspect_list);

-- ==> MCQ3
-- Q1
SELECT
    auditorRep.location_id,
    visitsTbl.record_id,
    Empl_Table.employee_name,
    auditorRep.true_water_source_score AS auditor_score,
    wq.subjective_quality_score AS employee_score
FROM auditor_report AS auditorRep
JOIN visits AS visitsTbl
ON auditorRep.location_id = visitsTbl.location_id
JOIN water_quality AS wq
ON visitsTbl.record_id = wq.record_id
JOIN employee as Empl_Table
ON Empl_Table.assigned_employee_id = visitsTbl.assigned_employee_id
order by auditorRep.location_id
limit 10000;

select distinct location_id from visits limit 100000;

-- Q2
WITH error_count AS ( -- This CTE calculates the number of mistakes each employee made
SELECT
employee_name,
COUNT(employee_name) AS number_of_mistakes
FROM
Incorrect_records
/*
Incorrect_records is a view that joins the audit report to the database
for records where the auditor and
employees scores are different*/
GROUP BY
employee_name),
suspect_list AS (
    SELECT ec1.employee_name, ec1.number_of_mistakes
    FROM error_count ec1
    WHERE ec1.number_of_mistakes >= (
        SELECT AVG(ec2.number_of_mistakes)
        FROM error_count ec2
        WHERE ec2.employee_name = ec1.employee_name))
-- This query filters all of the records where the "corrupt" employees gathered data.
SELECT
employee_name,
location_id,
statements
FROM
Incorrect_records;

SELECT
auditorRep.location_id,
visitsTbl.record_id,
auditorRep.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS employee_score,
wq.subjective_quality_score - auditorRep.true_water_source_score  AS score_diff
FROM auditor_report AS auditorRep
JOIN visits AS visitsTbl
ON auditorRep.location_id = visitsTbl.location_id
JOIN water_quality AS wq
ON visitsTbl.record_id = wq.record_id
WHERE (wq.subjective_quality_score - auditorRep.true_water_source_score) > 9;