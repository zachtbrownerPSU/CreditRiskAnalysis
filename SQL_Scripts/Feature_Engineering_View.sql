ALTER VIEW Analytics.Applicant_Risk_Features AS
WITH Bureau_Totals AS (
    SELECT 
        SK_ID_CURR,
        SUM(AMT_CREDIT_SUM) AS Total_Limit,
        SUM(AMT_CREDIT_SUM_DEBT) AS Total_Owed
    FROM RawData.bureau
    GROUP BY SK_ID_CURR
),
Payment_Totals AS (
    SELECT 
        SK_ID_CURR,
        SUM(AMT_INSTALMENT) AS Total_Billed,
        SUM(AMT_PAYMENT) AS Total_Paid
    FROM RawData.installments_payments
    GROUP BY SK_ID_CURR
),
Previous_App_Stats AS (
    SELECT 
        SK_ID_CURR,
        COUNT(SK_ID_PREV) AS Total_Prev_Apps,
        SUM(CASE WHEN NAME_CONTRACT_STATUS = 'Refused' THEN 1 ELSE 0 END) AS Total_Refusals,
        CAST(SUM(CASE WHEN NAME_CONTRACT_STATUS = 'Refused' THEN 1 ELSE 0 END) AS FLOAT) / NULLIF(COUNT(SK_ID_PREV), 0) AS Rejection_Rate
    FROM RawData.previous_application
    GROUP BY SK_ID_CURR
)
SELECT 
    A.SK_ID_CURR,
    A.TARGET,
    A.OCCUPATION_TYPE,
    A.NAME_EDUCATION_TYPE,
    ISNULL(B.Total_Owed / NULLIF(B.Total_Limit, 0), 0) AS External_Utilization,
    ISNULL(P.Total_Billed - P.Total_Paid, 0) AS Payment_Gap,
    ISNULL(Prev.Total_Prev_Apps, 0) AS Total_Prev_Apps,
    ISNULL(Prev.Rejection_Rate, 0) AS Rejection_Rate
FROM RawData.application_train A
LEFT JOIN Bureau_Totals B ON A.SK_ID_CURR = B.SK_ID_CURR
LEFT JOIN Payment_Totals P ON A.SK_ID_CURR = P.SK_ID_CURR
LEFT JOIN Previous_App_Stats Prev ON A.SK_ID_CURR = Prev.SK_ID_CURR;