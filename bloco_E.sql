-- * BLOCO E * --
--1 CLASSIFICANDO PEDIDOS POR PRAZO DE ENTREGA: ADIANTADO, NO PRAZO OU ATRASADO
select o.order_id, o.order_estimated_delivery_date, o.order_delivered_customer_date,
    case
        when o.order_delivered_customer_date < o.order_estimated_delivery_date then 'adiantado'
        when o.order_delivered_customer_date = o.order_estimated_delivery_date then 'no prazo'
        else 'atrasado'
    end as status_entrega
from olist_orders_dataset o
where o.order_delivered_customer_date is not null;

--2 CLASSIFICANDO CLIENTES POR FAIXA DE GASTO TOTAL: BRONZE, PRATA OU OURO
select o.customer_id, sum(i.price) as gasto_total,
    case
        when sum(i.price) < 100 then 'bronze'
        when sum(i.price) < 500 then 'prata'
        else 'ouro'
    end as faixa_cliente
from olist_orders_dataset o
inner join olist_order_items_dataset i on i.order_id = o.order_id
group by o.customer_id;

--3 CLASSIFICANDO PRODUTOS POR FAIXA DE PESO: LEVE, MEDIO OU PESADO
select p.product_id, p.product_weight_g,
    case
        when p.product_weight_g < 1000 then 'leve'
        when p.product_weight_g < 5000 then 'medio'
        else 'pesado'
    end as faixa_peso
from olist_products_dataset p;

--4 CLASSIFICANDO PAGAMENTOS COMO A VISTA OU PARCELADO, SINALIZANDO PARCELAMENTOS LONGOS
select pay.order_id, pay.payment_type, pay.payment_installments,
    case
        when pay.payment_installments <= 1 then 'a vista'
        when pay.payment_installments > 6 then 'parcelado longo'
        else 'parcelado'
    end as tipo_parcelamento
from olist_order_payments_dataset pay;