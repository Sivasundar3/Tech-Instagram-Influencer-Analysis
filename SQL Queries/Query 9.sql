/* 9. List the top three dates in each month with the highest number of new followers. The final output should include the following columns:
                                                   • month
                                                   • date
                                                   • new_followers */


with top_three_dates as
(
select d.month_name,
	   d.date,
       fa.new_followers,
       rank() over(partition by d.month_name order by fa.new_followers desc) as rank_number
from gdb0120.dim_dates d
join gdb0120.fact_account fa on d.date = fa.date
)
select 
       month_name,
       date,
       new_followers
from top_three_dates
where rank_number<= 3
ORDER BY 
	 CASE 
        WHEN month_name = 'January' THEN 1
        WHEN month_name = 'February' THEN 2
        WHEN month_name = 'March' THEN 3
        WHEN month_name = 'April' THEN 4
        WHEN month_name = 'May' THEN 5
        WHEN month_name = 'June' THEN 6
        WHEN month_name = 'July' THEN 7
        WHEN month_name = 'August' THEN 8
        WHEN month_name = 'September' THEN 9
        WHEN month_name = 'October' THEN 10
        WHEN month_name = 'November' THEN 11
        WHEN month_name = 'December' THEN 12
 END ASC;
