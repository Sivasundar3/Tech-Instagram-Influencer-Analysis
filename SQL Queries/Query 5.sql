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
