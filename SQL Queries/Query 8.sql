/* 8.Create a report that includes the quarter, total comments, and total saves recorded for each post category. Assign the following quarter groupings:
                         (January, February, March) → “Q1”
                         (April, May, June) → “Q2”
                         (July, August, September) → “Q3”

The final output columns should consist of:
                     • post_category
                     • quarter
                     • total_comments
                     • total_saves */


select fc.post_category,
       case when d.month_name in ('January' ,'February' , 'March') then 'Q1'
            when d.month_name in ('April' ,'May' , 'June') then 'Q2'
			when d.month_name in ('July' ,'August' , 'September') then 'Q3'
			when d.month_name in ('October' ,'November' , 'December') then 'Q4'
            end as quarter ,
	sum(comments) as total_comments,
	sum(fc.saves) as total_saves
from gdb0120.fact_content fc
join gdb0120.dim_dates d on d.date = fc.date
group by fc.post_category, quarter  
