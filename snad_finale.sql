
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


CREATE OR REPLACE TABLE t_treti AS
WITH econom AS (
	SELECT 
		country,
		gini AS GINI_coef,
		mortaliy_under5 AS Children_deaths,
		ROUND(GDP/population, 2) AS GDP_per_person
	FROM economies e
	WHERE e.`year` = 2018
),
life_diff AS (
	SELECT 
		a.country,
		(b.life_exp_2015 - a.life_exp_1965) AS diff_in_life_expectancy
	FROM(
		SELECT 
			country,
			life_expectancy AS life_exp_1965
		FROM life_expectancy 
		WHERE `year` = 1965) AS a
	JOIN (
		SELECT 
			country,
			life_expectancy AS life_exp_2015
		FROM life_expectancy 
		WHERE `year` = 2015) AS b
	  ON a.country = b.country
)
SELECT 
	a.date,
	a.country,
	a.confirmed,
	a.tests_performed,
	a.population,
	a.Weekend_or_not,
	a.Seasons,
	a.pop_density,
	c.GDP_per_person,
	c.GINI_coef,
	c.Children_deaths,
	a.median_age_2018,
	b.diff_in_life_expectancy
FROM t_druha a
LEFT JOIN life_diff b
	ON a.country = b.country
LEFT JOIN econom c 
	ON a.country = c.country;


CREATE OR REPLACE TABLE t_cvrta AS
WITH relig AS (
	SELECT 
		r.country,
		r.religion,
		SUM(r2.population) AS population_sum,
		CASE WHEN r.religion = 'Christianity' THEN ROUND((r.population/SUM(r2.population)) * 100, 2) ELSE 0 END AS Christianity,
		CASE WHEN r.religion = 'Islam' THEN ROUND((r.population/SUM(r2.population)) * 100, 2) ELSE 0 END AS Islam,
		CASE WHEN r.religion = 'Buddhism' THEN ROUND((r.population/SUM(r2.population)) * 100, 2) ELSE 0 END AS Buddhism,
		CASE WHEN r.religion = 'Hinduism' THEN ROUND((r.population/SUM(r2.population)) * 100, 2) ELSE 0 END AS Hinduism,
		CASE WHEN r.religion = 'Judaism' THEN ROUND((r.population/SUM(r2.population)) * 100, 2) ELSE 0 END AS Judaism,
		CASE WHEN r.religion = 'Folk Religions' THEN ROUND((r.population/SUM(r2.population)) * 100, 2) ELSE 0 END AS Folk_Religions,
		CASE WHEN r.religion = 'Other Religions' THEN ROUND((r.population/SUM(r2.population)) * 100, 2) ELSE 0 END AS Other_Religions,
		CASE WHEN r.religion = 'Unaffiliated Religions' THEN ROUND((r.population/SUM(r2.population)) * 100, 2) ELSE 0 END AS Unaffiliated_Religions
	FROM religions r 
	JOIN religions r2 
		ON r.country = r2.country 
	WHERE 1=1
		AND r.`year` = 2020
		AND r2.`year` = 2020
	GROUP BY r.country, r.religion
	HAVING population_sum > 0
)
SELECT 
	a.date,
	a.country,
	a.confirmed,
	a.tests_performed,
	a.population,
	a.Weekend_or_not,
	a.Seasons,
	a.pop_density,
	a.GDP_per_person,
	a.GINI_coef,
	a.Children_deaths,
	a.median_age_2018,
	MAX(b.Christianity) AS Christianity,
	MAX(b.Islam) AS Islam,
	MAX(b.Buddhism) AS Buddhism,
	MAX(b.Hinduism) AS Hinduism,
	MAX(b.Judaism) AS Judaism,
	MAX(b.Folk_Religions) AS Folk_Religions,
	MAX(b.Other_Religions) AS Other_Religions,
	MAX(b.Unaffiliated_Religions) AS Unaffiliated_Religions,
	a.diff_in_life_expectancy
FROM t_treti a
LEFT JOIN relig b
	ON a.country = b.country
GROUP BY a.country, a.`date` ;


CREATE OR REPLACE TABLE t_final AS
WITH weath AS (
	SELECT 
		a.datum,
		a.rain_hours,
		b.day_avg_temp,
		c.max_gust
	FROM(
		SELECT 	
			CAST(date AS date) AS datum,
			COUNT(time) * 3 AS rain_hours
		FROM weather w 
		WHERE 1=1 
			AND rain > '0.0 mm'
			AND date >= '2020-01-01'
		GROUP BY date) a
	JOIN (
		SELECT 
			CAST(date AS date) AS datum,
			ROUND(AVG(temp), 2) AS day_avg_temp
		FROM weather w 
		WHERE 1=1
			AND time BETWEEN '06:00' AND '21:00'
			AND date >= '2020-01-01'
		GROUP BY `date`) b
	ON a.datum = b.datum
	JOIN (
		SELECT 
			a.datum,
			MAX(a.gust_a) AS max_gust
		FROM (
			SELECT 
				CAST(date AS date) AS datum,
				gust,
				CAST(gust AS INT) AS gust_a
			FROM weather w 
			WHERE date >= '2020-01-01') a
		GROUP BY a.datum) c
	ON a.datum = c.datum
)
SELECT 
	a.*,
	b.rain_hours,
	b.day_avg_temp,
	b.max_gust
FROM t_cvrta a 
LEFT JOIN weath b 
	ON a.date = b.datum

	
	
	