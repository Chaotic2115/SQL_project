-- prejmenovani rozdilnych nazvu zemi v tabulkach covid diff a covid tests	
	
SELECT 
	CASE WHEN country = 'Czechia' THEN 'Czech Republic'
		 WHEN country = 'US' THEN 'United States'
		 WHEN country = 'Russia' THEN 'Russian Federation'
		 ELSE country END AS country
FROM covid19_basic_differences ;


SELECT
	CASE WHEN country = 'Russia' THEN 'Russian Federation'
		 ELSE country END AS country
FROM covid19_tests ;

-- vytvoreni prvniho spojeni promenych z diff a tests
CREATE OR REPLACE TABLE t_prvni AS 
	WITH covid19_diff AS (
		SELECT 
			`date`,
			CASE WHEN country = 'Czechia' THEN 'Czech Republic'
				 WHEN country = 'US' THEN 'United States'
				 WHEN country = 'Russia' THEN 'Russian Federation'
				 ELSE country END AS country,
			confirmed,
			CASE WHEN WEEKDAY(`date`) IN (0,1,2,3,4) THEN 0
				 ELSE 1 END Weekend_or_not,
			CASE WHEN `date` BETWEEN '2020-03-21' AND '2020-06-20' THEN 1
				 WHEN `date` BETWEEN '2020-06-21' AND '2020-09-22' THEN 2
				 WHEN `date` BETWEEN '2020-09-23' AND '2020-12-22' THEN 3 
				 WHEN `date` BETWEEN '2021-03-21' AND '2021-05-23' THEN 1 
				 ELSE 0 END AS Seasons
		FROM covid19_basic_differences 
	),
	covid19_t AS (
		SELECT
			`date`,
			tests_performed,
			CASE WHEN country = 'Russia' THEN 'Russian Federation'
				 ELSE country END AS country
		FROM covid19_tests
	)
	SELECT
		a.date,
		a.country,
		a.confirmed,
		b.tests_performed,
		a.Weekend_or_not,
		a.Seasons
	FROM covid19_diff a
	LEFT JOIN covid19_t b
		ON a.country = b.country 
		AND a.`date` = b.`date` 
	ORDER BY a.country, a.`date`;
	
-- pripojeni countries a promennych z countries - nahled
WITH country AS (
	SELECT 
		c.country,
		c.population,
		c.median_age_2018,
		ROUND(SUM(surface_area * population_density) / SUM(surface_area), 2) AS pop_density
	FROM countries c 
	GROUP BY c.country 
)
SELECT 
	a.*,
	b.population,
	b.median_age_2018,
	b.pop_density
FROM t_prvni a 
LEFT JOIN country b
	ON a.country = b.country
	
-- pripojeni countries a promennych z countries
CREATE OR REPLACE TABLE t_druha AS 
WITH covid19_diff AS (
	SELECT 
		`date`,
		CASE WHEN country = 'Czechia' THEN 'Czech Republic'
			 WHEN country = 'US' THEN 'United States'
			 WHEN country = 'Russia' THEN 'Russian Federation'
			 ELSE country END AS country,
		confirmed,
		CASE WHEN WEEKDAY(`date`) IN (0,1,2,3,4) THEN 0
			 ELSE 1 END Weekend_or_not,
		CASE WHEN `date` BETWEEN '2020-03-21' AND '2020-06-20' THEN 1
			 WHEN `date` BETWEEN '2020-06-21' AND '2020-09-22' THEN 2
			 WHEN `date` BETWEEN '2020-09-23' AND '2020-12-22' THEN 3 
			 WHEN `date` BETWEEN '2021-03-21' AND '2021-05-23' THEN 1 
			 ELSE 0 END AS Seasons
	FROM covid19_basic_differences 
),
covid19_t AS (
	SELECT
		`date`,
		tests_performed,
		CASE WHEN country = 'Russia' THEN 'Russian Federation'
			 ELSE country END AS country
	FROM covid19_tests
), 
first_conn AS (
	SELECT
		a.date,
		a.country,
		a.confirmed,
		b.tests_performed,
		a.Weekend_or_not,
		a.Seasons
	FROM covid19_diff a
	LEFT JOIN covid19_t b
		ON a.country = b.country 
		AND a.`date` = b.`date` 
	ORDER BY a.country, a.`date`
),
country AS (
	SELECT 
		country,
		population,
		median_age_2018,
		ROUND(SUM(surface_area * population_density) / SUM(surface_area), 2) AS pop_density
	FROM countries c 
	GROUP BY c.country
)
SELECT 
	a.date,
	a.country,
	a.confirmed,
	a.tests_performed,
	b.population,
	a.Weekend_or_not,
	a.Seasons,
	b.pop_density,
	b.median_age_2018
FROM first_conn a
LEFT JOIN country b
	ON a.country = b.country
ORDER BY a.country, a.date;

	
	
-- odebrat order by v tabulce first conn? 
SELECT * FROM t_druha td ORDER BY country, `date` 
	
	
	
	
	
	


