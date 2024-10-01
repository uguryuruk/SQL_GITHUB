-- ENUYGUN DATE DÖNÜŞÜM
-- CAST
SELECT bookingdate --timestamp
,CAST(bookingdate AS date)
,bookingdate::date
FROM booking

-- TO_CHAR
SELECT bookingdate --timestamp
,TO_CHAR(bookingdate, 'YYYY-MM') year_month
,TO_CHAR(bookingdate, 'YY-MM') year2_month
,TO_CHAR(bookingdate, 'Day') day_name
,TO_CHAR(bookingdate, 'DD') day_number
FROM booking
-- YIL FİLTRELEMESİNDE FAYDALI
-- Useful for filtering by year

where to_char( bookingdate,'YYYY') = '2020'
limit 50


--AYLIK OLARAK REZERVASYON SAYISINI İNCELEYİNİZ
-- Examine the number of reservations on a monthly basis

SELECT 
TO_CHAR(bookingdate, 'YYYY-MM') year_month
,COUNT(*)
FROM booking
GROUP BY 1
ORDER BY 1


-- Bir müşteri En son kaç gün önce işlem yaptı?
-- How many days ago did a customer last make a transaction?

SELECT 
current_date
,bookingdate::date
,current_date - bookingdate::date
FROM booking
limit 50

-- Bir müşteri En son kaç gün kaç saat önce işlem yaptı?
-- How many days and hours ago did a customer last make a transaction?

SELECT 
current_timestamp
,bookingdate
,current_timestamp - bookingdate
FROM booking
limit 50


-- Date olarak ay bilgisini almak için
-- To retrieve the month information as a date

SELECT 
date_trunc('month', bookingdate) year_month
,COUNT(*)
FROM booking
GROUP BY 1
ORDER BY 1

-- Date olarak yıllara göre rezervasyon
-- Reservations by year as a date

SELECT 
date_trunc('year', bookingdate) year_
,COUNT(*)
FROM booking
GROUP BY 1
ORDER BY 1


-- EXTRACT: sadece tek parçayı alabilir.
-- EXTRACT: can only retrieve a single part.

SELECT 
EXTRACT(YEAR FROM bookingdate) year_
,EXTRACT(MONTH FROM bookingdate) month_
,COUNT(*)
FROM booking
GROUP BY 1, 2
ORDER BY 1, 2


SELECT
bookingdate
,EXTRACT(QUARTER FROM bookingdate) Q1
,EXTRACT(WEEK FROM bookingdate) week
FROM booking
limit 500


-- İKİ tarih arasındaki farkı bulunuz
-- Find the difference between two dates

SELECT AGE('2022-12-05'::date, '2022-01-01'::date) fark_interval
SELECT '2022-12-05'::date - '2022-01-01'::date fark_gun

-- üyelerin rezervasyon tarihi ile üyelik tarihi arasındaki farkı bulunuz:
-- Find the difference between the members' reservation date and their membership date


SELECT 
AGE(bookingdate, userregisterdate)
FROM booking
WHERE userregisterdate is not null
order by 1
limit 500


-- rezervasyon tarihinden 1 ay önceki tarihi getiriniz
-- Retrieve the date one month prior to the reservation date

SELECT 
bookingdate
,bookingdate - INTERVAL '1 month' one_month_ago
FROM booking
limit 500

-- rezervasyon tarihinden 2 hafta önceki tarihi getiriniz
-- Retrieve the date two weeks prior to the reservation date

SELECT 
bookingdate
,bookingdate - INTERVAL '2 weeks' two_weeks_ago
FROM booking
limit 500

-- kayıt olduktan sonra 40 gün içerisinde rezervasyon yapan müşterileri getiriniz.
-- Retrieve the customers who made a reservation within 40 days after registering

SELECT
contactid
,userregisterdate::DATE
,bookingdate::DATE
,(userregisterdate + INTERVAL '40 days')::DATE _40_days_later
, bookingdate::DATE - userregisterdate::DATE days_diff
FROM booking
WHERE userregisterdate IS NOT NULL
AND bookingdate <= userregisterdate + INTERVAL '40 days'
AND bookingdate >= userregisterdate
limit 500


-- NOW: time zone içerir.
-- NOW: includes the time zone.

select now();

-- aynı gün hem üye olup hem rezervasyon yapan müşterilerin ay kırılımında analizini yapınız.
-- Analyze, by month, the customers who both registered and made a reservation on the same day.


SELECT 
date_trunc('month', bookingdate)::date
,count(id)
-- userregisterdate
-- ,bookingdate
FROM booking
WHERE date_trunc('day', userregisterdate) = date_trunc('day', bookingdate)
GROUP by 1
ORDER BY 1


-- 2.çözüm flag ile
-- Second solution using a flag

WITH all_data as ( 
	SELECT CONTACTID,
		USERREGISTERDATE,
		BOOKINGDATE,
		CASE WHEN DATE_TRUNC('day',	USERREGISTERDATE) = DATE_TRUNC('day', BOOKINGDATE) THEN 1
		ELSE 0
		END AS SAME_DAY_FLAG
	FROM BOOKING
	WHERE USERREGISTERDATE IS NOT NULL
)
select * from all_data
where SAME_DAY_FLAG = 1