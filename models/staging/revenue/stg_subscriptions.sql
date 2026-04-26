select
    user_id,
    cast(subscription_start as date) as start_date,
    cast(subscription_end as date) as end_date,
    monthly_price,
    -- Розрахунок тривалості підписки в місяцях
    date_diff(coalesce(cast(subscription_end as date), current_date()), cast(subscription_start as date), month) as lifespan_months
from {{ source('revenue_source', 'subscriptions') }}