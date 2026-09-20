-- * BLOCO H * --
--1 CRIANDO A FUNCTION SP_RELATORIO_VENDEDOR: FATURAMENTO, TICKET MEDIO E NOTA MEDIA DO VENDEDOR NO PERIODO
create or replace function sp_relatorio_vendedor(
    id_vendedor varchar,
    data_inicio date,
    data_fim date
)
returns table (
    faturamento numeric,
    ticket_medio numeric,
    nota_media numeric
)
language sql
as $$
    select
        sum(i.price) as faturamento,
        avg(i.price) as ticket_medio,
        (
            select avg(r.review_score)
            from olist_orders_dataset o2
            inner join olist_order_reviews_dataset r on r.order_id = o2.order_id
            where o2.customer_id in (
                select o3.customer_id
                from olist_orders_dataset o3
                inner join olist_order_items_dataset i3 on i3.order_id = o3.order_id
                where i3.seller_id = id_vendedor
            )
            and o2.order_purchase_timestamp::date between data_inicio and data_fim
        ) as nota_media
    from olist_order_items_dataset i
    inner join olist_orders_dataset o on o.order_id = i.order_id
    where i.seller_id = id_vendedor
      and o.order_purchase_timestamp::date between data_inicio and data_fim;
$$;
--2 CRIANDO A FUNCTION SP_RELATORIO_CATEGORIA: FATURAMENTO TOTAL E TICKET MEDIO DA CATEGORIA NO PERIODO
create or replace function sp_relatorio_categoria(
    categoria varchar,
    data_inicio date,
    data_fim date
)
returns table (
    faturamento_total numeric,
    ticket_medio numeric
)
language sql
as $$
    select
        sum(i.price) as faturamento_total,
        avg(i.price) as ticket_medio
    from olist_order_items_dataset i
    inner join olist_orders_dataset o on o.order_id = i.order_id
    inner join olist_products_dataset p on p.product_id = i.product_id
    where p.product_category_name = categoria
      and o.order_purchase_timestamp::date between data_inicio and data_fim;
$$;