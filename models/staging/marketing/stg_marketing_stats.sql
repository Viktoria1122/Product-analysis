select
    cast(date as date) as report_date,
    creative_id,
    channel,
    cast(impressions as int64) as impressions,
    cast(clicks as int64) as clicks,
    cast(installs as int64) as installs,
    cast(spend_usd as float64) as spend_usd
from {{ source('marketing_source', 'creative_stats_daily') }}
where creative_id is not null 
  and spend_usd >= 0 
  and impressions >= clicks