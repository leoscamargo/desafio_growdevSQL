-- * BLOCO G * --
--1 CRIANDO A VIEW VW_PEDIDOS_COMPLETOS CONSOLIDANDO PEDIDO, CLIENTE, ITENS, PAGAMENTO E VENDEDOR
create view vw_pedidos_completos as
select o.order_id, o.order_status, o.order_purchase_timestamp,
    c.customer_id, c.customer_city, c.customer_state,
    i.product_id, i.seller_id, i.price, i.freight_value,
    pay.payment_type, pay.payment_installments, pay.payment_value,
    s.seller_city, s.seller_state
from olist_orders_dataset o
inner join olist_customers_dataset c on c.customer_id = o.customer_id
inner join olist_order_items_dataset i on i.order_id = o.order_id
inner join olist_sellers_dataset s on s.seller_id = i.seller_id
inner join olist_order_payments_dataset pay on pay.order_id = o.order_id;

--2 CRIANDO A VIEW VW_AVALIACOES_CATEGORIA CONSOLIDANDO NOTA MEDIA E VOLUME DE AVALIACOES POR CATEGORIA
create view vw_avaliacoes_categoria as
select p.product_category_name,
    count(r.review_id) as qtd_avaliacoes,
    avg(r.review_score) as nota_media
from olist_order_items_dataset i
inner join olist_products_dataset p on p.product_id = i.product_id
inner join olist_order_reviews_dataset r on r.order_id = i.order_id
group by p.product_category_name;