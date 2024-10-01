select * from passenger limit 10
select * from booking limit 10
select * from payment limit 10


-- 5000 den büyük satışları görüntülemek için
-- To display sales greater than 5000


WITH employee_sales as 
	(select bookingid
	,sum(amount) total_sales
	from payment
	group by bookingid)
	
select * from employee_sales
where total_sales > 5000



-- company aa olan 5000 den büyük satışları görüntülemek için
-- To display sales greater than 5000 for company aa

WITH employee_sales as 
	(select bookingid
		,sum(amount) as total_sales
		from payment
		where bookingid in
			   (
				SELECT id
				   FROM booking
				   where company = 'AA'
			   )
	 	group by bookingid
	)
	
select * from employee_sales
where total_sales > 5000


-- UNION kullanarak yapımı
-- Implementation using UNION

WITH employee_sales as 
	(select company
		,count(id) as company_count
		from booking
		where company = 'AA'
	 	group by company
	 UNION
	 select company
		,count(id) as company_count
		from booking
		where company = 'BB'
	 	group by company
	)
	
select * from employee_sales
where company_count > 50000

-- çoklu operatör kullanımı
-- Usage of multiple operators

WITH employee_sales as 
	(
	select bookingid
		,sum(amount) as total_sales
		from payment P
	 JOIN booking B on B.id = P.bookingid
	 where company = 'AA'
	 group by bookingid
	 HAVING sum(amount) > 5000
	)
select * from employee_sales


-- HER müşterinin kaç tane siparişi var ve her siparişteki YOLCU sayısını saydırıp yazdırınız:
-- Count and display how many orders each customer has and the number of passengers in each order:


WITH booking_count AS 
(
	select contactid
		,count(id) AS booking_count
		from booking
		GROUP BY contactid
)
, passenger_count AS (
	-- ikinci tabloCUK
	-- second small table

	select bookingid
		,count(DISTINCT id) AS passengers
		from PASSENGER
		GROUP BY bookingid
)
SELECT 
b.id
,b.contactid
,company
,bookingdate
,bc.booking_count
,pc.passengers
 from booking b
LEFT JOIN booking_count bc on bc.contactid = b.id
LEFT JOIN passenger_count pc on pc.bookingid = b.id
LIMIT 500