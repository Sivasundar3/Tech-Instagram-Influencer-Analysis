select d.month_name , 
       d.weekday_or_weekend,
       d.weekday_name, 
       f.*
from gdb0120.dim_dates d
join gdb0120.fact_content f on 
     d.date = f.date
where d.month_name in ('March', 'April') && 
      d.weekday_or_weekend ="Weekend"
