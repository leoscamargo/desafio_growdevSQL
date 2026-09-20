# Desafio Growdev — Análise de Dados Olist com SQL

Conjunto de consultas SQL desenvolvidas sobre o dataset público de e-commerce da **Olist**, evoluindo em complexidade: seleções simples, joins, agregações, subqueries, `CASE WHEN`, CTEs, views, functions e window functions.

## Tecnologias utilizadas

| Tecnologia | Uso no projeto |
|---|---|
| **PostgreSQL** (14+) | Banco de dados onde as tabelas são criadas e as consultas executadas. As queries usam recursos específicos do Postgres: `date_trunc`, casts com `::timestamp` / `::numeric`, functions em `language sql` e window functions (`rank`, `lag`, `sum() over`). |
| **SQL** | Linguagem de todas as consultas (arquivos `bloco_A.sql` a `bloco_I.sql`). |
| **psql** ou **DBeaver / pgAdmin** | Cliente para importar os CSVs e executar os scripts. Qualquer cliente PostgreSQL funciona. |
| **Dataset Olist (CSV)** | Dados brutos na pasta `Dataset/` — clientes, pedidos, itens, pagamentos, avaliações, produtos, vendedores, geolocalização e tradução de categorias. |

## Estrutura do projeto

growdev/
├── Dataset/                                # CSVs do dataset Olist
│   ├── olist_customers_dataset.csv
│   ├── olist_geolocation_dataset.csv
│   ├── olist_orders_dataset.csv
│   ├── olist_order_items_dataset.csv
│   ├── olist_order_payments_dataset.csv
│   ├── olist_order_reviews_dataset.csv
│   ├── olist_order_reviews_dataset_clean.csv   # versão tratada, usada na importação
│   ├── olist_products_dataset.csv
│   ├── olist_sellers_dataset.csv
│   └── product_category_name_translation.csv
├── bloco_A.sql   # SELECT, WHERE, ORDER BY, LIMIT
├── bloco_B.sql   # INNER JOIN e LEFT JOIN
├── bloco_C.sql   # Agregações (SUM, AVG, COUNT), GROUP BY e HAVING
├── bloco_D.sql   # Subqueries (correlacionadas, EXISTS, derivadas)
├── bloco_E.sql   # CASE WHEN — classificações de negócio
├── bloco_F.sql   # CTEs (WITH) e análises temporais
├── bloco_G.sql   # Views (vw_pedidos_completos, vw_avaliacoes_categoria)
├── bloco_H.sql   # Functions (sp_relatorio_vendedor, sp_relatorio_categoria)
├── bloco_I.sql   # Window functions (RANK, LAG, acumulados, participação %)
└── README.md

## Como rodar o projeto localmente

### Pré-requisitos

- **PostgreSQL 14 ou superior** instalado e rodando ([download](https://www.postgresql.org/download/)).
- O utilitário `psql` no PATH (vem junto com a instalação do Postgres) **ou** um cliente gráfico como DBeaver / pgAdmin.
- Git, para clonar o repositório.

### 1. Clonar o repositório

```bash
git clone https://github.com/leoscamargo/desafio_growdevSQL.git
cd desafio_growdevSQL
```

### 2. Criar o banco de dados

```bash
psql -U postgres -c "CREATE DATABASE olist;"
```

### 3. Criar as tabelas

As tabelas têm **o mesmo nome dos arquivos CSV** (sem a extensão), pois é assim que as consultas as referenciam. Conecte-se ao banco (`psql -U postgres -d olist`) e execute:

```sql
CREATE TABLE olist_customers_dataset (
    customer_id              VARCHAR PRIMARY KEY,
    customer_unique_id       VARCHAR,
    customer_zip_code_prefix VARCHAR,
    customer_city            VARCHAR,
    customer_state           VARCHAR
);

CREATE TABLE olist_geolocation_dataset (
    geolocation_zip_code_prefix VARCHAR,
    geolocation_lat             NUMERIC,
    geolocation_lng             NUMERIC,
    geolocation_city            VARCHAR,
    geolocation_state           VARCHAR
);

CREATE TABLE olist_orders_dataset (
    order_id                      VARCHAR PRIMARY KEY,
    customer_id                   VARCHAR,
    order_status                  VARCHAR,
    order_purchase_timestamp      VARCHAR,
    order_approved_at             VARCHAR,
    order_delivered_carrier_date  VARCHAR,
    order_delivered_customer_date VARCHAR,
    order_estimated_delivery_date VARCHAR
);

CREATE TABLE olist_order_items_dataset (
    order_id            VARCHAR,
    order_item_id       INTEGER,
    product_id          VARCHAR,
    seller_id           VARCHAR,
    shipping_limit_date VARCHAR,
    price               NUMERIC,
    freight_value       NUMERIC
);

CREATE TABLE olist_order_payments_dataset (
    order_id             VARCHAR,
    payment_sequential   INTEGER,
    payment_type         VARCHAR,
    payment_installments INTEGER,
    payment_value        NUMERIC
);

CREATE TABLE olist_order_reviews_dataset (
    review_id               VARCHAR,
    order_id                VARCHAR,
    review_score            INTEGER,
    review_comment_title    TEXT,
    review_comment_message  TEXT,
    review_creation_date    VARCHAR,
    review_answer_timestamp VARCHAR
);

CREATE TABLE olist_products_dataset (
    product_id                 VARCHAR PRIMARY KEY,
    product_category_name      VARCHAR,
    product_name_lenght        INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty         INTEGER,
    product_weight_g           INTEGER,
    product_length_cm          INTEGER,
    product_height_cm          INTEGER,
    product_width_cm           INTEGER
);

CREATE TABLE olist_sellers_dataset (
    seller_id              VARCHAR PRIMARY KEY,
    seller_zip_code_prefix VARCHAR,
    seller_city            VARCHAR,
    seller_state           VARCHAR
);

CREATE TABLE product_category_name_translation (
    product_category_name         VARCHAR,
    product_category_name_english VARCHAR
);
```

> As colunas de data ficam como `VARCHAR` de propósito: o dataset original armazena datas como texto, e as consultas fazem o cast (`::timestamp`, `::date`) onde necessário — um dos aprendizados do desafio.

### 4. Importar os CSVs

Ainda dentro do `psql`, a partir da **raiz do repositório**, use `\copy` (funciona sem permissão de superusuário e lê o arquivo da sua máquina):

```sql
\copy olist_customers_dataset           FROM 'Dataset/olist_customers_dataset.csv'           CSV HEADER
\copy olist_geolocation_dataset         FROM 'Dataset/olist_geolocation_dataset.csv'         CSV HEADER
\copy olist_orders_dataset              FROM 'Dataset/olist_orders_dataset.csv'              CSV HEADER
\copy olist_order_items_dataset         FROM 'Dataset/olist_order_items_dataset.csv'         CSV HEADER
\copy olist_order_payments_dataset      FROM 'Dataset/olist_order_payments_dataset.csv'      CSV HEADER
\copy olist_order_reviews_dataset       FROM 'Dataset/olist_order_reviews_dataset_clean.csv' CSV HEADER
\copy olist_products_dataset            FROM 'Dataset/olist_products_dataset.csv'            CSV HEADER
\copy olist_sellers_dataset             FROM 'Dataset/olist_sellers_dataset.csv'             CSV HEADER
\copy product_category_name_translation FROM 'Dataset/product_category_name_translation.csv' CSV HEADER
```

> Para as avaliações use o arquivo **`_clean`**: o CSV original tem comentários com quebras de linha e aspas que quebram a importação.
>
> Se preferir o DBeaver/pgAdmin, clique com o botão direito em cada tabela → *Import Data* e selecione o CSV correspondente, marcando que a primeira linha é o cabeçalho.

### 5. Executar as consultas

Cada bloco é independente e pode ser rodado na ordem que quiser. Pelo terminal:

```bash
psql -U postgres -d olist -f bloco_A.sql
psql -U postgres -d olist -f bloco_B.sql
# ... até bloco_I.sql
```

Ou abra o arquivo no seu cliente SQL e execute query a query — cada uma vem precedida de um comentário explicando o que ela responde.

Observações:

- **`bloco_G.sql`** cria views. Um `CREATE VIEW` não retorna linhas; para conferir o resultado, consulte a view depois: `SELECT * FROM vw_pedidos_completos LIMIT 10;`
- **`bloco_H.sql`** cria functions. Exemplo de chamada após a criação:
  ```sql
  SELECT * FROM sp_relatorio_vendedor('<seller_id>', '2017-01-01', '2017-12-31');
  SELECT * FROM sp_relatorio_categoria('perfumaria', '2017-01-01', '2017-12-31');
  ```

## Insights do desafio

Esse desafio começou com a exploração do modelo de dados da Olist, entendendo como as tabelas se conectam: pedidos, clientes, itens, produtos, vendedores, pagamentos e avaliações. A partir daí, fui evoluindo as consultas em complexidade, passando por joins, agregações, subqueries, CTEs, views, funções e window functions.

Sobre a lógica das consultas, o principal aprendizado foi perceber que uma mesma pergunta de negócio pode ser resolvida de formas bem diferentes, e nem sempre a primeira forma que parece "correta" é a mais eficiente. Em alguns momentos escrevi subqueries correlacionadas que, na teoria, entregavam o resultado certo, mas na prática travavam a execução porque recalculavam a mesma coisa para cada linha da tabela, milhares de vezes. Reescrever essas consultas como uma agregação única, feita antes e depois comparada ou juntada ao restante, resolveu tanto a lentidão quanto deixou a lógica mais clara. Isso me mostrou que pensar em performance faz parte de pensar na lógica, não é uma etapa separada.

Sobre as relações do banco, o principal insight foi entender que quase tudo gira em torno da tabela de pedidos, e que a forma como as tabelas se relacionam interfere diretamente no resultado das contas. Um pedido pode ter vários itens, então juntar avaliações direto com os itens distorce a média, porque a mesma nota acaba sendo contada mais de uma vez. Precisei isolar esse cálculo à parte para ele ficar correto. Também aprendi que relação não é só sobre chave estrangeira e join, é sobre entender o que cada linha representa de verdade antes de somar ou tirar média dela.

Já com o CASE WHEN, o aprendizado foi sobre transformar número em categoria de negócio sem precisar criar tabela auxiliar nem processo externo. Dá pra classificar entrega, cliente, produto e forma de pagamento direto na consulta. A parte que mais me chamou atenção foi entender que a ordem das condições importa, porque o CASE só olha para a próxima condição se a anterior for falsa, então a lógica de faixas (leve, médio, pesado, ou bronze, prata, ouro) precisa ser pensada do mais restritivo para o mais aberto, senão o resultado sai errado silenciosamente, sem dar erro nenhum.

Por fim, teve bastante aprendizado só de debugar os erros que o banco devolvia. Vi na prática que datas guardadas como texto não se comportam como datas de verdade, então funções como date_trunc ou comparação com BETWEEN só funcionam depois de converter o tipo. Também aprendi que criar uma view não retorna linha nenhuma porque ela não é uma consulta, é a criação de um objeto, e a forma certa de confirmar que deu certo é consultando a view depois. No fim, o desafio deixou claro que escrever SQL não é só saber a sintaxe, é entender o dado por trás de cada tabela e testar bastante até a lógica realmente bater com a realidade.
