/* PROJETO: Análise de Ecossistema de Pagamentos
   OBJETIVO: Limpeza de dados demográficos e financeiros dos clientes.
*/
CREATE OR ALTER VIEW vw_users_cleaned AS
WITH base AS (
    SELECT
        CAST(user_id AS INT) AS user_id,
        current_age,
        gender,
        credit_score,
        CAST(REPLACE(REPLACE(yearly_income, '$', ''), ',', '') AS DECIMAL(18,2)) AS yearly_income,
        CAST(REPLACE(REPLACE(total_debt, '$', ''), ',', '') AS DECIMAL(18,2)) AS total_debt
    FROM payments_core.dbo.users_raw
)

SELECT *,
    CASE 
        WHEN yearly_income > 0 
        THEN total_debt / yearly_income
        ELSE 0
    END AS debt_to_income_ratio
FROM base;
