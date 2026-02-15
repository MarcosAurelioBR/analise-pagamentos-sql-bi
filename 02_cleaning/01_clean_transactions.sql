/* PROJETO: Análise de Ecossistema de Pagamentos
   ETAPA 2: LIMPEZA DE DADOS (CLEANING)
   
   OBJETIVO: Organizar e padronizar a tabela de transações (15 milhões de registros).
   
   O QUE FOI FEITO:
   - Os valores em dinheiro foram convertidos para formato numérico.
   - As datas foram ajustadas para o padrão internacional (estilo 120) para evitar erros de leitura.
   - Os status de erro foram padronizados para facilitar a contagem no Dashboard.
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
