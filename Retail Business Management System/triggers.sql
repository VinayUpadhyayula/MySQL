set serveroutput on
create or replace trigger new_employee
after insert on employees
for each row
begin
  insert into logs values(log#.nextval,USER,'INSERT',SYSDATE,'employees',:new.eid);
    dbms_output.put_line('done.');
end;
/
create or replace trigger new_purchase
after insert on purchases
for each row
declare
  qoh products.qoh%type;
  qoh_threshold products.qoh_threshold%type;
  p_id products.pid%type;
  visits_made customers.visits_made%type;
  last_visit_date customers.last_visit_date%type; 
begin
  dbms_output.enable();
  insert into logs values(log#.nextval,USER,'INSERT',SYSDATE,'purchases',:new.pur#);
  dbms_output.put_line('done.');
  select products.qoh, products.qoh_threshold, products.pid into qoh, qoh_threshold, p_id
  from products where pid = :new.pid;
  if ((qoh - :new.quantity)< qoh_threshold) then
    dbms_output.put_line('The current qoh of the product is below the required threshold and new supply is required.');
    update products
    SET qoh = qoh_threshold + 20
    where products.pid = p_id;
  else
    update products
    SET qoh = qoh - :new.quantity
    where products.pid = p_id;
  end if;
  select customers.visits_made, customers.last_visit_date into visits_made, last_visit_date
  from customers where cid = :new.cid;

  update customers
  SET visits_made = visits_made + 1
  where customers.cid = :new.cid;

  if(last_visit_date != :new.pur_time) then
    update customers
    SET last_visit_date = :new.pur_time
    where customers.cid = :new.cid;
  end if;
  select qoh into qoh from products where pid = :new.pid;
  dbms_output.put_line('New qoh for this product is updated to ' || to_char(qoh));
  end;
/
show errors
create or replace trigger cust_last_visit_date
after update of last_visit_date on customers
for each row
begin
  insert into logs values(log#.nextval,USER,'update',SYSDATE,'customers',:new.cid);
end;
/
create or replace trigger cust_visits_made
after update of visits_made on customers
for each row
begin
  insert into logs values(log#.nextval,USER,'update',SYSDATE,'customers',:new.cid);
end;
/
create or replace trigger prd_qoh
after update of qoh on products
for each row
begin
  insert into logs values(log#.nextval,USER,'update',SYSDATE,'products',:new.pid);
end;
/
show errors