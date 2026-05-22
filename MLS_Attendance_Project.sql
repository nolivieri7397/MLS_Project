SELECT 
	Squad,
    year,
    wins,
    Avg_Home_Attendance
FROM MLS.mls_data
ORDER BY Avg_Home_Attendance DESC
LIMIT 10;

SELECT 
    Squad,
    ROUND(AVG(Avg_Home_Attendance), 0) AS Avg_Attendance,
    COUNT(Year) AS Seasons
FROM mls.mls_data
GROUP BY Squad
HAVING COUNT(Year) >= 0
ORDER BY Avg_Attendance DESC;