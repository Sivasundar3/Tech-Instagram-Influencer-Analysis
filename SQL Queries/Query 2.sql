select
post_type,
max(impressions) as highest_impression,
min(impressions) as lowest_impression
from gdb0120.fact_content
group by post_type 


