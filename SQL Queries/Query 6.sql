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
