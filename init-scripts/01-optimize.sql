-- Additional optimization settings
ALTER SYSTEM SET timezone TO 'Asia/Taipei';

-- Create extension for better performance monitoring
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- Set default timezone for all databases
UPDATE pg_database SET datcollate = 'en_US.UTF-8', datctype = 'en_US.UTF-8';

-- Optimize for dbt usage patterns
ALTER SYSTEM SET statement_timeout = '0';
ALTER SYSTEM SET lock_timeout = '30s';
ALTER SYSTEM SET idle_in_transaction_session_timeout = '1h';

SELECT pg_reload_conf();
