{{ config(materialized='table') }}

select
    start_date as report_date,
    sum(monthly_price) as daily_revenue,
    count(distinct user_id) as subs_count,
    -- Ковзне середнє доходу за 7 днів для аналізу трендів
    avg(sum(monthly_price)) over (order by start_date rows between 6 preceding and current row) as rolling_avg_7d
from {{ ref('stg_subscriptions') }}
group by 1