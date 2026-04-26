select distinct -- Видалення дублікатів
    user_id,
    creative_id,
    cast(purchase_date as date) as purchase_date,
    cast(revenue_usd as float64) as revenue_usd
from {{ source('marketing_source', 'purchase_events') }}