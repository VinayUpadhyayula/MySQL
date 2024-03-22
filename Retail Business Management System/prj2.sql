set serveroutput on
create or replace package prj2 as
    type ref_cursor is ref cursor;
    function display_employees
    return ref_cursor;
    function display_customers
    return ref_cursor;
    function display_products
    return ref_cursor;
    function display_prd_discnts
    return ref_cursor;
    function display_purchases
    return ref_cursor;
    function display_logs
    return ref_cursor;
    procedure add_employee
    (e_id in employees.eid%type,
     e_name in employees.name%type,
     e_telephone# in employees.telephone#%type,
     e_email in employees.email%type);
    procedure add_purchase
    (
        e_id in purchases.eid%type,
        p_id in purchases.pid%type,
        c_id in purchases.cid%type,
        pur_qty in purchases.quantity%type,
        unit_price in purchases.unit_price%type
    );
    -- function display_all(table_name in varchar2)
    --   return ref_cursor;
    function monthly_sale_activities(emp_id in employees.eid%type)
    return ref_cursor;
  end;
/
show errors
create or replace package body prj2 as
    function display_employees return ref_cursor is
    emp_cursor ref_cursor;
    begin
        open emp_cursor 
        for select * from employees;

        return emp_cursor;
    end;
    function display_customers return ref_cursor is
    cust_cursor ref_cursor;
    begin
        open cust_cursor 
        for select * from customers;

        return cust_cursor;
    end;
    function display_products return ref_cursor is
    prd_cursor ref_cursor;
    begin
        open prd_cursor 
        for select * from products;

        return prd_cursor;
    end;
    function display_prd_discnts return ref_cursor is
    prd_discnt_cursor ref_cursor;
    begin
        open prd_discnt_cursor 
        for select * from prod_discnt;

        return prd_discnt_cursor;
    end;
    function display_purchases return ref_cursor is
    pr_cursor ref_cursor;
    begin
        open pr_cursor 
        for select * from purchases;

        return pr_cursor;
    end;
    function display_logs return ref_cursor is
    log_cursor ref_cursor;
    begin
        open log_cursor 
        for select * from logs;

        return log_cursor;
    end;

  
    procedure add_employee
    (e_id in employees.eid%type,
     e_name in employees.name%type,
     e_telephone# in employees.telephone#%type,
     e_email in employees.email%type) is
    begin
      insert into employees values(e_id, e_name, e_telephone#, e_email);
    end;

  
    procedure add_purchase
      (
        e_id in purchases.eid%type,
        p_id in purchases.pid%type,
        c_id in purchases.cid%type,
        pur_qty in purchases.quantity%type,
        unit_price in purchases.unit_price%type
      ) is
      qoh products.qoh%type;
      orig_price products.orig_price%type;
      payment purchases.unit_price%type;
      savings purchases.unit_price%type;
      begin
        dbms_output.enable();
        select qoh, orig_price into qoh, orig_price
        from products
        where pid = p_id; 
        if (pur_qty > qoh) then
          dbms_output.put_line('Insufficient quantity in stock.');
        else
          insert into purchases values(purchase#.nextval,e_id, p_id, c_id, SYSDATE, pur_qty, unit_price, pur_qty * unit_price
          , pur_qty * (orig_price - unit_price));
        end if;
    end;


   function monthly_sale_activities (
    emp_id in employees.eid%type) return ref_cursor is
    sale_cursor ref_cursor;
    begin
    dbms_output.enable();
    open sale_cursor
     for
        SELECT e.eid as employee_id,
               e.name as employee_name,
               to_char(p.pur_time, 'MON') as month,
               to_char(p.pur_time, 'YYYY') as year,
               count(*) as sales_count,
               sum(p.quantity) as total_quantity_sold,
               sum(p.payment) as total_sales_amount
        from employees e
        inner join purchases p on e.eid = p.eid
        where e.eid = emp_id
        group by e.eid, e.name, to_char(p.pur_time, 'MON'), to_char(p.pur_time, 'YYYY');
     return sale_cursor;
    end;
  end;
/
show errors
