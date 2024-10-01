select * from passenger limit 10
select * from booking limit 10
select * from payment limit 10

select distinct company from booking limit 10
select count(distinct cardnumber),count(cardnumber) from payment limit 10

select * from passenger p 
RIGHT JOIN booking b on b.userid = p.ID
where p.id is null and b.userid is not null
limit 50

select min(id), max(id) from passenger p ;
select min(contactid), max(contactid) from booking b;
select min(userid), max(userid) from booking b;

select *
from payment pay
JOIN booking b on b.id = pay.bookingid
limit 50