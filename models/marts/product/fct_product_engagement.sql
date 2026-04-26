{{ config(materialized='table') }}

select
    date(event_at) as event_date,
    event_type,
    count(distinct user_id) as unique_users,
    count(*) as total_events
from {{ ref('stg_amplitude_events') }}
group by 1, 2