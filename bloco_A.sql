-- * BLOCO A * --
--1 20 PEDIDOS MAIS RECENTES.
select * from olist_orders_dataset o
where o.order_delivered_customer_date is not null
order by o.order_delivered_customer_date desc
limit 20;

--2 LISTANDO TODOS OS PRODUTOS DE UMA CATEGORIA ESPECÍFICA (a tabela já estava em português).
select * from olist_products_dataset p
where p.product_category_name = 'perfumaria';

--(caso não estivesse em português, eu faria assim:)
select * from olist_products_dataset p
inner join product_category_name_translation t on t.product_category_name = p.product_category_name
where t.product_category_name_english = 'perfumery';

--3 TODOS MÉTODOS DE PAGAMENTOS UTILIZADOS PELOS CLIENTES.
select distinct payment_type
from olist_order_payments_dataset
where payment_value <> 0;

--4 TODOS OS PRODUTOS COM PESO MAIOR/IGUAL A 10KG ORDENADOS DO MAIS PESADO AO MENOS PESADO.
select * from olist_products_dataset p
where p.product_weight_g >= 10
order by p.product_weight_g desc;
