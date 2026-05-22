-- best attendance records--
SELECT 
	Squad,
    year,
    wins,
    Avg_Home_Attendance
FROM MLS.mls_data
ORDER BY Avg_Home_Attendance DESC
LIMIT 10;

-- Year over year attendance change --
SELECT 
    Squad, Year, Avg_Home_Attendance, Prev_Year_Attendance,
    Avg_Home_Attendance - Prev_Year_Attendance AS Attendance_Change,
    ROUND(((Avg_Home_Attendance - Prev_Year_Attendance) / Prev_Year_Attendance) * 100, 2) AS Attendance_Pct_Change
FROM (
    SELECT Squad, Year, Avg_Home_Attendance,
        LAG(Avg_Home_Attendance) OVER (PARTITION BY Squad ORDER BY Year) AS Prev_Year_Attendance
    FROM mls.mls_data
) AS subquery
WHERE Prev_Year_Attendance IS NOT NULL
ORDER BY Squad, Year;


-- avg attendance in last 5 seasons (if available)--
SELECT 
    squad,
    ROUND(AVG(Avg_Home_Attendance), 0) AS Avg_Attendance,
    COUNT(Year) AS Seasons
FROM mls.mls_data
GROUP BY squad
HAVING COUNT(Year) >= 0
ORDER BY Avg_Attendance DESC;

-- wins vs attendance correlation --
SELECT
	squad,
    ROUND(AVG(Avg_Home_Attendance), 0) AS Avg_Attendance,
	ROUND(AVG(wins),1) AS Avg_wins,
	COUNT(Year) AS Seasons
FROM mls.mls_data
GROUP BY squad
ORDER BY Avg_Attendance DESC;
-- this shows that winning teams dont just bring a crowed so does loyalty and marketing --

-- Yearly averages --
SELECT
	year,
    ROUND(AVG(Avg_Home_Attendance),1) AS League_Avg
FROM mls.mls_data
GROUP BY year
ORDER BY year DESC;

-- most under preforming teams --
SELECT
	squad,
    ROUND(AVG(wins),2) AS avg_wins,
    ROUND(AVG(Avg_Home_Attendance),0) AS Avg_Attendance
FROM mls.mls_data
GROUP BY squad
HAVING AVG(Avg_Home_Attendance) < (SELECT AVG(Avg_Home_Attendance) FROM mls.mls_data)
ORDER BY avg_wins DESC;
    
-- comapres 2021 attendance to their 2025 -- 
SELECT 
    a.Squad,
    a.Avg_Home_Attendance AS Attendance_2021,
    b.Avg_Home_Attendance AS Attendance_2025,
    b.Avg_Home_Attendance - a.Avg_Home_Attendance AS Attendance_Growth,
    ROUND(((b.Avg_Home_Attendance - a.Avg_Home_Attendance) / a.Avg_Home_Attendance) * 100, 1) AS Growth_Pct
FROM mls.mls_data a
JOIN mls.mls_data b ON a.Squad = b.Squad
WHERE a.Year = 2021 
AND b.Year = 2025
AND a.Avg_Home_Attendance > 5000
ORDER BY Growth_Pct DESC;