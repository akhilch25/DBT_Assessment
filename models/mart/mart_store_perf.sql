with store_details as (
    select
        s.STORE_ID,
        s.STORE_NAME,
        s.LOCATION,
        count(distinct e.EMPLOYEE_ID) as TOTAL_EMPLOYEES,
        s.STORE_TYPE,
        datediff('month', s.OPENING_DATE, current_date) as STORE_RUNNING_DURATION 
    from
        STORES as s
    left join
        EMPLOYEES as e on e.STORE_ID = s.STORE_ID
    group by 
        s.STORE_ID, s.STORE_NAME, s.LOCATION, s.STORE_TYPE, s.OPENING_DATE
),

sales_metrics as (
    select
        o.STORE_ID,
        count(distinct o.ORDER_ID) as TOTAL_ORDERS,
        sum(ol.QUANTITY) as TOTAL_UNITS_SOLD,
        count(distinct o.CUSTOMER_ID) as TOTAL_CUSTOMERS,
        coalesce(sum(p.PRICE * ol.QUANTITY), 0) as TOTAL_SALES_AMOUNT,
        avg(coalesce(p.PRICE * ol.QUANTITY, 0)) as AVERAGE_ORDER_VALUE,
        avg(datediff('day', o.ORDER_DATE, o.DELIVERY_DATE)) as AVERAGE_ORDER_DELIVERY_TIME 
    from
        ORDERS as o
    left join 
        ORDER_LINE_ITEMS as ol on ol.ORDER_ID = o.ORDER_ID
    left join 
        PRICING as p on p.PRODUCT_ID = ol.PRODUCT_ID
    group by
        o.STORE_ID
),

return_metrics as (
    select
        o.STORE_ID,
        count(distinct r.RETURN_ID) as RETURNED_ORDER_COUNT,
        coalesce(sum(r.REFUND_AMOUNT), 0) as TOTAL_RETURNS_AMOUNT
    from 
        RETURNS as r
    left join
        ORDERS as o on r.ORDER_ID = o.ORDER_ID
    group by
        o.STORE_ID
)

select
    sd.STORE_ID,
    sd.STORE_NAME,
    sd.LOCATION,
    sd.TOTAL_EMPLOYEES,
    sm.TOTAL_UNITS_SOLD,
    sm.TOTAL_CUSTOMERS,
    sm.TOTAL_ORDERS,
    coalesce(rm.RETURNED_ORDER_COUNT, 0) as RETURNED_ORDER_COUNT,
    sm.TOTAL_SALES_AMOUNT,
    sm.AVERAGE_ORDER_VALUE,
    rm.TOTAL_RETURNS_AMOUNT,
    sd.STORE_TYPE,
    sd.STORE_RUNNING_DURATION,
    sm.AVERAGE_ORDER_DELIVERY_TIME
from
    store_details as sd
left join 
    sales_metrics as sm on sd.STORE_ID = sm.STORE_ID
left join
    return_metrics as rm on sd.STORE_ID = rm.STORE_ID
