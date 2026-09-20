-- * BLOCO B * --
--1 TRAZENDO INFORMAÇÃO DOS PRODUTOS VENDIDOS E O LOCAL DOS VENDEDORES
select p.product_category_name, o.price, s.seller_city  from olist_order_items_dataset o
inner join olist_products_dataset p on p.product_id = o.product_id 
inner join olist_sellers_dataset s on s.seller_id = o.seller_id;

--2 IDENTIFICANDO OS PEDIDOS QUE HOUVERAM ATRASO NA ENTREGA
select o.order_id, o.order_estimated_delivery_date, o.order_delivered_customer_date  from olist_orders_dataset o
inner join olist_customers_dataset c on c.customer_id = o.customer_id
where o.order_delivered_carrier_date > o.order_estimated_delivery_date;

--3 LISTANDO TODOS OS PEDIDOS E SEUS MEIOS DE PAGAMENTO, INCLUINDO A QUANTIDADE DE PARCELAS
select o.order_id, p.payment_type, p.payment_installments  from olist_orders_dataset o
inner join olist_order_payments_dataset p on p.order_id = o.order_id
where p.payment_type is not null;

--4 LISTANDO TODOS PRODUTOS E SUAS TRADUÇÕES, INCLUINDO OS NULOS.
select p.product_id, p.product_category_name, t.product_category_name_english from olist_products_dataset p
left join product_category_name_translation t on t.product_category_name = p.product_category_name;

--5 IDENTIFICANDO PEDIDOS ONDE O VENDEDOR E O CLIENTE POSSUEM A CIDADE EM COMUM.
select o.order_id, s.seller_city, c.customer_city from olist_orders_dataset o
inner join olist_customers_dataset c on o.customer_id = c.customer_id
inner join olist_order_items_dataset i on i.order_id = o.order_id
inner join olist_sellers_dataset s on s.seller_id  = i.seller_id 
where c.customer_city = s.seller_city;
