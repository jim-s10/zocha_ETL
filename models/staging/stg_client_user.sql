{{
  config(
    materialized='incremental',
    unique_key='"clientUserId"',
    incremental_strategy='merge',
    tags=['staging']
  )
}}

WITH base AS (
    SELECT
        "clientUserId",
        "disName",
        phone,
        sex,
        birthday,
        addr,
        email,
        country,
        "createDate",
        "updateDate",
        date_part('month', birthday) AS month_of_birthday,
        date_part('year', current_date)
        - date_part('year', birthday) AS years_old,
        "lineId"
    FROM {{ ref('ig_client_user') }}
)

SELECT * FROM base
{% if is_incremental() %}
    WHERE "updateDate" > (SELECT max("updateDate") FROM {{ this }})
{% endif %}
