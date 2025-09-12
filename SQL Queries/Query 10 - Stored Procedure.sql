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
