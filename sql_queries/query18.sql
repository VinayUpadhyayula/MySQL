select p.pid, p.name as product_name, pr.quantity as  "total quantity sold" from products p , purchases pr
 where p.pid = pr.pid and pr.quantity=(
    select max(quantity) from purchases
 );