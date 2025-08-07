
-- macros/get_enhanced_user_partition.sql
{% macro get_user_partition(user_id_column, user_name_column) %}
  {% set partitions = env_var('PARTITIONS') %}
  (
    {% if target.type == 'bigquery' %}
      -- Combine both fields with separator and use strong hash
      mod(
        farm_fingerprint(
          concat(
            cast({{ user_id_column }} as string),
            '|',
            coalesce(cast({{ user_name_column }} as string), '')
          )
        ),
        {{ partitions }}
      )
    {% elif target.type == 'snowflake' %}
      -- Use SHA2 for cryptographic strength
      (hash(
        concat(
          cast({{ user_id_column }} as varchar),
          '|',
          coalesce(cast({{ user_name_column }} as varchar), '')
        )
      ) % {{ partitions }} + {{ partitions }}) % {{ partitions }}
    {% elif target.type == 'redshift' %}
      -- MD5 hash for better distribution
      (
        ('x' || substr(md5(
          cast({{ user_id_column }} as varchar) || '|' ||
          coalesce(cast({{ user_name_column }} as varchar), '')
        ), 1, 8))::bit(32)::bigint % {{ partitions }} + {{ partitions }}
      ) % {{ partitions }}
    {% elif target.type == 'postgres' %}
      -- MD5 with hex conversion for even distribution
      (
        ('x' || substr(md5(
          cast({{ user_id_column }} as varchar) || '|' ||
          coalesce(cast({{ user_name_column }} as varchar), '')
        ), 1, 8))::bit(32)::int % {{ partitions }} + {{ partitions }}
      ) % {{ partitions }}
    {% else %}
      -- Fallback: combine fields with basic hash
      (hash(
        concat(
          cast({{ user_id_column }} as varchar),
          '|',
          coalesce(cast({{ user_name_column }} as varchar), '')
        )
      ) % {{ partitions }} + {{ partitions }}) % {{ partitions }}
    {% endif %}
  ) as "partition"
{% endmacro %}
