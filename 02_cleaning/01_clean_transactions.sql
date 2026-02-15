/* PROJETO: Análise de Ecossistema de Pagamentos
   ETAPA 2: DATA CLEANING (LIMPEZA)
   OBJETIVO: Sanitize e tipagem da tabela de transações (15M+ linhas).
   NOTA: Foi utilizado o estilo 120 no CONVERT para garantir a leitura do formato ISO de data.
*/

CREATE OR ALTER VIEW vw_transactions_cleaned AS
SELECT 
    CAST(id AS BIGINT) AS transaction_id,
    CAST(client_id AS INT) AS user_id,
    CAST(card_id AS INT) AS card_id,
    
    -- Conversão de Data: Texto ISO para Datetime (Estilo 120: yyyy-mm-dd)
    CONVERT(DATETIME, [date], 120) AS transaction_timestamp,
    
    -- Limpeza de Moeda: Remove '$' e converte para DECIMAL(18,2)
    CAST(REPLACE(REPLACE(amount, '$', ''), ',', '') AS DECIMAL(18,2)) AS amount_value,
    
    use_chip,
    merchant_city,
    merchant_state,
    mcc,
    
    -- Padronização de Erros: Vazio vira 'Success'
    CASE 
        WHEN errors = '' OR errors IS NULL THEN 'Success'
        ELSE errors 
    END AS transaction_status
FROM payments_core.dbo.transactions_raw;
GO
