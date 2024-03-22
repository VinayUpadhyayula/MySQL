select to_char(pur_time, 'YYYY/MM') Month, sum(payment) as "Total Sale" from purchases
 group by to_char(pur_time, 'YYYY/MM') order by to_char(pur_time, 'YYYY/MM');
