with daily_totals as (
    select 
        report_date, 
        creative_id, 
        sum(installs) as total_daily_installs
    from {{ ref('stg_marketing_stats') }}
    group by 1, 2
),
daily_purchases as (
    select 
        purchase_date, 
        creative_id, 
        sum(revenue_usd) as daily_revenue,
        count(user_id) as daily_purchases_count
    from {{ ref('stg_purchases') }}
    group by 1, 2
)
select
    s.*,
    s.installs / nullif(d.total_daily_installs, 0) as install_share,
    coalesce(p.daily_revenue, 0) * (s.installs / nullif(d.total_daily_installs, 0)) as attributed_revenue,
    coalesce(p.daily_purchases_count, 0) * (s.installs / nullif(d.total_daily_installs, 0)) as attributed_purchases
from {{ ref('stg_marketing_stats') }} s
left join daily_totals d 
    on s.report_date = d.report_date and s.creative_id = d.creative_id
left join daily_purchases p 
    on s.report_date = p.purchase_date and s.creative_id = p.creative_id