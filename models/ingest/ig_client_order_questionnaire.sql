{{
  config(
    materialized='incremental',
    unique_key='"rowId"',
    incremental_strategy='merge',
    tags=['ingest']
  )
}}


WITH base AS (
    SELECT
        coq."rowId"
        , coq."getFrom"
        , coq."usePurpose"
        , coq."updateDate"
        , coq.updator
        , CAST(coq."clientOrderId" AS VARCHAR(45)) AS "clientOrderId"
    FROM {{ ref('client_order_questionnaire') }} AS coq
)

SELECT * FROM base
{% if is_incremental() %}
    WHERE "updateDate" > (SELECT MAX("updateDate") FROM {{ this }})
{% endif %}
