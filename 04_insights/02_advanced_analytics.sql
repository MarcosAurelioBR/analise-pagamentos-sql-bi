/* ETAPA 4: INSIGHTS SENIOR
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
