select pur#,name as "product name", to_char(pur_time,'Month DD,YYYY Day') pur_date, payment, saving from Purchases pr, Products p where p.pid = pr.pid;