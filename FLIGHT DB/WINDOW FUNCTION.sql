select * from passenger limit 10
select * from booking limit 10
select * from payment limit 10
select * from payment P 
JOIN booking B on b.id = p.bookingid
limit 10


select distinct company from booking limit 10
select count(distinct cardnumber),count(cardnumber) from payment limit 10

select * from passenger p 
RIGHT JOIN booking b on b.userid = p.ID
where p.id is null and b.userid is not null
limit 50

select min(id), max(id) from passenger p ;
select min(contactid), max(contactid) from booking b;
select min(userid), max(userid) from booking b;

-- WINDOW FUNCTION
-- EXAMPLE 1
-- Her bir kartın toplam sipariş sayısını ve sipariş miktarını iki ek sütun olarak getiriniz. Beklenen çıktı:

-- Retrieve the total number of orders and order amounts for each card as two additional columns. Expected output:

-- "id"	"bookingid"	"amount"	"cardnumber"	"paymentdate"	"customers_total_sale"	"total_booking_count"
-- 129730	248300	30	"037442xxxxxxxxxx"	"2021-04-28 21:02:00"	210	4
select 
id, 
bookingId
,amount
,cardnumber
,paymentdate
, SUM(amount) OVER (PARTITION BY cardnumber) AS Customers_Total_Sale
, COUNT(*) OVER (PARTITION BY cardnumber) AS Total_Booking_Count
from payment
-- order by 6 desc
limit 100

-- EXAMPLE 2
-- Ay ve kart bazlı gruplandırma.
-- Grouping by month and card.

select 
date_part('month',paymentdate) as month_
-- ,amount
,sum(amount)
-- ,cardnumber
-- ,paymentdate
-- , SUM(amount) OVER (PARTITION BY date_part('month',paymentdate)) AS CustomersTotalSale
-- , SUM(amount) OVER (PARTITION BY cardnumber, date_part('month',paymentdate)) AS Monthly_Sale
from payment
GROUP BY 1
-- order by 6 desc
limit 1000

-- EXAMPLE 3
-- ROW number ile kart bazlı toplam satışı gruplandırıp numaralandırın. Beklenen çıktı:
-- Group the total sales by card and assign row numbers. Expected output:

-- "row_number_"	"cardnumber"		"total_sale"
-- 	1				"037442xxxxxxxxxx"		70
-- 	2				"037442xxxxxxxxxx"		55
select 
ROW_NUMBER() OVER (PARTITION BY cardnumber ORDER BY paymentdate) AS row_number_
,cardnumber
-- ,count(cardnumber) as total_orders
,sum(amount) as Total_Sale
from payment
GROUP BY 2, paymentdate
limit 1000

-- EXAMPLE 4
-- her müşterinin mevcut alım miktarı ve bir önceki alımı miktarını yan yana listeleyin. 
-- Boşsa 0 gelsin. İlk 100 kayıt yeterlidir. Beklenen çıktı:

-- List the current purchase amount and the previous purchase amount for each customer side by side.
-- If it's empty, show 0. The first 100 records are enough. Expected output:

-- "id"	"cardnumber"	"paymentdate"	"amount"	"last_buy_amount"
-- 275094	"037442xxxxxxxxxx"	"2020-08-31 12:30:00"	70	0
-- 224985	"037442xxxxxxxxxx"	"2020-09-28 12:02:00"	55	70

select 
id
,cardnumber
,paymentdate
,amount
,LAG(amount, 1, 0) OVER (PARTITION BY cardnumber ORDER BY paymentdate) AS last_buy_amount
from payment
limit 100

-- EXAMPLE 5
-- her müşterinin mevcut alım miktarı ve bir önceki alımı miktarındaki değişimi listeleyin. 
-- Boşsa 0 gelsin. İlk 100 kayıt yeterlidir. Beklenen çıktı:

-- List the current purchase amount and the change in the previous purchase amount for each customer.
-- If it's empty, show 0. The first 100 records are enough. Expected output:

-- "id"	"cardnumber"	"paymentdate"	"change_amount"
-- 275094	"037442xxxxxxxxxx"	"2020-08-31 12:30:00"	70
-- 224985	"037442xxxxxxxxxx"	"2020-09-28 12:02:00"	-15
select 
id
,cardnumber
,paymentdate
,amount - LAG(amount, 1, 0) OVER (PARTITION BY cardnumber ORDER BY paymentdate) AS change_amount
-- ,LEAD(amount, 1, 0) OVER (PARTITION BY cardnumber ORDER BY paymentdate) - amount AS change_amount2
from payment
limit 100


-- Bir id birden fazla tekrarlıyor mu, generic sorgusu:
-- Is an ID repeating multiple times? Generic query:

select contactid
,count(*)
from booking 
GROUP BY contactid
HAVING count(*) > 1


-- Yolcuları yaşlarına göre sınıflandırıp ortalama ödeme tutarı en yüksek olandan en düşük olana göre sıralayınız.
-- Yaş aralıkları: 22-32, 33-42, 42+
-- yolcular en çok hangi yaş grubunda rezervasyon yaptırmaktadır?

-- Classify passengers by age and sort from the highest to the lowest average payment amount.
-- Age ranges: 22-32, 33-42, 42+
-- In which age group do passengers make the most reservations?
-- 1. çözüm - SOLUTION 1

WITH customer_age AS(
select 
current_date
,dateofbirth
,(current_date - dateofbirth)/365 as cust_age
, EXTRACT (YEAR FROM AGE(current_date, dateofbirth)) as yas_2
, p.*
from passenger p 

)
SELECT  
CASE WHEN cust_age BETWEEN 22 AND 32 THEN '22-32'
	WHEN cust_age BETWEEN 33 AND 42 THEN '22-32'
	WHEN cust_age> 42 THEN '42+'
	END AS age_segment
,count(id) passenger_count
,count(distinct bookingid) AS booking_count
FROM customer_age 
GROUP BY 1
limit 100

-- Ödemesi ile rezervasyonu aynı gün olan müşteriler, toplam müşterilerin yüzde kaçını oluşturmaktadır?
-- BENİM başarısız denemem :)
-- What percentage of total customers completed both payment and reservation on the same day?
-- My unsuccessful attempt :)

WITH day_diff as(select 
					b.contactid
					,P.paymentdate
					,B.bookingdate
					, EXTRACT (DAY FROM P.paymentdate) as payment_day
					, EXTRACT (DAY FROM B.bookingdate) as booking_day
					from payment P 
					LEFT JOIN booking B on b.id = p.bookingid)
SELECT
count(payment_day-booking_day)
,count(payment_day)
FROM day_diff
-- limit 100

-- HOCANIN CEVABI
-- KEŞİF
-- Teacher's Answer
-- Discovery

WITH day_diff as(select 
					b.contactid
					,P.paymentdate::date
					,B.bookingdate::date
					from payment P 
					LEFT JOIN booking B on b.id = p.bookingid
				 	WHERE P.paymentdate::date=B.bookingdate::date
-- 				 limit 100
				)

-- HAMLE
-- Action/Move

WITH total_contacts as (SELECT 
					COUNT(DISTINCT contactid) count_total
					from  booking B 
					),
	same_day_total_contacts AS ( SELECT
					COUNT(DISTINCT contactid) as count_sd
					from payment P 
					LEFT JOIN booking B on b.id = p.bookingid
				 	WHERE P.paymentdate::date = B.bookingdate::date
					)
SELECT count_sd*1.0 / count_total*1.0 AS same_day_customer_rate
FROM total_contacts, same_day_total_contacts

-- Her müşterinin ilk rezervasyon tarihini bulunuz!
-- Find the first reservation date for each customer!

SELECT 
	contactid
	,MIN(bookingdate) first_booking
	from  booking B 
GROUP BY contactid
ORDER BY contactid
LIMIT 1000

SELECT 
	contactid
	,bookingdate
	,ROW_NUMBER() OVER (PARTITION BY contactid ORDER BY bookingdate) booking_no
	,RANK() OVER (PARTITION BY contactid ORDER BY date_trunc('day', bookingdate)) booking_rank
	,MIN(bookingdate) OVER (PARTITION BY contactid) first_booking
	from  booking B 
ORDER BY contactid
LIMIT 1000

-- Her müşterinin ikinci rezervasyon tarihini bulunuz!
-- Find the second reservation date for each customer!


with reservations as (
	-- önce tablocukta row numbers sıralarız.
	-- First, we sort the row numbers in the small table.

SELECT 
	contactid
	,bookingdate
	,ROW_NUMBER() OVER (PARTITION BY contactid ORDER BY bookingdate) booking_no
	,RANK() OVER (PARTITION BY contactid ORDER BY date_trunc('day', bookingdate)) booking_rank
	,MIN(bookingdate) OVER (PARTITION BY contactid) first_booking
	from  booking B 
ORDER BY contactid
)
-- sonra ikinci işlemleri filtreleriz.
-- Then we filter the second transactions.

SELECT * FROM reservations r 
where booking_no=2


-- müşterilerin mevcut, bir önceki ve bir sonraki rezervasyon tarihleri:
-- The current, previous, and next reservation dates for customers:


SELECT 
	contactid
	,contactemail
	,company
	,bookingdate
	,LAG(bookingdate) OVER (PARTITION BY contactid ORDER BY bookingdate) prev_booking_date
	,LEAD(bookingdate) OVER (PARTITION BY contactid ORDER BY bookingdate) next_booking_date
from  booking B 


with data_ AS
(
	SELECT 
		contactid
		,contactemail
		,company
		,bookingdate
		,LAG(bookingdate) OVER (PARTITION BY contactid ORDER BY bookingdate) prev_booking_date
		,LEAD(bookingdate) OVER (PARTITION BY contactid ORDER BY bookingdate) next_booking_date
	from  booking B 
)
select prev_booking_date
,next_booking_date
, CASE WHEN prev_booking_date IS NULL THEN interval '0 day'
ELSE AGE(next_booking_date,prev_booking_date) end as prev_next_difference
FROM data_
where next_booking_date is not null

-- Her bir müşterinin en fazla ödeme yaptığı company'i o müşterinin companysi olarak belirleyiniz.
-- WITH içindeki tablocukları sıralı olarak birbirine veri aktaracak şekilde kullanabiliyoruz!
-- Determine the company where each customer made the highest payment as their associated company.
-- We can use the small tables inside WITH to pass data sequentially to each other!


-- FARKLI ŞEHİR SORUSU!
-- A. sayı olarak fazla olanlar mı, toplam olarak fazla olanlar mı?:
-- STEP 1: sayı-tutar karşılaştırması için gruplamayı yapıyor.
-- Different City Question!
-- A. Do we focus on the larger count or the total?:
-- STEP 1: It groups for comparison by count and total amount.


WITH stage_1 AS
(SELECT 
		contactid
		,company
		,sum(amount) AS sum_amount
		,count(contactid)
	from  payment P 
JOIN booking B on b.id = p.bookingid
GROUP BY 1,2
ORDER BY 1,2
),
-- B. amount daha mantıklı gibi
--  STEP 2: amount a göre yüksekten alçağa sıralıyor.
-- B. Focusing on the amount seems more logical
--  STEP 2: Sort by amount from highest to lowest.

company_payments AS
(
	-- çekim başarılı işlemlerden gitmeliyiz.
	-- We should focus on successful payment transactions.

	SELECT 
		contactid
		,company
		,sum_amount
		,ROW_NUMBER() OVER (PARTITION BY contactid order by sum_amount DESC) payment_order
	from  stage_1
)
--  STEP 3: en yüksek amountu filtreliyor.
-- STEP 3: Filter for the highest amount.

SELECT * FROM company_payments
WHERE payment_order = 1


-- POSTGRE SQL SAYFASINDAN ÖRNEKLER
-- STEP 3: Filter for the highest amount.

SELECT sum(salary) OVER w, avg(salary) OVER w
  FROM empsalary
  WINDOW w AS (PARTITION BY depname ORDER BY salary DESC);
  
  
SELECT depname, empno, salary, enroll_date
FROM
  (SELECT depname, empno, salary, enroll_date,
          rank() OVER (PARTITION BY depname ORDER BY salary DESC, empno) AS pos
     FROM empsalary
  ) AS ss
WHERE pos < 3;

SELECT salary, sum(salary) OVER () FROM empsalary;

SELECT depname, empno, salary,
       rank() OVER (PARTITION BY depname ORDER BY salary DESC)
FROM empsalary;