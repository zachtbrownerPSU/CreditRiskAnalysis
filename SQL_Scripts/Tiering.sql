SELECT 
    CASE 
        WHEN Final_Risk_Score >= 90 THEN '90-100 (Critical)'
        WHEN Final_Risk_Score >= 70 THEN '70-89 (High)'
        WHEN Final_Risk_Score >= 40 THEN '40-69 (Medium)'
        ELSE '0-39 (Low)'
    END AS Risk_Tier,
    COUNT(*) AS Total_Applicants,
    SUM(CAST(TARGET AS INT)) AS Total_Defaults,
    ROUND(AVG(CAST(TARGET AS FLOAT)) * 100, 2) AS Default_Rate_Pct
FROM (
    -- Your Final Scoring Logic here
    SELECT 
        V.TARGET,
        (
            CASE WHEN V.Rejection_Rate > 0.5 THEN 25 WHEN V.Rejection_Rate > 0 THEN 15 ELSE 0 END +
            CASE WHEN V.Payment_Gap > 20000 THEN 45 WHEN V.Payment_Gap > 5000 THEN 30 WHEN V.Payment_Gap > 0 THEN 20 WHEN V.Payment_Gap > -5000 THEN 10 ELSE 0 END +
            CASE WHEN V.OCCUPATION_TYPE IN ('Low-skill Laborers', 'Drivers', 'Waiters/barmen staff', 'Laborers', 'Cooking staff', 'Security staff') THEN 20
                 WHEN V.OCCUPATION_TYPE IN ('Managers', 'High skill tech staff', 'Accountants') THEN 5 ELSE 10 END +
            CASE WHEN V.External_Utilization > 1.0 THEN 10 WHEN V.External_Utilization > 0.50 THEN 7 WHEN V.External_Utilization > 0.35 THEN 4 ELSE 0 END
        ) AS Final_Risk_Score
    FROM Analytics.Applicant_Risk_Features V
) AS ScoredData
GROUP BY 
    CASE 
        WHEN Final_Risk_Score >= 90 THEN '90-100 (Critical)'
        WHEN Final_Risk_Score >= 70 THEN '70-89 (High)'
        WHEN Final_Risk_Score >= 40 THEN '40-69 (Medium)'
        ELSE '0-39 (Low)'
    END
ORDER BY MIN(Final_Risk_Score) DESC;