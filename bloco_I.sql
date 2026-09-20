-- * BLOCO I * --
--1 IDENTIFICANDO, DENTRO DE CADA ESTADO, O VENDEDOR COM MAIS VENDAS (RANK POR FATURAMENTO)
select seller_id, seller_state, faturamento, ranking_estado
from (
    select s.seller_id, s.seller_state, sum(i.price) as faturamento,
        rank() over (partition by s.seller_state order by sum(i.price) desc) as ranking_estado
    from olist_order_items_dataset i
    inner join olist_sellers_dataset s on s.seller_id = i.seller_id
    group by s.seller_id, s.seller_state
) ranking
where ranking_estado = 1
order by seller_state;

--2 CALCULANDO O FATURAMENTO MENSAL ACUMULADO POR VENDEDOR
with faturamento_mensal_vendedor as (
    select i.seller_id,
        date_trunc('month', o.order_purchase_timestamp::timestamp) as mes,
        sum(i.price) as faturamento_mes
    from olist_order_items_dataset i
    inner join olist_orders_dataset o on o.order_id = i.order_id
    group by i.seller_id, date_trunc('month', o.order_purchase_timestamp::timestamp)
)
select seller_id, mes, faturamento_mes,
    sum(faturamento_mes) over (partition by seller_id order by mes) as faturamento_acumulado
from faturamento_mensal_vendedor
order by seller_id, mes;

--3 CALCULANDO O PERCENTUAL DE PARTICIPACAO DE CADA VENDEDOR NO FATURAMENTO TOTAL DO SEU ESTADO
select s.seller_id, s.seller_state, sum(i.price) as faturamento_vendedor,
    sum(sum(i.price)) over (partition by s.seller_state) as faturamento_total_estado,
    round(
        (sum(i.price) / sum(sum(i.price)) over (partition by s.seller_state) * 100)::numeric, 2
    ) as percentual_participacao
from olist_order_items_dataset i
inner join olist_sellers_dataset s on s.seller_id = i.seller_id
group by s.seller_id, s.seller_state
order by s.seller_state, percentual_participacao desc;

--4 CALCULANDO A VARIACAO DE FATURAMENTO DE UM MES PARA O OUTRO POR VENDEDOR
with faturamento_mensal_vendedor as (
    select i.seller_id,
        date_trunc('month', o.order_purchase_timestamp::timestamp) as mes,
        sum(i.price) as faturamento_mes
    from olist_order_items_dataset i
    inner join olist_orders_dataset o on o.order_id = i.order_id
    group by i.seller_id, date_trunc('month', o.order_purchase_timestamp::timestamp)
)
select seller_id, mes, faturamento_mes,
    lag(faturamento_mes) over (partition by seller_id order by mes) as faturamento_mes_anterior,
    faturamento_mes - lag(faturamento_mes) over (partition by seller_id order by mes) as variacao_faturamento
from faturamento_mensal_vendedor
order by seller_id, mes;