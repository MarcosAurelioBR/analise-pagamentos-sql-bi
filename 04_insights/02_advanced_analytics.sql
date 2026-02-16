/* ETAPA 1: INSIGHTS
   OBJETIVO: Análise de Recorrência (Time-Between-Transactions).
   TÉCNICA: Window Functions (LAG) e CTEs.
*/

WITH DatasComparadas AS (
    SELECT 
        user_id,
        transaction_timestamp,
        LAG(transaction_timestamp) OVER (PARTITION BY user_id ORDER BY transaction_timestamp) AS data_anterior
    FROM vw_fact_payments_performance
    WHERE transaction_status = 'Success'
),
Intervalos AS (
    SELECT 
        user_id,
        DATEDIFF(MINUTE, data_anterior, transaction_timestamp) AS minutos_entre_compras
    FROM DatasComparadas
    WHERE data_anterior IS NOT NULL 
)
SELECT TOP 100
    user_id,
    CAST(AVG(CAST(minutos_entre_compras AS FLOAT)) AS DECIMAL(10,2)) AS media_minutos_recorrencia,
    COUNT(*) AS total_compras_analisadas
FROM Intervalos
GROUP BY user_id
HAVING COUNT(*) > 5 
ORDER BY media_minutos_recorrencia ASC;

-- 2. DETECÇÃO DE ANOMALIAS (OUTLIERS) POR CATEGORIA
-- Usa o Z-Score para identificar transações que estão muito fora do padrão de gasto daquela categoria.
-- Demonstra conhecimento estatístico aplicado ao SQL.
WITH Stats AS (
    SELECT 
        category_name,
        AVG(amount_value) AS avg_category,
        STDEV(amount_value) AS stdev_category
    FROM vw_fact_payments_performance
    WHERE transaction_status = 'Success'
    GROUP BY category_name
)
SELECT 
    t.transaction_id,
    t.category_name,
    t.amount_value,
    ((t.amount_value - s.avg_category) / NULLIF(s.stdev_category, 0)) AS z_score
FROM vw_fact_payments_performance t
JOIN Stats s 
    ON t.category_name = s.category_name
WHERE transaction_status = 'Success'
  AND ABS((t.amount_value - s.avg_category) / NULLIF(s.stdev_category, 0)) > 3
ORDER BY z_score DESC;

-- 3. ANÁLISE DE CRESCIMENTO MENSAL (MoM Growth)
-- Calcula o crescimento do volume financeiro mês a mês e a média móvel de 3 meses.
-- Mostra visão estratégica de crescimento de receita.
WITH MonthlyVolume AS (
    SELECT 
        YEAR(transaction_timestamp) AS trans_year,
        MONTH(transaction_timestamp) AS trans_month,
        SUM(amount_value) AS monthly_tpv
    FROM vw_fact_payments_performance
    WHERE transaction_status = 'Success'
    GROUP BY YEAR(transaction_timestamp), MONTH(transaction_timestamp)
)
SELECT 
    trans_year,
    trans_month,
    monthly_tpv,
    LAG(monthly_tpv) OVER (ORDER BY trans_year, trans_month) AS last_month_tpv,
    (monthly_tpv - LAG(monthly_tpv) OVER (ORDER BY trans_year, trans_month)) / 
        NULLIF(LAG(monthly_tpv) OVER (ORDER BY trans_year, trans_month), 0) * 100 AS mom_growth_pct,
    AVG(monthly_tpv) OVER (ORDER BY trans_year, trans_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3m
FROM MonthlyVolume;
