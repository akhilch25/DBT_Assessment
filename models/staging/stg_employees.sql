select 
    EMAIL,
    EMPLOYEE_ID,
    EMPLOYMENT_STATUS,
    FIRST_NAME,
    HIRE_DATE,
    LAST_NAME,
    {{remove_non_numeric('PHONE_NUMBER')}} as PHONE_NUMBER,
    POSITION,
    SALARY,
    STORE_ID
    
from 
    {{source('source_data','Employees')}}