select
    user_id,
    cast(event_time as timestamp) as event_at,
    event_type
from {{ source('product_source', 'events') }}