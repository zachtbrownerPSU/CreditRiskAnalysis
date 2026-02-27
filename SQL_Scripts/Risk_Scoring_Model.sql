SELECT 
    Final_Risk_Score,
    COUNT(*) AS Total_Applicants,
    SUM(CAST(TARGET AS INT)) AS Total_Defaults,
    ROUND(AVG(CAST(TARGET AS FLOAT)) * 100, 2) AS Default_Rate_Pct
FROM (
    SELECT 
        V.TARGET,
        (
            -- 1. REJECTION HISTORY (Max 25)
            -- Based on your findings: >50% rejection = 15.93% default rate
            CASE 
                WHEN V.Rejection_Rate > 0.5 THEN 25 
                WHEN V.Rejection_Rate > 0   THEN 15 
                ELSE 0 
            END +

            -- 2. PAYMENT GAP (Max 45)
            -- Primary behavioral driver
            CASE 
                WHEN V.Payment_Gap > 20000 THEN 45 
                WHEN V.Payment_Gap > 5000  THEN 30 
                WHEN V.Payment_Gap > 0     THEN 20 
                WHEN V.Payment_Gap > -5000 THEN 10 
                ELSE 0 
            END +

            -- 3. OCCUPATION RISK (Max 20)
            CASE 
                WHEN V.OCCUPATION_TYPE IN ('Low-skill Laborers', 'Drivers', 'Waiters/barmen staff', 'Laborers', 'Cooking staff', 'Security staff') THEN 20
                WHEN V.OCCUPATION_TYPE IN ('Managers', 'High skill tech staff', 'Accountants') THEN 5
                ELSE 10 
            END +

            -- 4. UTILIZATION (Max 10)
            CASE 
                WHEN V.External_Utilization > 1.0  THEN 10 
                WHEN V.External_Utilization > 0.50 THEN 7 
                WHEN V.External_Utilization > 0.35 THEN 4 
                ELSE 0 
            END
        ) AS Final_Risk_Score
    FROM Analytics.Applicant_Risk_Features V
) AS ScoredData
GROUP BY Final_Risk_Score
ORDER BY Final_Risk_Score DESC;