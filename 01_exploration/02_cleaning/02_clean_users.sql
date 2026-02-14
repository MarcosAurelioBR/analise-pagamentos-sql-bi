/* PROJETO: Análise de Ecossistema de Pagamentos
   OBJETIVO: Limpeza de dados demográficos e financeiros dos clientes.
*/

CREATE OR ALTER VIEW vw_users_cleaned AS
SELECT 
    CAST(user_id AS INT) AS user_id,
    current_age,
    gender,
    credit_score,
    
    -- Limpeza de Renda e Dívida
    CAST(REPLACE(REPLACE(yearly_income, '$', ''), ',', '') AS DECIMAL(18,2)) AS yearly_income,
    CAST(REPLACE(REPLACE(total_debt, '$', ''), ',', '') AS DECIMAL(18,2)) AS total_debt,
    
    -- Feature Engineering: Taxa de Endividamento
    CASE 
        WHEN CAST(REPLACE(REPLACE(yearly_income, '$', ''), ',', '') AS DECIMAL(18,2)) > 0 
        THEN CAST(REPLACE(REPLACE(total_debt, '$', ''), ',', '') AS DECIMAL(18,2)) / 
             CAST(REPLACE(REPLACE(yearly_income, '$', ''), ',', '') AS DECIMAL(18,2))
        ELSE 0 
    END AS debt_to_income_ratio
FROM payments_core.dbo.users_raw;
GO
