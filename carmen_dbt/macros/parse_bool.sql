{% macro parse_bool(col_expr) -%}
case
  when lower(trim({{ col_expr }}::text)) in ('true','t','yes','y','1','armed','yes - armed') then true
  when lower(trim({{ col_expr }}::text)) in ('false','f','no','n','0','not armed','unarmed') then false
  when {{ col_expr }} is null then null
  else null
end
{%- endmacro %}
