{% macro remove_non_numeric(column) %}
    regexp_replace({{ column }}, '[^0-9]', '')
{% endmacro %}
