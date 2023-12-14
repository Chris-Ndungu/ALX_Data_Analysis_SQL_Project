SELECT 
	assigned_employee_id ,
	employee_name ,
	email ,
	concat(lower(REPLACE(employee_name, ' ', '.')), '@ndogowater.gov') AS new_email
FROM md_water_services.employee;

SELECT * FROM md_water_services.employee;

SELECT phone_number,
	LENGTH(phone_number)
FROM md_water_services.employee;

SELECT phone_number,
	LENGTH(rtrim(phone_number))
FROM md_water_services.employee;

UPDATE md_water_services.employee 
SET phone_number = rtrim(phone_number);

SELECT * FROM md_water_services.employee;


SELECT 
	town_name ,
	count(town_name) 
FROM md_water_services.employee
GROUP BY town_name 
ORDER BY count(town_name) DESC;

-- Most field visits
SELECT * FROM md_water_services.employee;

SELECT * FROM md_water_services.visits;

SELECT assigned_employee_id , 
	sum(visit_count )
FROM md_water_services.visits 
GROUP BY assigned_employee_id 
ORDER BY sum(visit_count)  DESC ;

SELECT 
	employee_name ,
	phone_number ,
	email 
FROM md_water_services.employee 
WHERE assigned_employee_id IN (1, 30, 34);

-- Analysing Location
SELECT * FROM md_water_services.location;

SELECT 
	town_name,
	count(town_name)
FROM md_water_services.location 
GROUP BY town_name 
ORDER BY count(town_name) DESC;

SELECT 
	province_name ,
	count(province_name) AS 'Number of Records' 
FROM md_water_services.location 
GROUP BY province_name 
ORDER BY count(province_name) DESC;

SELECT 
	province_name,
	town_name,
	count(town_name) AS records_per_town
FROM md_water_services.location
GROUP BY province_name, town_name
ORDER BY province_name DESC ;

SELECT 
location_type,
count(location_type) 
FROM md_water_services.location
GROUP BY location_type
ORDER  BY count(location_type) DESC ;

SELECT 
round(23740/(23740+15910)*100);

SELECT
	sum(number_of_people_served) AS Total_number_of_people_served
FROM md_water_services.water_source ;

SELECT 
type_of_water_source,
count(type_of_water_source)
FROM md_water_services.water_source
GROUP BY type_of_water_source ;

SELECT 
	type_of_water_source,
	round(avg(number_of_people_served))
	FROM md_water_services.water_source
	GROUP BY type_of_water_source ;

SELECT 
	type_of_water_source,
	sum(number_of_people_served) 
FROM md_water_services.water_source
GROUP BY type_of_water_source
ORDER BY sum(number_of_people_served) DESC ;

SELECT 
	type_of_water_source,
	round(sum(number_of_people_served)/27628140*100) AS percentage_people_per_source
FROM md_water_services.water_source
GROUP BY type_of_water_source 
ORDER BY percentage_people_per_source DESC;

-- Analysing queues
SELECT
	TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
	-- Sunday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
		ELSE NULL
	END
		),0) AS Sunday,
	-- Monday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue
		ELSE NULL
	END
		),0) AS Monday,
	-- Tuesday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Tuesday' THEN time_in_queue
		ELSE NULL
	END
		),0) AS Tuesday,	
	-- Wednesday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Wednesday' THEN time_in_queue
		ELSE NULL
	END
		),0) AS Wednesday,
	-- Thursday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Thursday' THEN time_in_queue
		ELSE NULL
	END
		),0) AS Thursday,
	-- Friday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Friday' THEN time_in_queue
		ELSE NULL
	END
		),0) AS Friday,
	-- Saturday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Saturday' THEN time_in_queue
		ELSE NULL
	END
		),0) AS Saturday
FROM
	md_water_services.visits
WHERE
	time_in_queue != 0 -- this excludes other sources with 0 queue times
GROUP BY
	hour_of_day
ORDER BY
	hour_of_day;

SELECT * FROM md_water_services.visits ORDER BY time_of_record ;
SELECT time_of_record , TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day 
FROM md_water_services.visits
ORDER BY hour_of_day ;

/*  MCQ */
-- 1
SELECT CONCAT(monthname(time_of_record), " ", day(time_of_record), ", ", year(time_of_record))
FROM md_water_services.visits;

-- 2
SELECT
name,
`year` ,
wat_bas_r ,
wat_bas_r - LAG(wat_bas_r) OVER (PARTITION BY (name) ORDER BY (`year`)) 
FROM 
md_water_services.global_water_access
ORDER BY
name;

-- 3
SELECT * FROM md_water_services.visits;

SELECT 
	assigned_employee_id ,
	count(visit_count) 
FROM md_water_services.visits 
GROUP BY assigned_employee_id 
ORDER BY count(visit_count);

SELECT 
	employee_name 
FROM md_water_services.employee 
WHERE assigned_employee_id IN (20,22);

-- 4
SELECT count(DISTINCT location_id) FROM md_water_services.visits;

SELECT 
    location_id,
    time_in_queue,
    AVG(time_in_queue) OVER (PARTITION BY location_id ORDER BY visit_count) AS total_avg_queue_time
FROM 
    md_water_services.visits
WHERE 
visit_count > 1 -- Only shared taps were visited > 1
ORDER BY 
    location_id, time_of_record;
   
-- 6
SELECT count(employee_name  )
FROM md_water_services.employee
WHERE town_name ='Dahabu';

-- 7
SELECT count(employee_name) 
FROM md_water_services.employee 
WHERE province_name = 'Kilimani'
AND town_name = 'Harare';

-- 8 
SELECT * FROM md_water_services.water_source;
SELECT avg(number_of_people_served)  FROM md_water_services.water_source 
WHERE type_of_water_source = 'well';

-- 9
SELECT DISTINCT type_of_water_source 
FROM md_water_services.water_source;
SELECT
	SUM(number_of_people_served) AS population_served
FROM
	md_water_services.water_source
WHERE type_of_water_source LIKE "%tap%";

-- 10
SELECT
	TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
	-- Sunday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
		ELSE NULL
	END
		),0) AS Sunday,
	-- Monday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue
		ELSE NULL
	END
		),0) AS Monday,
	-- Tuesday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Tuesday' THEN time_in_queue
		ELSE NULL
	END
		),0) AS Tuesday,	
	-- Wednesday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Wednesday' THEN time_in_queue
		ELSE NULL
	END
		),0) AS Wednesday,
	-- Thursday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Thursday' THEN time_in_queue
		ELSE NULL
	END
		),0) AS Thursday,
	-- Friday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Friday' THEN time_in_queue
		ELSE NULL
	END
		),0) AS Friday,
	-- Saturday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Saturday' THEN time_in_queue
		ELSE NULL
	END
		),0) AS Saturday
FROM
	md_water_services.visits
WHERE
	time_in_queue != 0 -- this excludes other sources with 0 queue times
GROUP BY
	hour_of_day
ORDER BY
	hour_of_day;