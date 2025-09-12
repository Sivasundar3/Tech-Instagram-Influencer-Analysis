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