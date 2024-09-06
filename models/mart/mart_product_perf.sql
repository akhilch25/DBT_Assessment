with product_details as (
    select
        p.PRODUCT_ID,
        p.PRODUCT_NAME,
        p.CATEGORY,
        sum(ol.QUANTITY) as TOTAL_UNITS_SOLD,
        sum(o.TOTAL_AMOUNT) as TOTAL_SALES_AMOUNT,
        avg(pr.PRICE) as AVG_SELLING_PRICE,
        min(o.ORDER_DATE) as FIRST_PURCHASE_DATE,
        max(o.ORDER_DATE) as RECENT_PURCHASE_DATE,
        coalesce(sum(r.REFUND_AMOUNT), 0) as TOTAL_RETURNS,
        avg(pr.PRICE) as AVG_COST,
        (sum(o.TOTAL_AMOUNT) - (sum(ol.QUANTITY) * avg(pr.PRICE))) as GROSS_MARGIN
    from 
        {{ref("stg_products")}} as p
    join 
        {{ref("stg_pricing")}} as pr
        on p.PRODUCT_ID = pr.PRODUCT_ID
    join
        {{ref("stg_order_line_items")}} as ol
        on p.PRODUCT_ID = ol.PRODUCT_ID
    join
        {{ref("stg_orders")}} as o
        on o.ORDER_ID = o.ORDER_ID
    left join
        {{ref("stg_returns")}} as r
        on o.ORDER_ID = r.ORDER_ID
    group by
        p.PRODUCT_ID,
        p.PRODUCT_NAME,
        p.CATEGORY
)
select
    PRODUCT_ID,
    PRODUCT_NAME,
    CATEGORY,
    TOTAL_UNITS_SOLD,
    TOTAL_SALES_AMOUNT,
    AVG_SELLING_PRICE,
    TOTAL_RETURNS,
    FIRST_PURCHASE_DATE,
    RECENT_PURCHASE_DATE,
    GROSS_MARGIN
from 
    product_details
