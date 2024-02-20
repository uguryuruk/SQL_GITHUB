------------------------------------------ Case 1 : Sipariş Analizi / Order Analysis------------------------------------------
------------------------------------------ Question 1 ------------------------------------------

-- Aylık olarak order dağılımını inceleyiniz. Tarih verisi için order_approved_at kullanılmalıdır.
-- Review the order distribution on a monthly basis. order_approved_at should be used for date data.

SELECT (DATE_TRUNC('month', O.ORDER_APPROVED_AT))::date AS ORDER_MONTH,
	(COUNT(ORDER_ID)) AS ORDER_COUNT
FROM ORDERS AS O
WHERE (DATE_TRUNC('month', O.ORDER_APPROVED_AT)) IS NOT NULL
GROUP BY 1
ORDER BY ORDER_MONTH
 
  ------------------------------------------ Question 2  ------------------------------------------
 -- -Aylık olarak order status kırılımında order sayılarını inceleyiniz. Sorgu sonucunda çıkan outputu excel ile görselleştiriniz. Dramatik bir düşüşün ya da yükselişin olduğu aylar var mı? Veriyi inceleyerek yorumlayınız.
-- İPUCU: iki farklı görsel de oluşturabiliriz, başarılı ve başarısız orderlar.
-- Review the order numbers in the order status breakdown on a monthly basis. Visualize the output of the query with Excel. Are there months with a dramatic decline or rise? Review the data.
-- HINT: we can also create two different visuals, successful and unsuccessful orders.

SELECT (DATE_TRUNC('month', O.ORDER_APPROVED_AT))::date AS ORDER_MONTH ,
	ORDER_STATUS ,
	(COUNT(ORDER_ID)) AS ORDER_COUNT
FROM ORDERS AS O
WHERE (DATE_TRUNC('month', O.ORDER_APPROVED_AT)) IS NOT NULL
GROUP BY 1, 2
ORDER BY 1,2


------------------------------------------ Question 3 ------------------------------------------

-- -Ürün kategorisi kırılımında sipariş sayılarını inceleyiniz. Özel günlerde öne çıkan kategoriler nelerdir? Örneğin yılbaşı, sevgililer günü…
-- Examine the order numbers according to product category breakdown. What are the prominent categories on special days? For example, New Year's Eve, Valentine's Day...

SELECT
-- P.PRODUCT_CATEGORY_NAME,
	TR.CATEGORY_NAME_ENGLISH,
	EXTRACT(MONTH FROM ORDER_APPROVED_AT) AS MONTH,
	COUNT(ORDER_ITEM_ID) AS SHOP_AMOUNT
FROM ORDER_ITEMS OT
LEFT JOIN ORDERS O USING (ORDER_ID)
LEFT JOIN PRODUCTS P USING (PRODUCT_ID)
LEFT JOIN TRANSLATION TR ON P.PRODUCT_CATEGORY_NAME = TR.CATEGORY_NAME
WHERE O.ORDER_STATUS = 'delivered'
	AND P.PRODUCT_CATEGORY_NAME IS NOT NULL
GROUP BY 1,2
-- ORDER BY 3 DESC

------------------------------------------ Question 4 ------------------------------------------
-- Haftanın günleri(pazartesi, perşembe, ….) ve ay günleri (ayın 1’i,2’si gibi) bazında order sayılarını inceleyiniz. 
-- Yazdığınız sorgunun outputu ile excel’de bir görsel oluşturup yorumlayınız.

-- Examine the order numbers on the basis of days of the week (Monday, Thursday, ....) and days of month (such as the 1st, 2nd of the month).
-- Create a visual in Excel with the output of the query and interpret it.

-- ayın günleri bazlı order sayısı inceleme / the number of orders based on days of the month

SELECT EXTRACT(DAY FROM O.ORDER_APPROVED_AT::date) AS ORDER_DAY,
	(COUNT(ORDER_ID)) AS ORDER_COUNT
FROM ORDERS AS O
WHERE O.ORDER_APPROVED_AT IS NOT NULL
GROUP BY 1

-- ORDER BY ORDER_COUNT DESC

-- haftanın günleri bazlı order sayısı inceleme / the number of orders based on days of the week

SELECT 
TO_CHAR(O.ORDER_APPROVED_AT::date, 'd') AS ORDER_WEEKDAY ,
TO_CHAR(O.ORDER_APPROVED_AT::date, 'Day') AS WEEKDAY ,
	(COUNT(ORDER_ID)) AS ORDER_COUNT
FROM ORDERS AS O
WHERE O.ORDER_APPROVED_AT IS NOT NULL
GROUP BY 1,2
-- ORDER BY ORDER_COUNT DESC


------------------------------------------ Case 2 : Müşteri Analizi / Customer Analysis ------------------------------------------

------------------------------------------ Question 1 ------------------------------------------

-- Hangi şehirlerdeki müşteriler daha çok alışveriş yapıyor? Müşterinin şehrini en çok sipariş verdiği şehir olarak belirleyip analizi ona göre yapınız. 

-- Örneğin; Sibel Çanakkale’den 3, Muğla’dan 8 ve İstanbul’dan 10 sipariş olmak üzere 3 farklı şehirden sipariş veriyor. Sibel’in şehrini en çok sipariş verdiği şehir olan İstanbul olarak seçmelisiniz ve Sibel’in yaptığı siparişleri İstanbul’dan 21 sipariş vermiş şekilde görünmelidir.

-- In which cities do customers shop most? Determine the customer's city as the city from which they buy the most orders and perform the analysis accordingly.
-- For example; Ugur places orders from 3 different cities: 3 from Canakkale, 8 from Mugla and 10 from Istanbul. You should select Ugur's city as Istanbul, which is the city where he orders the most, and the orders made by Ugur should appear as 21 orders from Istanbul.

WITH CITY_COUNT AS
	(
		
-- 	STEP 1: ŞEHİR MÜŞTERİ GRUPLAMASI VE FİLTRELEME / CITY and CUSTOMER GROUPING AND FILTERING
		SELECT CUSTOMER_UNIQUE_ID ,
			CUSTOMER_CITY ,
			COUNT(ORDER_ID) TOTAL_ORDER_COUNT
		FROM CUSTOMERS
		JOIN ORDERS O USING (CUSTOMER_ID)
		WHERE ORDER_STATUS NOT IN ('unavailable', 'canceled')
		GROUP BY 1, 2
		ORDER BY 1 ASC, 3 DESC),
	CITY_SHOPPING_ORDER AS
	(
-- STEP 2 HERKESİN EN ÇOK ALDIĞI ŞEHİR SIRALAMASI / CUSTOMER'S MOST PURCHASED CITY RANKING
	 SELECT CUSTOMER_UNIQUE_ID ,
			CUSTOMER_CITY ,
			TOTAL_ORDER_COUNT ,
			ROW_NUMBER() OVER (PARTITION BY CUSTOMER_UNIQUE_ID ORDER BY TOTAL_ORDER_COUNT DESC) CITY_ORDER_RN
		FROM CITY_COUNT) 
		
-------------STEP 3: HERKESİN EN ÇOK ALDIĞI ŞEHİRE GÖRE GRUPLAMA VE SIRALAMA:
-- 				GROUPING AND SORTING ACCORDING TO THE CITY WHERE EVERYONE BUYS THE MOST
SELECT CUSTOMER_CITY,
	SUM(TOTAL_ORDER_COUNT) CITY_ORDER_COUNT
FROM CITY_SHOPPING_ORDER
WHERE CITY_ORDER_RN = 1
GROUP BY 1
ORDER BY 2 DESC



------------------------------------------ Case 3: Satıcı Analizi / Seller Analysis------------------------------------------

------------------------------------------ Question 1  ------------------------------------------

-- Siparişleri en hızlı şekilde müşterilere ulaştıran satıcılar kimlerdir? Top 5 getiriniz. Bu satıcıların order sayıları ile ürünlerindeki yorumlar ve puanlamaları inceleyiniz ve yorumlayınız.
-- Bring the top 5 sellers who deliver orders to customers in the shortest time. Review the order numbers of these sellers and the comments and ratings on their products.

WITH SELLER_PERF AS
	(
		-- STEP 1: İLK SİPARİŞ ZAMANINDAN MÜŞTERİNİN ELİNE TESLİM ZAMANINI BAZ ALDIM.
		-- DELIVERY TIME: FROM PURCHASE DATE TO FINAL DELVERY TIME
		SELECT SELLER_ID,
			ORDER_DELIVERED_CUSTOMER_DATE,
			ORDER_PURCHASE_TIMESTAMP,
			ORDER_DELIVERED_CUSTOMER_DATE - ORDER_PURCHASE_TIMESTAMP AS DELIVERY_TIME,
			COUNT(OT.ORDER_ID) OVER (PARTITION BY SELLER_ID) SALES_COUNT
		FROM ORDER_ITEMS OT
		JOIN ORDERS O USING (ORDER_ID)
		JOIN SELLERS S USING (SELLER_ID)
		JOIN PRODUCTS P USING (PRODUCT_ID)
		WHERE ORDER_DELIVERED_CUSTOMER_DATE > ORDER_PURCHASE_TIMESTAMP
			AND ORDER_DELIVERED_CUSTOMER_DATE IS NOT NULL
			AND ORDER_PURCHASE_TIMESTAMP IS NOT NULL
			AND O.order_status = 'delivered'
		ORDER BY DELIVERY_TIME),
	TOP_5_SELLERS AS
	(
		-- STEP 2: ORTALAMA SATIŞ SAYISI 36, BEN YUVARLAYIP EN AZ 30 SATIŞ YAPANLARI ALDIM.
		-- AVERAGE NUMBER OF SALES IS 36, I ROUNDED DOWN TO 30 SALES
		SELECT SELLER_ID,
			AVG(DELIVERY_TIME) AS AVG_DELIVERY_TIME,
			SALES_COUNT
		FROM SELLER_PERF
		WHERE SALES_COUNT > 30
		GROUP BY 1,3
		ORDER BY 2
		LIMIT 5)
-- STEP 3: 	İLK BEŞ SATICININ ULAŞTIRMA SÜRESİ, ORTALAMA PUANI, YAPILAN YORUM SAYISI
-- DELIVERY TIME, AVERAGE SCORE, NUMBER OF COMMENTS OF THE TOP 5 SELLER	
SELECT OT.SELLER_ID,
	AVG_DELIVERY_TIME,
	ROUND(AVG(REVIEW_SCORE),2) AVG_REVIEW_SCORE,
	COUNT(REVIEW_COMMENT_TITLE) COMMENT_COUNT
FROM ORDER_ITEMS OT
JOIN SELLERS S USING (SELLER_ID)
JOIN REVIEWS R USING (ORDER_ID)
JOIN TOP_5_SELLERS USING (SELLER_ID)
WHERE SELLER_ID IN
		(SELECT SELLER_ID
			FROM TOP_5_SELLERS)
GROUP BY 1, 2
ORDER BY 2
		
------------------------------------------ Question 2------------------------------------------
-- Hangi satıcılar daha fazla kategoriye ait ürün satışı yapmaktadır? 
-- Fazla kategoriye sahip satıcıların order sayıları da fazla mı? 

-- Which sellers sell products in more categories?
-- Do sellers who sell in more categories also have a higher number of orders?

select 
	seller_id 
	,COUNT(DISTINCT p.product_category_name) AS category_count
	,COUNT(O.order_id) AS order_count
	from order_items OT 
	JOIN orders O USING (order_id)
	JOIN sellers S USING (seller_id)
	JOIN products P USING (product_id)
	GROUP BY 1
-- 	ORDER BY 2 DESC
ORDER BY 3 DESC
limit 20

------------------------------------------ Case 4 : Payment Analizi / Payment Analysis -----------
------------------------------------------ Question 1 -------------------------

-- TODO: NULL CHECK YAP (DATA QUALITY)
-- Ödeme yaparken taksit sayısı fazla olan kullanıcılar en çok hangi bölgede yaşamaktadır? Bu çıktıyı yorumlayınız.

-- In which regions do users with a high number of installments live? Interpret this output.

WITH taksit_sayisi AS(
	-- TAKSİT SAYISI 3'TEN FAZLA OLANLARI ÇOK TAKSİT OLARAK YORUMLADIM.
	-- MY OPINION: 3+ INSTALLMENTS MEANS HIGH NUMBER OF INSTALLMENTS.
	SELECT ORDER_ID,
			CASE
				WHEN PAYMENT_INSTALLMENTS = 1 THEN '1'
				WHEN PAYMENT_INSTALLMENTS = 2 THEN '2'
				WHEN PAYMENT_INSTALLMENTS = 3 THEN '3'
				ELSE '3+'
			END AS TAKSIT
		FROM PAYMENTS PAY )
	-- TESLİM EDİLEN SİPARİŞLERİ BAZ ALDIM.
	-- BASED ON THE ORDERS DELIVERED.
SELECT CU.CUSTOMER_STATE ,
	COUNT(CU.CUSTOMER_UNIQUE_ID)
FROM PAYMENTS PAY
JOIN ORDERS O USING (ORDER_ID)
JOIN CUSTOMERS CU USING (CUSTOMER_ID)
JOIN TAKSIT_SAYISI USING (ORDER_ID)
WHERE TAKSIT = '3+' 
AND O.order_status = 'delivered'
GROUP BY 1
ORDER BY 2 DESC

------------------------------------------ Question 2 ------------------------------------------

-- Ödeme tipine göre başarılı order sayısı ve toplam başarılı ödeme tutarını hesaplayınız. En çok kullanılan ödeme tipinden en az olana göre sıralayınız.
-- Calculate the number of successful orders and total successful payment amount according to payment type. Rank them in order from the most used payment type to the least.
SELECT PAYMENT_TYPE
	,COUNT(ORDER_ID)
	,ROUND(SUM(PAYMENT_VALUE)) total_payment_amount
FROM PAYMENTS
JOIN ORDERS O USING (ORDER_ID)
WHERE ORDER_STATUS NOT IN ('unavailable','canceled')
GROUP BY 1
ORDER BY 2 DESC

------------------------------------------ Question 3 ------------------------------------------
--  : 
-- Tek çekimde ve taksitle ödenen siparişlerin kategori bazlı analizini yapınız.
-- iki sorgu yazabiliriz!
-- TODO: EXCEL İLE ANALİZ!
-- Make a category-based analysis of orders paid in one shot and in installments.
WITH TAKSIT_SAYISI AS
	(-- 1 İSE TEK ÇEKİM, ÇOK İSE TAKSİT.
	-- IF 1, ONE SHOT, ELSE, MANY INSTALLMENTS.
 SELECT ORDER_ID,
			CASE
				WHEN PAYMENT_INSTALLMENTS = 1 THEN 'Tek Çekim'
				ELSE 'Taksit'
			END AS TAKSIT
		FROM PAYMENTS PAY
		WHERE PAYMENT_INSTALLMENTS > 0
		)
		-- TESLİM EDİLENLERİ VE KATEGORİ ADI BULUNANLARI BAZ ALDIM.
		-- BASED ON DELIVERED PURCHASES AND WHİCH HAVE CATEGORY NAMES.
SELECT 	TAKSIT,
		P.PRODUCT_CATEGORY_NAME,
		TR.CATEGORY_NAME_ENGLISH,
		COUNT(TS.ORDER_ID) AS SHOP_AMOUNT
-- 		,(SELECT COUNT(ORDER_ID) FROM TAKSIT_SAYISI)
	FROM ORDER_ITEMS OT
LEFT JOIN ORDERS O USING (ORDER_ID)
LEFT JOIN PRODUCTS P USING (PRODUCT_ID)
LEFT JOIN TRANSLATION TR ON P.PRODUCT_CATEGORY_NAME = TR.CATEGORY_NAME
LEFT JOIN TAKSIT_SAYISI TS USING (ORDER_ID)
WHERE O.ORDER_STATUS = 'delivered'
	AND P.PRODUCT_CATEGORY_NAME IS NOT NULL
GROUP BY 1,2,3
-- ORDER BY 2, 1  -- GENEL gruplama
ORDER BY 4 DESC -- en çok taksitle ödeme kullanılan ürünler.
-- products where payment in installments is mostly used.

------------------- Case 5 : RFM Analizi ------------------------------------------
-- Aşağıdaki e_commerce_data_.csv doyasındaki veri setini kullanarak RFM analizi yapınız. 
-- https://www.kaggle.com/datasets/carrie1/ecommerce-data
-- Recency hesaplarken bugünün tarihi değil en son sipariş tarihini baz alınız. 

-- Perform RFM analysis using the data set in the e_commerce_data_.csv file below.
-- https://www.kaggle.com/datasets/carrie1/ecommerce-data
-- When calculating recency, take the last order date as basis, not today's date.

------------------------------------------ RECENCY ------------------------------------------
WITH RECENCY AS
	(WITH LAST_DATES AS
			(SELECT CUSTOMERID,
					MAX(INVOICEDATE::DATE) AS LAST_SHOPPING_DATE
				FROM RFM
				WHERE CUSTOMERID IS NOT NULL
					AND (QUANTITY > 0 OR UNITPRICE > 0)
				GROUP BY 1) 
	 SELECT CUSTOMERID,
			LAST_SHOPPING_DATE,
			'2011-12-10'::DATE - LAST_SHOPPING_DATE AS RECENCY_DAY
		FROM LAST_DATES
		ORDER BY 3
		), 
------------------------------------------ FREQUENCY ------------------------------------------
-- Alışveriş sayısını saydım, o yüzden distinct invoiceno kullandım. Stock no veya distinct siz kullanılabilir.
-- İnternette frequency çok tekrarlayabilir, bu yüzden rank kullanmış pythonda

-- I counted the number of purchases, so I used distinct invoiceno. Stock no or distinct can be used.
-- Frequency can be very repetitive, so rank is used in python (a blog post)
FREQUENCY AS
	(SELECT CUSTOMERID,
			COUNT(DISTINCT INVOICENO) AS FREQUENCY_RATE
		FROM RFM
		WHERE CUSTOMERID IS NOT NULL
			AND (QUANTITY > 0 OR UNITPRICE > 0)
		GROUP BY 1
		ORDER BY 2 DESC),
------------------------------------------ MONETARY ------------------------------------------
-- tutar: unitprice * quantity
-- EKSİ DEĞERLERİ KONTROL ETMELİYİZ, SONRA AYIKLAMALIYIZ

-- amount: unitprice * quantity
-- WE SHOULD CHECK THE NEGATIVE VALUES, THEN ISOLATE THEM
MONETARY AS
	(SELECT CUSTOMERID,
			ROUND(SUM(UNITPRICE * QUANTITY)) AS MONETARY_TOTAL
		FROM RFM
		WHERE CUSTOMERID IS NOT NULL
			AND (QUANTITY > 0 AND UNITPRICE > 0)
		GROUP BY 1
		ORDER BY 2)

-- SON OPERASYON: EN RFMLİ 1000 MÜŞTERİ :)
-- LAST OPERATION: TOP 1000 CUSTOMERS ACCORDING TO RFM

SELECT R.CUSTOMERID ,
	NTILE(5) OVER (ORDER BY RECENCY_DAY DESC) AS RECENCY_SCORE ,
	NTILE(5) OVER (ORDER BY FREQUENCY_RATE) AS FREQUENCY_RATE ,
	NTILE(5) OVER (ORDER BY MONETARY_TOTAL) AS MONETARY_TOTAL 
FROM RECENCY R
LEFT JOIN FREQUENCY F ON R.CUSTOMERID = F.CUSTOMERID
LEFT JOIN MONETARY M ON R.CUSTOMERID = M.CUSTOMERID
ORDER BY 4 DESC, 3 DESC, 2 DESC
LIMIT 1000