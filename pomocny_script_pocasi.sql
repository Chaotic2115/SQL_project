SELECT * FROM weather w ;

-- maximalni sila vetru v narazech
SELECT 
	date,
	city,
	MAX(gust) AS max_gust
FROM weather w 
WHERE date >= '2020-01-01'
GROUP BY `date`, city ;

-- pocet hodin nenulovych srazek
SELECT 	
	CAST(date AS date) AS datum,
	city,
	rain,
	COUNT(time) * 3 AS rain_hours
FROM weather w 
WHERE 1=1 
	AND rain > '0.0 mm'
	AND date >= '2020-01-01'
GROUP BY date, city
ORDER BY date;

-- prumerna denni teplota
SELECT 






