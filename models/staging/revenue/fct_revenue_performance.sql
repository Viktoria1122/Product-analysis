{{ config(materialized='table') }}

select
    date_trunc(start_date, month) as report_month,
    count(distinct user_id) as total_users,
    sum(monthly_price) as mrr,
    -- Early Churn Rate: користувачі, що пішли в перший місяць (lifespan <= 1)
    count(distinct case when lifespan_months <= 1 and end_date is not null then user_id end) 
        / count(distinct user_id) * 100 as early_churn_rate,
    avg(lifespan_months * monthly_price) as avg_ltv
from {{ ref('stg_subscriptions') }}
group by 1