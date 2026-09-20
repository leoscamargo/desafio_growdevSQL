-- * BLOCO C * --

--1 TRAZENDO O FATURAMENTO TOTAL POR ESTADO DO CLIENTE
select c.customer_state, sum(i.price) as faturamento_total
from olist_order_items_dataset i
inner join olist_orders_dataset o on o.order_id = i.order_id
inner join olist_customers_dataset c on c.customer_id = o.customer_id
group by c.customer_state
order by faturamento_total desc;

--2 IDENTIFICANDO OS TOP 10 VENDEDORES POR FATURAMENTO
select s.seller_id, sum(i.price) as faturamento_total
from olist_order_items_dataset i
inner join olist_sellers_dataset s on s.seller_id = i.seller_id
group by s.seller_id
order by faturamento_total desc
limit 10;

--3 CALCULANDO O TICKET MEDIO POR CATEGORIA DE PRODUTO
select p.product_category_name, avg(i.price) as ticket_medio
from olist_order_items_dataset i
inner join olist_products_dataset p on p.product_id = i.product_id
group by p.product_category_name
order by ticket_medio desc;

--4 IDENTIFICANDO VENDEDORES COM NOTA MEDIA DE AVALIACAO ABAIXO DE 3
select i.seller_id, avg(r.review_score) as nota_media
from olist_order_items_dataset i
inner join olist_order_reviews_dataset r on r.order_id = i.order_id
group by i.seller_id
having avg(r.review_score) < 3
order by nota_media asc;

--5 CONTANDO A QUANTIDADE DE PEDIDOS POR FORMA DE PAGAMENTO
select p.payment_type, count(distinct p.order_id) as qtd_pedidos
from olist_order_payments_dataset p
group by p.payment_type
order by qtd_pedidos desc;

--6 CALCULANDO O PESO MEDIO DOS PRODUTOS POR CATEGORIA
select p.product_category_name, avg(p.product_weight_g) as peso_medio
from olist_products_dataset p
group by p.product_category_name
order by peso_medio desc;

--7 CALCULANDO O NUMERO MEDIO DE PARCELAS POR CATEGORIA DE PRODUTO
select p.product_category_name, avg(pay.payment_installments) as media_parcelas
from olist_order_items_dataset i
inner join olist_products_dataset p on p.product_id = i.product_id
inner join olist_order_payments_dataset pay on pay.order_id = i.order_id
group by p.product_category_name
order by media_parcelas desc;