select concat(first_name,last_name) as c_name
 from customers c where c.phone# like '666%' and exists
 (
    select * from purchases pr where to_char(pr.pur_time, 'Month/YYYY') = 'October/2022'
 );