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
        "clientUserId"
        , {{ get_user_partition('"clientUserId"', '"disName"') }} --take 2 field into hashing to prevent uneven distribution of partitions.
        , "disName"
        , phone
        , sex
        , birthday
        , addr
        , email
        , country
        , "createDate"
        , "updateDate"
        , date_part('month', birthday) AS month_of_birthday
        , (date_part('year', current_date) - date_part('year', birthday)) AS age
        , "lineId"
        , "registerDate"
    FROM {{ ref('ig_client_user') }}
)

SELECT * FROM base
{% if is_incremental() %}
    WHERE "updateDate" > (SELECT max("updateDate") FROM {{ this }})
{% endif %}
