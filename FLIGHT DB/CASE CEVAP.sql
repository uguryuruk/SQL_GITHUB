-- Veri Setinin Notları:
-- • Müşterileri contactID temsil ediyor.
-- • Sepet sayısı için bookingID, yolcu sayısı için passengerID baz alınmalıdır. (Bir sepette birden fazla
-- yolcu(passengerID) olabilirken sadece bir contactID olabilir.)
-- • Üye olmayan müşterilerin, üyelik tarihi boş bırakılmıştır.
-- • paymentstatusler için iadeler başarılı veya başarısız sayılmamalıdır.

-- Dataset Notes:
-- • Customers are represented by contactID.
-- • For the number of baskets, bookingID should be used, and for the number of passengers, passengerID should be used. (A basket can have more than one
-- passenger (passengerID), but only one contactID.)
-- • The membership date is left blank for non-member customers.
-- • Refunds should not be considered successful or unsuccessful for payment statuses.



-- 1. Ekteki excel dosyasını kullanarak DB yapısı ve diagramını oluşturunuz. 
-- a. Müşteri bazında toplam satış adetlerini, tutarları ve ortalama bilet fiyatlarını

-- 1. Using the attached Excel file, create the database structure and diagram. 
-- a. On a per-customer basis, calculate the total number of sales, amounts, and average ticket prices.


SELECT contactid,
        COUNT(b.id) as booking_count,
        SUM(amount) as total_amount,
        round(AVG(amount),2) as avg_amount
  FROM booking AS b
LEFT JOIN payment AS p ON b.id=p.bookingid
GROUP BY 1;


--Paymenstatus:
-- "İade"
-- "ÇekimHatalı"
-- "ÇekimBaşarılı"
;

SELECT contactid,
       count(CASE WHEN p.paymentstatus = 'ÇekimBaşarılı' THEN b.id END) AS succ_booking_count,
       count(b.id) AS total_booking_count,
       sum(CASE WHEN p.paymentstatus = 'ÇekimBaşarılı' THEN p.amount END) AS succ_total_amount,
       sum(amount) AS total_amount,
       avg(CASE WHEN p.paymentstatus = 'ÇekimBaşarılı' THEN p.amount END) AS succ_total_amount,
       round(avg(amount),2) AS avg_amount
  FROM booking AS b
  LEFT JOIN payment AS p
    ON b.id = p.bookingid
 GROUP BY 1;

-- b. 2020 yılında aylık olarak; environment kırılımlarında toplam yolcu ve sepet sayılarını
-- b. On a monthly basis in 2020; calculate the total number of passengers and baskets, broken down by environment.

 
SELECT 
      to_char(bookingdate,'YYYY-MM') as booking_month,
      environment,
      COUNT(DISTINCT p.id) as passenger_count,
      COUNT(DISTINCT b.id) as booking_count
FROM booking as b
LEFT JOIN passenger as p ON b.id=p.bookingid
WHERE date_trunc('year',bookingdate)='2020-01-01 00:00:00'
GROUP BY 1,2;

--121070 id'li rezervasyon, 12 tane passenger id'ye sahip.
-- The reservation with ID 121070 has 12 passenger IDs.

SELECT 
     *
FROM booking as b
LEFT JOIN passenger as p ON b.id=p.bookingid
WHERE b.id='121070';


-- c. Banka başarı oranlarını hesaplayarak, grafikte gösteriniz.
-- c. Calculate the bank success rates and display them in a graph.


SELECT cardtype,
       count(CASE WHEN paymentstatus = 'ÇekimBaşarılı' THEN id END) AS succ_payment_count,
       count(id) AS payment_count,
       (count(CASE WHEN paymentstatus = 'ÇekimBaşarılı' THEN id END))*1.0 / (count(id))*1.0 as succ_rate
  FROM payment
 WHERE paymentstatus != 'İade'
 GROUP BY 1
;


with succ_pay as
(
SELECT cardtype,
       count(id) AS payment_count
  FROM payment
 WHERE paymentstatus = 'ÇekimBaşarılı'
 GROUP BY 1
),
all_pay as
(
SELECT cardtype,
       count(id) AS payment_count
  FROM payment
 WHERE paymentstatus != 'İade'
 GROUP BY 1
)
select s.cardtype,
       a.payment_count as all_payments,
       s.payment_count as succ_payments,
       round( (s.payment_count*1.0/a.payment_count*1.0) , 2 ) as succ_rate
from succ_pay as s
LEFT JOIN all_pay as a ON s.cardtype=a.cardtype
;





SELECT p.cardtype,
       count(p.id) AS payment_count,
       s.succ_p_count,
       (CASE WHEN s.cardtype='KrediKartı' THEN s.succ_p_count*1.0 END)/count(p.id)*1.0 as succ_payment_rate_kk,
       (CASE WHEN s.cardtype='SaklıKart' THEN s.succ_p_count*1.0 END)/count(p.id)*1.0 as succ_payment_rate_sk
  FROM payment as p
LEFT JOIN 
(
    select cardtype, count(id) as succ_p_count from payment where paymentstatus = 'ÇekimBaşarılı' group by 1
) as s ON p.cardtype=s.cardtype
 WHERE paymentstatus != 'İade'
 GROUP BY p.cardtype,s.succ_p_count,s.cardtype;


--Not : timestamp tipindeki veriyi ay formatı şeklinde görmek için şunu kullanın : date_trunc('month',column_name)
--Not : timestamp tipindeki veriyi yıl formatı şeklinde görmek için şunu kullanın : date_trunc('year',column_name)

-- Note: To view timestamp data in month format, use: date_trunc('month',column_name)
-- Note: To view timestamp data in year format, use: date_trunc('year',column_name)



--Ortalama sipariş tutarı tüm yolcuların ortalama siparişinden yüksek olan müşteri bilgilerini getirin.
-- Retrieve the customer information for those whose average order amount is higher than the average order amount of all passengers.

SELECT round(AVG(amount),2) as avg_amount FROM payment 
;

WITH all_contacts AS (
        SELECT b.contactid,
               round(avg(p.amount),2) AS avg_amount,
               CASE WHEN round(avg(p.amount),2) > (SELECT round(avg(amount),2) AS avg_amount FROM payment) THEN b.contactid
                     END AS contact
          FROM booking AS b
          LEFT JOIN payment AS p
            ON p.bookingid = b.id
         GROUP BY 1
       )
SELECT a.contactid,
       a.avg_amount,
       b.contactemail,
       b.userregisterdate
  FROM all_contacts as a
  INNER JOIN booking as b ON a.contactid=b.contactid
 WHERE contact IS NOT NULL
;


WITH ortalama_siparis as 
(
 select b.contactid,
   round(avg(p.amount),2) as ort_siparis from booking as b
 left join payment as p  on b.id=p.bookingid 
 group by 1  

)
SELECT b.contactemail,
       b.userregisterdate,
       b.contactid,
       o.ort_siparis
  FROM booking AS b
  LEFT JOIN ortalama_siparis AS o
    ON b.contactid = o.contactid
 WHERE o.ort_siparis > (
        SELECT avg(amount)AS ort_odeme
          FROM payment
       )
;

--Her şirketin toplam sipariş tutarı, toplam gelirin (tutarın) yüzde kaçını oluşturmaktadır?
-- What percentage of the total revenue (amount) does each company's total order amount represent?


select 
    b.company,
    SUM(p.amount) as total_company_payment,
    (SELECT SUM(amount) FROM payment) as total_payment,
    SUM(p.amount)*1.0 / (SELECT SUM(amount)*1.0 FROM payment) as payment_rate
from payment as p
LEFT JOIN booking as b ON p.bookingid=b.id
GROUP BY b.company;




WITH com_p AS (
select 
    b.company,
    SUM(p.amount) as total_company_payment,
    (SELECT SUM(amount) FROM payment) as total_payment
from payment as p
LEFT JOIN booking as b ON p.bookingid=b.id
GROUP BY b.company
)
SELECT 
    company,
    round( (total_company_payment*1.0/total_payment*1.0) ,2 ) as payment_rate
FROM com_p

;


--Company, environment ve cinsiyet kırılımında, ödemesi tamamlanan yolcu sayısı, müşteri sayısı, ortama ödeme tutarını hesaplayın.
-- Calculate the number of passengers with completed payments, the number of customers, and the average payment amount, broken down by company, environment, and gender.


SELECT b.company,
       ps.gender,
       b.environemnt,
       count(DISTINCT p.id) AS passenger_count,
       count(DISTINCT b.contactid) AS customer_count,
       round(avg(p.amount),2) AS avg_payment
  FROM payment AS p
 INNER JOIN booking AS b
    ON b.id = p.bookingid
 INNER JOIN passenger AS ps
    ON ps.bookingid = b.id
 WHERE p.paymentstatus = 'ÇekimBaşarılı'
 GROUP BY 1,
          2,
          3

--Aylık olarak başarılı/başarısız/iptal rezervasyon sayılarını ve ortama tutarları getirin.
-- Retrieve the monthly count of successful/failed/canceled reservations and their average amounts.


--date_trunc('month',paymentdate) as payment_month
--to_char(paymentdate,'YYYY-MM') as payment_month
SELECT to_char(paymentdate,'YYYY-MM') AS payment_month,
       paymentstatus,
       count(bookingid) AS booking_count,
       round(avg(amount),2) AS avg_payment
  FROM payment
 GROUP BY 1,
          2

--2021 Ocak ayında üye olan kadın yolcuların kaçı şirketin ortalama tutarının üzerinde ödeme yapmıştır?
-- How many female passengers who became members in January 2021 made payments above the company's average amount?

--Burada aslında bizim elimizde yolcuların cinsiyet bilgilisi var ama yolcuların(passenger) üye olma tarihleri yok, müşterilerin(contactid) üye olma tarihi var, o yüzden istenilen outputu elimizdeki bilgilerle veremiyoruz. Soruyu aşağıdaki gibi güncelliyorum:
-- Here, we actually have the gender information of the passengers, but we don't have their membership dates. We only have the membership dates for customers (contactid), so we can't provide the requested output with the data we have. I'm updating the question as follows:

--2021 Ocak ayında üye olan müşterilerin kaçı şirketin ortalama tutarının üzerinde ödeme yapmıştır?
-- How many customers who became members in January 2021 made payments above the company's average amount?

WITH contacts_in_2021 AS (
        SELECT contactid,
               round(avg(amount),2) AS avg_payment
          FROM booking AS b
         INNER JOIN payment AS p
            ON p.bookingid = b.id
         WHERE to_char(bookingdate,'YYYY-MM') = '2021-01'
         GROUP BY 1
        HAVING round(avg(amount),2) > (
                SELECT round(avg(amount),2)
                  FROM payment
               )
       ) SELECT count(contactid) AS contact_count
  FROM contacts_in_2021



