select eid, name as e_name from employees e where not exists
(
   select * from purchases where eid = e.eid
);