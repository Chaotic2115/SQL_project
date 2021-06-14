


-- urceni binarni promenne pro vikend
SELECT
	`date`,
	CASE WHEN WEEKDAY(`date`) IN (0,1,2,3,4) THEN 0
		 ELSE 1 END Weekend_or_not
FROM covid19_basic_differences base;

-- rocni obdobi 0-3
SELECT 
	date,
	CASE WHEN `date` BETWEEN '2020-03-21' AND '2020-06-20' THEN 1
		 WHEN `date` BETWEEN '2020-06-21' AND '2020-09-22' THEN 2
		 WHEN `date` BETWEEN '2020-09-23' AND '2020-12-22' THEN 3 
		 WHEN `date` BETWEEN '2021-03-21' AND '2021-05-23' THEN 1 ELSE 0
	END AS Seasons
FROM covid19_basic_differences cbd;

-- HDP na obyvatele
SELECT 
	country,
	`year`,
	GDP,
	population,
	ROUND(GDP/population, 2) AS na_obyvatele
FROM economies e 
WHERE `year` = '2018';

-- hustota zalidneni - zbytecny vypocet, staci pouzit zaokrouhlenou hodnotu z tabulky
SELECT 
	country,
	surface_area,
	ROUND(population_density, 2) AS a,
	ROUND(SUM(surface_area * population_density) / SUM(surface_area), 2) AS hustota_zalidneni
FROM countries c 
GROUP BY country ;

-- GINI koef, detska umrtnost
SELECT 
	gini,
	mortaliy_under5 
FROM economies e ;

-- median veku v roce 2018
SELECT 
	country,
	median_age_2018 
FROM countries c 

-- rozdil doby doziti 1965 a 2015
SELECT 
	a.country,
	a.life_exp_1965,
	b.life_exp_2015,
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
  ON a.country = b.country;






