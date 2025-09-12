# 1. How many unique post types are found in the 'fact_content' table?

select distinct(post_type) as unique_post_type
from gdb0120.fact_content;
