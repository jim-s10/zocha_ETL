{{
  config(
    materialized='incremental',
    unique_key='"clientOrderHistoryId"',
    incremental_strategy='merge',
    tags=['ingest']
  )
}}

WITH base AS (
    SELECT
        coh."clientOrderHistoryId",
        coh."clientOrderId",
        coh."updateDate",
        coh.flow,
        coh.updator,
        coh.note
    FROM {{ ref('client_order_history') }} AS coh
)

SELECT * FROM base
{% if is_incremental() %}
    WHERE "updateDate" > (SELECT MAX("updateDate") FROM {{ this }})
{% endif %}
