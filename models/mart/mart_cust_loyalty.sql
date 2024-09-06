with customer_data as (
    select
        c.CUSTOMER_ID,
        concat(c.FIRST_NAME, ' ', c.LAST_NAME) as CUSTOMER_NAME,
        c.GENDER,
        datediff('year', c.DATE_OF_BIRTH, current_date) as AGE,
        case
            when datediff('year', c.DATE_OF_BIRTH, current_date) < 18 then 'Below 18'
            when datediff('year', c.DATE_OF_BIRTH, current_date) between 18 and 30 then '18-30'
            when datediff('year', c.DATE_OF_BIRTH, current_date) between 31 and 45 then '31-45'
            when datediff('year', c.DATE_OF_BIRTH, current_date) between 46 and 60 then '46-60'
            else 'Above 60'
        end as AGE_GROUP,
        c.MEMBERSHIP_LEVEL,
        count(o.ORDER_ID) as TOTAL_ORDERS,
        avg(o.TOTAL_AMOUNT) as AVERAGE_ORDER_VALUE,
        coalesce(sum(r.REFUND_AMOUNT), 0) as TOTAL_RETURN_AMOUNT,
        max(o.ORDER_DATE) as LAST_ORDER_DATE,
        sum(o.TOTAL_AMOUNT) as CLV,
        datediff('year', min(o.ORDER_DATE), current_date) as YEARS_WITH_COMPANY,
        sum(o.DISCOUNT) as TOTAL_DISCOUNT_USED,
        case
            when max(o.ORDER_DATE) < current_date - interval '1 year' then 'Churned'
            else 'Active'
        end as CUSTOMER_CHURN
    from
        {{ref("stg_customers")}} as c
    left join   
        {{ref("stg_orders")}} as o
        on c.CUSTOMER_ID = o.CUSTOMER_ID
    left join
        {{ref("stg_returns")}} as r
        on o.ORDER_ID = r.ORDER_ID
    group by
        c.CUSTOMER_ID,
        c.FIRST_NAME,
        c.LAST_NAME,
        c.GENDER,
        c.DATE_OF_BIRTH,
        c.MEMBERSHIP_LEVEL
)
select
    CUSTOMER_ID,
    CUSTOMER_NAME,
    GENDER,
    AGE_GROUP,
    MEMBERSHIP_LEVEL,
    TOTAL_ORDERS,
    AVERAGE_ORDER_VALUE,
    LAST_ORDER_DATE,
    CLV,
    YEARS_WITH_COMPANY,
    TOTAL_RETURN_AMOUNT,
    TOTAL_DISCOUNT_USED,
    CUSTOMER_CHURN
from
    customer_data
