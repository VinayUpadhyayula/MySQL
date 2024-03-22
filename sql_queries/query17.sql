select c.cid , concat(c.first_name, c.last_name) as cust_name from customers c where c.visits_made>
(
    select count(c1.visits_made) from customers c1 where c1.phone# like '777%'
);