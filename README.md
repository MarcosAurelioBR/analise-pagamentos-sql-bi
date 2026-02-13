# analise-pagamentos-sql-bi
Pipeline de dados e análise de performance financeira utilizando SQL Server e ferramentas de BI. Processamento e limpeza de +15 milhões de transações para geração de insights sobre comportamento de consumo, fraude e risco de crédito.


##  Etapa 1: Diagnóstico  
Nesta fase inicial, identifiquei os seguintes desafios técnicos:
- **Inconsistência de Tipos:** Colunas críticas como `amount` e `yearly_income` estão tipadas como `VARCHAR`, impedindo cálculos matemáticos.
- **Campos de Data:** Armazenados como texto, o que impossibilita a análise de séries temporais sem conversão prévia.
- **Sujeira nos Dados:** Presença de caracteres especiais (`$`) e espaços em branco que precisam de tratamento.
- **Volume:** A base de transações possui 15 milhões de registros, exigindo queries performáticas.
