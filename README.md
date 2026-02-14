 ##  Etapa 1: Diagnóstico  

Nesta fase inicial, identifiquei os seguintes desafios técnicos:

- **Inconsistência de Tipos:** Colunas críticas como `amount` e `yearly_income` estão tipadas como `VARCHAR`, impedindo cálculos matemáticos.

- **Campos de Data:** Armazenados como texto, o que impossibilita a análise de séries temporais sem conversão prévia.

- **Sujeira nos Dados:** Presença de caracteres especiais (`$`) e espaços em branco que precisam de tratamento.

- **Volume:** A base de transações possui 15 milhões de registros, exigindo queries performáticas. 

### 🔍 Status da Etapa 1: Diagnóstico (Concluído)
O script `01_exploration/01_data_profiling.sql` foi executado com sucesso e validou as seguintes necessidades de tratamento:

1.  **Conversão Financeira:** A coluna `amount` na tabela de transações e `yearly_income` na de usuários contêm o símbolo `$` e estão como texto, impedindo operações de soma e média.
2.  **Séries Temporais:** A coluna `date` precisa ser convertida de `VARCHAR` para `DATETIME` para permitir análises de sazonalidade (vendas por mês/dia).
3.  **Integridade de Dados:** Identifiquei que a coluna `errors` utiliza strings vazias para transações bem-sucedidas, o que será padronizado para 'Success' para facilitar a contagem em dashboards.
4.  **Performance:** Devido ao volume de 15 milhões de linhas, optou-se pelo uso de **Views** na próxima etapa para garantir a integridade da base bruta enquanto otimizamos a leitura para o BI.

---
## 🛠️ Próxima Etapa: Etapa 2 - Cleaning (Limpeza)
Com os problemas mapeados, iniciarei a criação dos scripts de limpeza e transformação. O foco será:
- Criação da `vw_transactions_cleaned` com tipos de dados corrigidos.
- Padronização da `vw_users_cleaned` para análise de perfil de crédito.
