

SELECT 
	base.date,
	base.country,
	base.confirmed,
	c.population,
	ct.tests_performed 
FROM covid19_basic_differences base
LEFT JOIN countries c 
	ON base.country = c.country
LEFT JOIN covid19_tests ct 
	ON base.`date` = ct.`date` 
	AND base.country = ct.country 


-- urceni binarni promenne pro vikend
SELECT
	`date`,
	CASE WHEN WEEKDAY(`date`) IN (0,1,2,3,4) THEN 0
		 ELSE 1 END Weekend_or_not
FROM covid19_basic_differences base;

-- HDP na obyvatele
SELECT 
	country,
	`year`,
	GDP,
	population,
	ROUND(GDP/population, 2) AS na_obyvatele
FROM economies e ;

-- hustota zalidneni
SELECT 
	country,
	surface_area,
	population_density,
	ROUND(SUM(surface_area * population_density) / SUM(surface_area), 2) AS hustota_zalidneni
FROM countries c 
GROUP BY country 








