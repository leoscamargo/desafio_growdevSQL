-- * BLOCO D * --
--1 IDENTIFICANDO CLIENTES CUJO GASTO TOTAL ESTA ACIMA DA MEDIA GERAL DE GASTO POR CLIENTE
select o.customer_id, sum(i.price) as gasto_total
from olist_orders_dataset o
inner join olist_order_items_dataset i on i.order_id = o.order_id
group by o.customer_id
having sum(i.price) > (
    select avg(gasto_total)
    from (
        select sum(i2.price) as gasto_total
        from olist_orders_dataset o2
        inner join olist_order_items_dataset i2 on i2.order_id = o2.order_id
        group by o2.customer_id
    ) t
);

--2 IDENTIFICANDO PRODUTOS QUE NUNCA RECEBERAM AVALIACAO
select p.product_id
from olist_products_dataset p
where not exists (
    select 1
    from olist_order_items_dataset i
    inner join olist_order_reviews_dataset r on r.order_id = i.order_id
    where i.product_id = p.product_id
);

--3 IDENTIFICANDO VENDEDORES QUE VENDERAM PRODUTOS DE MAIS DE 5 CATEGORIAS DIFERENTES
select seller_id
from (
    select i.seller_id, count(distinct p.product_category_name) as qtd_categorias
    from olist_order_items_dataset i
    inner join olist_products_dataset p on p.product_id = i.product_id
    group by i.seller_id
) t
where qtd_categorias > 5;

--4 IDENTIFICANDO PEDIDOS CUJO VALOR DE FRETE E MAIOR QUE O VALOR TOTAL DOS ITENS DO PROPRIO PEDIDO
select o.order_id
from olist_orders_dataset o
inner join (
    select order_id, sum(freight_value) as total_frete, sum(price) as total_itens
    from olist_order_items_dataset
    group by order_id
) t on t.order_id = o.order_id
where t.total_frete > t.total_itens;