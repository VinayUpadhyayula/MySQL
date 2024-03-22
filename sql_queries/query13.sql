select cid,concat(first_name,last_name) as cust_name from customers c where 
(
  select count(*) from (select distinct pr.payment from purchases pr where cid = c.cid)
  )>1;
