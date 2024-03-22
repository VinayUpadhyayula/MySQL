select eid, name as e_name from employees where eid not in
(
   select eid from purchases
);