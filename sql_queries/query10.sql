select eid, name as emp_name from employees e where exists
(
    select * from products p where discnt_category = 3 and exists
    (
        select * from purchases pr where pid = p.pid and eid = e.eid
    )
);