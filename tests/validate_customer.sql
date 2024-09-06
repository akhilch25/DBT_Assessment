select 
    EMAIL
from 
    {{ref("stg_customers")}}
where 
    EMAIL is null