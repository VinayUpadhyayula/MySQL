select c.cid, c.first_name, 
  (select count(pr.pid) from purchases pr where pr.cid = c.cid) as count
from customers c;