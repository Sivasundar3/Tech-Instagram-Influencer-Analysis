with reach_contribution as
(
select post_type,
	   sum(reach) as total_reach ,
	   (select sum(reach) from gdb0120.fact_content)as total
      -- round(sum(reach)*100.0 /total,2) as reach_percentage
from gdb0120.fact_content    
group by post_type
)
select post_type,
       total_reach,
       round(total_reach*100.0 / total,2) as reach_percentage
from reach_contribution
order by reach_percentage desc
