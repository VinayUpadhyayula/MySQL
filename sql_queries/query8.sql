select * from prod_discnt pd where not exists
(
    select * from products where discnt_category = pd.discnt_category
);