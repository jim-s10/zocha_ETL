{{
  config(
    materialized='incremental',
    unique_key='gid',
    incremental_strategy='merge',
    tags=['mart']
  )
}}

WITH
base AS (
    SELECT
        CAST(scu."clientUserId" AS VARCHAR(20)) AS gid
        , CAST(scu.partition AS INTEGER) AS "gid_partition"
        , CAST(scu."updateDate" AS TIMESTAMP) AS updated_at
    FROM {{ ref('stg_client_user') }} AS scu
)

SELECT *
FROM base
{% if is_incremental() %}
  WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}
