dad/* PROJETO: Análise de Ecossistema de Pagamentos
   ETAPA 3: MODELAGEM (STAR SCHEMA)
   OBJETIVO: Criar a visão final de dados consolidados para alimentação do Dashboard.
*/

CREATE OR ALTER VIEW vw_fact_payments_performance AS
SELECT 
    -- Dimensão Tempo
    t.transaction_timestamp,
    
    -- Dimensão Transação
    t.transaction_id,
    t.amount_value,
    t.transaction_status,
    
    -- Dimensão Usuário (Trazendo dados da View de limpeza de usuários)
    u.gender,
    u.current_age,
    u.credit_score,
    u.yearly_income,
    u.debt_to_income_ratio,
    
    -- Dimensão Localização e Estabelecimento
    t.merchant_city,
    t.merchant_state,
    m.mcc_description AS category_name
    
FROM vw_transactions_cleaned t
INNER JOIN vw_users_cleaned u ON t.user_id = u.user_id
LEFT JOIN payments_core.dbo.mcc_codes m ON t.mcc = m.mcc;
GO
