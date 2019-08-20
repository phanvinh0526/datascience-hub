---------------------------
-- RE: + operator
---------------------------
select *
from salesperson
where regexp_like(last_name, 'a+')

---------------------------
-- RE: ? and * symbol
---------------------------
select *
from salesperson
where regexp_like(address_line1, 'wo?d')
-- Can be: wd , wod, woood, woooooood . => ?: can be null / more occurencies followed by d

---------------------------
-- RE: matching characters in a list
---------------------------
select *
from salesperson
where regexp_like(city, '[wmf]') 
select *
from salesperson
where regexp_like(city, '[^Aatln]') -- at least 1 character outside the list: A, a, t, l, n
select *
from salesperson
where regexp_like(lower(city), '[^a-t]') -- at least 1 character outside the range
