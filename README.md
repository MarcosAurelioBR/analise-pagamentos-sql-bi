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


### ✅ Status da Etapa 2: Cleaning (Concluído)
Os scripts de limpeza foram implementados utilizando **Views (Camada de Transformação)**, garantindo que a base original permaneça intacta enquanto fornecemos dados otimizados para o BI:

1.  **vw_transactions_cleaned:** Conversão de strings monetárias para `DECIMAL`, normalização de status de erro e tipagem de data completa.
2.  **vw_users_cleaned:** Tratamento de dados financeiros e criação da métrica `debt_to_income_ratio` para análises de crédito.

---
## Próxima Etapa: Etapa 3 - Modeling (Modelagem Star Schema)
Agora que os dados estão limpos, o foco será a **Integração das Tabelas**:
- Criação de uma **Tabela Fato** unificada.
- Relacionamento com a dimensão `mcc_codes` para categorização de gastos.
- Preparação da estrutura final para conexão com o Looker/Power BI.
- ---
## 🏗️ Etapa 3: Modelagem (Modeling)
A arquitetura foi consolidada em uma **View Analítica Central** (`vw_fact_payments_performance`), seguindo princípios de Star Schema para otimizar a performance em ferramentas de BI:

- **Denormalização:** Integração das camadas de transações, usuários e códigos de categoria (MCC).
- **Consistência:** Utilização de `INNER JOIN` para garantir que apenas transações de usuários válidos sejam analisadas.
- **Preparação para Dashboards:** A estrutura elimina a carga de processamento na ferramenta de visualização, permitindo filtros rápidos por categoria, gênero e faixa de score de crédito.
- ----
## 📊 Etapa 4: Visualização e Insights de Negócio

Com a modelagem concluída, os dados estão prontos para alimentar dashboards executivos. Com base na Tabela Fato construída, os seguintes KPIs foram definidos para monitoramento:

### 1. Performance Financeira (Finance)
- **TPV (Total Payment Volume):** Volume total transacionado com sucesso.
- **Ticket Médio:** Valor médio por transação (segmentado por categoria).
- **Categorias Top Performers:** Identificamos que **Money Transfer** lidera o volume financeiro, seguido por [Inserir próxima categoria].

### 2. Análise de Risco e Fraude (Risk)
- **Taxa de Aprovação:** Proporção de transações 'Success' vs 'Errors'.
- **Motivos de Declínio:** O principal motivo de falha identificado foi **Insufficient Balance**, o que se correlaciona com o `debt_ratio` elevado encontrado na Etapa 2.
- **Credit Score vs. Churn:** Relação entre a pontuação de crédito e a frequência de uso do cartão.

### 3. Perfil do Consumidor (Demographics)
- **Segmentação por Gênero:** Distribuição de gastos entre Male/Female.
- **Fidelidade:** Identificação de usuários com maior volume de transações recorrentes.
