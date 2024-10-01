select * from booking limit 10;
select * from payment limit 10;
select * from passenger limit 10


select distinct cardtype from payment limit 10
--  Ödeme tarihi (paymentdate) 2020-01-06 olan rezervasyonları (booking) listeleyiniz.
--  List the bookings with a payment date (paymentdate) of 2020-01-06.

select * from booking 
WHERE id IN (
select bookingid from payment WHERE
	paymentdate::date = '2020-01-06'
)


--  Ödeme tarihi (paymentdate) 2020-01-06 olan rezervasyonların (booking) ödeme tutarları (amount) listeleyiniz.
--  List the payment amounts (amount) for the bookings with a payment date (paymentdate) of 2020-01-06.

select contactid, company, bookingdate, P.amount from booking B
INNER JOIN (
select bookingid, amount from payment WHERE
	paymentdate::date = '2020-01-06'
) AS P
ON P.bookingid = B.id


-- Ortalamanın üzerindeki satışlar için:
-- For sales above the average:

select cardtype
, sum(amount)
from payment 
GROUP BY cardtype
HAVING SUM(amount) > (
SELECT AVG(amount) FROM payment 
-- 	WHERE paymentstatus = 'ÇekimBaşarılı'
	WHERE cardtype ='KrediKartı'
)

-- çalışmadı, her müşterinin toplam harcamasını alıp, 1000 üstünde olanları bulmaya çalışıyordu.
-- It didn’t work, it was trying to retrieve the total spending for each customer and find those above 1000.

-- select bookingid, name, (
-- select payment.bookingid 
-- 	from payment, passenger 
-- 	WHERE payment.bookingid = passenger.bookingid
-- 	GROUP BY payment.bookingid
-- ) as total_spent
-- from passenger
-- WHERE total_spent>1000

-- çalışmadı
-- it did not work
select 
id
,(SELECT SUM(amount) FROM payment WHERE bookingid = outer_query.id) as quantity_sold
from booking as outer_query
GROUP BY id
HAVING quantity_sold > 500



-- 100010 numaralı ödemeye ait müşteri bilgileri ve diğer sipariş bilgileri.
-- Customer information and other order details for the payment with number 100010.

SELECT
C.bookingid
,name
,payment.amount
from passenger C
JOIN payment 
ON C.bookingid = (SELECT bookingid from payment WHERE id =100010)






