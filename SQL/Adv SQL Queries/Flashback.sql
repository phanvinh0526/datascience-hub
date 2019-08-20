---------------------------
-- Flashback: see the data in x time back
---------------------------
select *
from customer as of timestamp to_timestamp('2019-08-10 11:15:00', 'YYYY-MM-DD HH24:MI:SS');
update customer set region = 'SOUTH' where customer_id = 12



select *
from customer as of timestamp TO_TIMESTAMP('2019/08/10 11:16:10', 'YYYY/MM/DD HH:MI:SS');
select * from customer 
as of timestamp TO_TIMESTAMP('2019/08/10 10:13:18', 'YYYY/MM/DD HH:MI:SS')
set NLS_DATE_FORMAT;
ALTER SESSION SET nls_date_format = 'dd-mm-yyyy hh24:mi:ss';
reset;
