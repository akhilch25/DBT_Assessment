select 
    CUSTOMER_ID,
    DATE_OF_BIRTH,
    EMAIL,
    FIRST_NAME,
    GENDER,
    LAST_NAME,
    LOYALTY_PROGRAM_STATUS,
    MEMBERSHIP_LEVEL,
    {{remove_non_numeric('PHONE_NUMBER')}} as PHONE_NUMBER,
    PREFERRED_CONTACT_METHOD,
    REGISTRATION_DATE

from 
    {{source('source_data','Customers')}}