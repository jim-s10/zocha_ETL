{{
  config(
    materialized='incremental',
    unique_key='"clientUserId"',
    incremental_strategy='merge',
    tags=['ingest']
  )
}}
WITH base AS (
    SELECT
        "clientUserId"
        , "disName"
        , phone
        , sex
        , addr
        , pwd
        , "emrContact"
        , "emrContactPhone"
        , email
        , TO_TIMESTAMP("updateDate", 'YYYYMMDDHH24MISS') AS "updateDate"
        , updator
        , "adminNote"
        --, "pic1"
        --, "pic2"
        --, "pic3"
        --, "pic4"
        , "boundleCreditCard"
        , TO_TIMESTAMP("createDate", 'YYYYMMDDHH24MISS') AS "createDate"
        , "FrOrderId"
        , country
        , "payTokenValue"
        , "card4No"
        , "lineId"
        , "facebookId"
        , "recognizeResult"
        , "recognizeDate"
        , TO_TIMESTAMP("registerDate", 'YYYYMMDDHH24MISS') AS "registerDate"
        , "createStoreId"
        , "motoLicense"
        , "carrierNum"
        , ban
        , "banNote"
        , "tokenTerm"
        , "kycRatioRs"
        , CASE
            -- Handles 'YYYY-MM-DD' format
            WHEN
                birthday LIKE '____-___-__'
                THEN to_date(birthday, 'YYYY-MM-DD')
            -- Handles 'YYYYMMDD' format
            WHEN length(birthday) = 8 THEN to_date(birthday, 'YYYYMMDD')
            -- Handles 'YYYYMM' format, defaulting to the 1st day of the month
            WHEN
                length(birthday) = 6 AND birthday NOT LIKE '%-%'
                THEN to_date(birthday, 'YYYYMM')
            -- Handles potential 'YYYY-MM' format if it existed, defaulting to the 1st
            WHEN
                length(birthday) = 7 AND birthday LIKE '____-___'
                THEN to_date(birthday, 'YYYY-MM')
        -- Returns NULL for any other format not accounted for
        END AS birthday
    FROM {{ ref('client_user') }}
)

SELECT * FROM base
{% if is_incremental() %}
    WHERE "updateDate" > (SELECT max("updateDate") FROM {{ this }})
{% endif %}
