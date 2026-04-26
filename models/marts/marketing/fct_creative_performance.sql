{{ config(materialized='table') }}

with aggregated as (
    select
        creative_id,
        channel,
        sum(spend_usd) as total_spend,
        sum(impressions) as total_impressions,
        sum(clicks) as total_clicks,
        sum(installs) as total_installs,
        sum(attributed_revenue) as total_revenue,
        sum(attributed_purchases) as total_purchases
    from {{ ref('int_marketing_attributed') }}
    group by 1, 2
)
select
    a.*,
    c.concept_theme,
    c.creative_type,
    -- Розрахунок метрик
    a.total_clicks / nullif(a.total_impressions, 0) as ctr,
    a.total_spend / nullif(a.total_installs, 0) as cpi,
    a.total_spend / nullif(a.total_purchases, 0) as cpp,
    a.total_revenue / nullif(a.total_spend, 0) as roas,
    (a.total_revenue - a.total_spend) as profit,
    ((a.total_revenue - a.total_spend) / nullif(a.total_spend, 0)) * 100 as romi
from aggregated a
left join {{ ref('stg_creatives') }} c on a.creative_id = c.creative_id