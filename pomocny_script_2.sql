SELECT * FROM religions r 

-- nabozenstvi v procentech, jeste nepredelane do sloupcu
SELECT 
	r.country,
	r.religion,
	r.population,
	SUM(r2.population) AS celk_pop,
	ROUND((r.population/SUM(r2.population)) * 100, 2) AS relig_perc
FROM religions r 
JOIN religions r2 
	ON r.country = r2.country 
WHERE 1=1
	AND r.`year` = 2020
	AND r2.`year` = 2020
GROUP BY r.country, r.religion 

-- rozdeleni nabozenstvi do sloupcu - ve finalni tabulce pouzit MAX() na kazde nabozenstvi, aby byla hodnota na kazdem radku

SELECT 
	r.country,
	r.religion,
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
GROUP BY r.country, r.religion ;










