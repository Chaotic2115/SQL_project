SELECT * FROM weather w ;

-- maximalni sila vetru v narazech   - nejak mi to nevychazi jeste popremyslet
SELECT 
	CAST(date AS date) AS datum,
	MAX(gust) AS max_gust
FROM weather w 
WHERE date >= '2020-01-01'
GROUP BY `date`

-- pocet hodin nenulovych srazek - oprava
SELECT 	
	CAST(date AS date) AS datum,
	COUNT(time) * 3 AS rain_hours
FROM weather w 
WHERE 1=1 
	AND rain > '0.0 mm'
	AND date >= '2020-01-01'
GROUP BY date


-- prumerna denni teplota - den beru z teto tabulky cas od 6:00 do 21:00
SELECT 
	CAST(date AS date) AS datum,
	CONCAT(ROUND(AVG(temp), 2), ' °c') AS denni_prumer
FROM weather w 
WHERE 1=1
	AND time BETWEEN '06:00' AND '21:00'
	AND date >= '2020-01-01'
GROUP BY `date` 


-- pokus o spojeni
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
		CONCAT(ROUND(AVG(temp), 2), ' °c') AS day_avg_temp
	FROM weather w 
	WHERE 1=1
		AND time BETWEEN '06:00' AND '21:00'
		AND date >= '2020-01-01'
	GROUP BY `date`) b
ON a.datum = b.datum
JOIN (
	SELECT 
		CAST(date AS date) AS datum,
		MAX(gust) AS max_gust
	FROM weather w 
	WHERE date >= '2020-01-01'
	GROUP BY `date`) c
ON a.datum = c.datum





