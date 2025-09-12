select d.month_name,
	   sum(fa.profile_visits) as total_profile_visits,
       sum(fa.new_followers) as total_new_followers
from gdb0120.dim_dates d
join gdb0120.fact_account fa on 
     d.date = fa.date
group by d.month_name
