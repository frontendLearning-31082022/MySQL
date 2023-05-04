-- Полный список-сгруппировагнный
SELECT *, 
CASE
	WHEN count_kg<100
		THEN 'a_ диапазон менее  100 кг'
	WHEN count_kg>=100 && count_kg<=300
		THEN 'b_ диапазон 100-300 кг'
	WHEN count_kg>300
		THEN 'c_ диапозон более 300 кг'
	ELSE 'not intresting'
END AS Диапазон_количества
FROM sales
ORDER BY Диапазон_количества;

--подсчет сгруппированный
SELECT COUNT(*) AS items,
CASE
	WHEN count_kg<100
		THEN 'a_ диапазон менее  100 кг'
	WHEN count_kg>=100 && count_kg<=300
		THEN 'b_ диапазон 100-300 кг'
	WHEN count_kg>300
		THEN 'c_ диапозон более 300 кг'
	ELSE 'not intresting'
END AS Диапазон_количества
FROM sales
GROUP BY Диапазон_количества
ORDER BY Диапазон_количества;
