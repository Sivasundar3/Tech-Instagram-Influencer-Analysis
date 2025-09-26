# 1. How many unique post types are found in the 'fact_content' table?

select distinct(post_type) as unique_post_type
from gdb0120.fact_content;



# 2. What are the highest and lowest recorded impressions for each post type?

select
post_type,
max(impressions) as highest_impression,
min(impressions) as lowest_impression
from gdb0120.fact_content
group by post_type 



# 3. Filter all the posts that were published on a weekend in the month of March and April and export them to a separate csv file.

select d.month_name , 
       d.weekday_or_weekend,
       d.weekday_name, 
       f.*
from gdb0120.dim_dates d
join gdb0120.fact_content f on 
     d.date = f.date
where d.month_name in ('March', 'April') && 
      d.weekday_or_weekend ="Weekend"



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



/* 5. Write a CTE that calculates the total number of 'likes’ for each 'post_category' during the month of 'July' and subsequently, 
	arrange the 'post_category' values in descending order according to their total likes. */
 

WITH likes_per_category AS (
    SELECT 
        fc.post_category,
        SUM(fc.likes) AS total_likes 
    FROM 
        gdb0120.dim_dates d
    JOIN 
        gdb0120.fact_content fc ON d.date = fc.date
    WHERE 
        d.month_name = 'July'
    GROUP BY 
        fc.post_category
)
SELECT 
    post_category,
    total_likes
FROM 
    likes_per_category
ORDER BY 
    total_likes DESC;



/* 6. Create a report that displays the unique post_category names alongside their respective counts for each month. The output should have three columns:
                                                                • month_name
                                                                • post_category_names
                                                                • post_category_count
Example:
• 'April', 'Earphone,Laptop,Mobile,Other Gadgets,Smartwatch', '5'
• 'February', 'Earphone,Laptop,Mobile,Smartwatch', '4'               */



SELECT 
    d.month_name,
    GROUP_CONCAT(DISTINCT fc.post_category ORDER BY fc.post_category SEPARATOR ', ') AS post_category_names,
    COUNT(DISTINCT fc.post_category) AS post_category_count
FROM 
    gdb0120.dim_dates d
JOIN 
    gdb0120.fact_content fc ON d.date = fc.date
GROUP BY 
    d.month_name
ORDER BY 
	 CASE 
        WHEN d.month_name = 'January' THEN 1
        WHEN d.month_name = 'February' THEN 2
        WHEN d.month_name = 'March' THEN 3
        WHEN d.month_name = 'April' THEN 4
        WHEN d.month_name = 'May' THEN 5
        WHEN d.month_name = 'June' THEN 6
        WHEN d.month_name = 'July' THEN 7
        WHEN d.month_name = 'August' THEN 8
        WHEN d.month_name = 'September' THEN 9
        WHEN d.month_name = 'October' THEN 10
        WHEN d.month_name = 'November' THEN 11
        WHEN d.month_name = 'December' THEN 12
 END ASC;



/*  7. What is the percentage breakdown of total reach by post type? The final output includes the following fields:
                                            • post_type
                                            • total_reach
                                            • reach_percentage */


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



/* 10. Create a stored procedure that takes the 'Week_no' as input and generates a report displaying the total shares for each 'Post_type'. 
     The output of the procedure should consist of two columns:
                                                         • post_type
                                                         • total_shares */


CREATE DEFINER=`root`@`localhost` PROCEDURE `GetSharesByPostType`(IN input_week_no VARCHAR(10))
BEGIN
    SELECT 
        fc.post_type,
        SUM(fc.shares) AS total_shares
    FROM 
        gdb0120.fact_content fc
    JOIN 
        gdb0120.dim_dates d ON fc.date = d.date
    WHERE 
        d.week_no = input_week_no
    GROUP BY 
        fc.post_type;
END

CALL GetSharesByPostType ('W3');
