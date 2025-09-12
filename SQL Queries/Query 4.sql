/* 4. Create a report to get the statistics for the account. The final output includes the following fields:
                                       • month_name
                                       • total_profile_visits
                                       • total_new_followers */


select d.month_name,
	   sum(fa.profile_visits) as total_profile_visits,
       sum(fa.new_followers) as total_new_followers
from gdb0120.dim_dates d
join gdb0120.fact_account fa on 
     d.date = fa.date
group by d.month_name
