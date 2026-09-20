-- * BLOCO F * --
--1 CTE DE FATURAMENTO MENSAL POR ESTADO E VARIACAO PERCENTUAL MES A MES
with faturamento_mensal as (
    select c.customer_state,
        date_trunc('month', o.order_purchase_timestamp::timestamp) as mes,
        sum(i.price) as faturamento
    from olist_orders_dataset o
    inner join olist_order_items_dataset i on i.order_id = o.order_id
    inner join olist_customers_dataset c on c.customer_id = o.customer_id
    group by c.customer_state, date_trunc('month', o.order_purchase_timestamp::timestamp)
)
select customer_state, mes, faturamento,
    lag(faturamento) over (partition by customer_state order by mes) as faturamento_mes_anterior,
    round(
        (
            (faturamento - lag(faturamento) over (partition by customer_state order by mes))
            / lag(faturamento) over (partition by customer_state order by mes) * 100
        )::numeric, 2
    ) as variacao_percentual
from faturamento_mensal
order by customer_state, mes;

--2 CTE COM VOLUME DE AVALIACOES E NOTA MEDIA POR CATEGORIA, IDENTIFICANDO PIOR REPUTACAO
with avaliacoes_categoria as (
    select p.product_category_name,
        count(r.review_id) as qtd_avaliacoes,
        avg(r.review_score) as nota_media
    from olist_order_items_dataset i
    inner join olist_products_dataset p on p.product_id = i.product_id
    inner join olist_order_reviews_dataset r on r.order_id = i.order_id
    group by p.product_category_name
)
select product_category_name, qtd_avaliacoes, nota_media
from avaliacoes_categoria
where qtd_avaliacoes > 50
order by nota_media asc;

--3 CTE DE FRETE MEDIO POR ESTADO DO CLIENTE COMPARADO COM A MEDIA GERAL
with frete_estado as (
    select c.customer_state, avg(i.freight_value) as frete_medio_estado
    from olist_order_items_dataset i
    inner join olist_orders_dataset o on o.order_id = i.order_id
    inner join olist_customers_dataset c on c.customer_id = o.customer_id
    group by c.customer_state
)
select customer_state, frete_medio_estado,
    (select avg(frete_medio_estado) from frete_estado) as frete_medio_geral,
    frete_medio_estado - (select avg(frete_medio_estado) from frete_estado) as diferenca_media_geral
from frete_estado
order by diferenca_media_geral desc;