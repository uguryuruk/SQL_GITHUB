-- Recency: müşteri bazında 
-- Frequency: LAG ile alışverişleri arasındaki süre
-- Monetary: total sum
-- Recency: based on customer 
-- Frequency: the time between purchases using LAG
-- Monetary: total sum


-- RFM skoru hesaplıyoruz. bazen katsayılı, bazen sıralı.
-- RFM skorlarına göre müşterileri segmente yaparız.

-- We are calculating the RFM score. Sometimes weighted, sometimes ranked.
-- We segment customers based on their RFM scores.


-- STEP 1: RECENCY
-- Her müşterinin son rezervasyon tarihi
-- tabii ki çekimi başarılı olanlar yani rezervasyonunu tamamlayanlar
-- current date = 2021-05-28 olarak kabul edelim!

-- STEP 1: RECENCY
-- The last reservation date for each customer
-- Of course, only for those with successful payments, i.e., those who completed their reservation
-- Let’s assume the current date is 2021-05-28!

WITH max_dates AS
(
-- her müşterinin son tarihini bulduk
-- We found the last date for each customer

SELECT
	contactid
	,MAX(bookingdate::date) as max_booking_date
	FROM booking b
	LEFT JOIN payment p on b.id = p.bookingid
	WHERE p.paymentstatus = 'ÇekimBaşarılı'
	GROUP BY contactid
)
SELECT 
	contactid
	,max_booking_date
	,'2021-05-28'::date - max_booking_date as recency
FROM max_dates
LIMIT 500


-- FREQUENCY
-- çekim başarılı işlemlerde, kişilerin işlem sayısını bulmaya çalışacağız.

-- FREQUENCY
-- We will try to find the number of transactions for people with successful payments.


SELECT
	contactid
	,COUNT(bookingid) as frequency
FROM booking b
LEFT JOIN payment p on b.id = p.bookingid
WHERE p.paymentstatus = 'ÇekimBaşarılı'
GROUP BY contactid
LIMIT 500

-- MONETARY
-- her müşterinin bugüne kadarki başarılı toplam ödeme sayısı
-- The total number of successful payments for each customer to date


(SELECT
	contactid
	,SUM(amount) as monetary
FROM booking b
LEFT JOIN payment p on b.id = p.bookingid
WHERE p.paymentstatus = 'ÇekimBaşarılı'
GROUP BY contactid
LIMIT 500)



-- SONRA ÜÇÜNÜ BİRLEŞTİRİYORUZ. YAŞASIN WITH!
-- THEN WE COMBINE ALL THREE. HURRAY FOR WITH!

WITH RECENCY AS (
	WITH max_dates AS
	(
	-- her müşterinin son tarihini bulduk
	-- We found the last date for each customer

		SELECT
			contactid
			,MAX(bookingdate::date) as max_booking_date
			FROM booking b
			LEFT JOIN payment p on b.id = p.bookingid
			WHERE p.paymentstatus = 'ÇekimBaşarılı'
			GROUP BY contactid
	)
	SELECT 
		contactid
		,max_booking_date
		,'2021-05-28'::date - max_booking_date as recency
	FROM max_dates
),
FREQUENCY AS (
	-- frequency için LAG de kullanabiliriz!
	-- We can also use LAG for frequency!

	SELECT
		contactid
		,COUNT(bookingid) as frequency
	FROM booking b
	LEFT JOIN payment p on b.id = p.bookingid
	WHERE p.paymentstatus = 'ÇekimBaşarılı'
	GROUP BY contactid
),
MONETARY AS (
	SELECT
		contactid
		,SUM(amount) as monetary
	FROM booking b
	LEFT JOIN payment p on b.id = p.bookingid
	WHERE p.paymentstatus = 'ÇekimBaşarılı'
	GROUP BY contactid
)
-- NTILE ile 5 eşit parçaya bölüp skor veriyoruz. Daha spesifik bölme için CASE WHEN kullan!
-- gerekirse her birine katsayı verip çarp!
-- We divide into 5 equal parts using NTILE and assign scores. Use CASE WHEN for more specific segmentation!
-- If necessary, assign a weight to each and multiply!

SELECT
	r.contactid
	,recency
	,NTILE(5) OVER (ORDER BY recency DESC) as recency_score
	,frequency
		,CASE WHEN frequency >= 1 and frequency< 5 THEN frequency
		ELSE 5 END AS frequency_score
	,monetary
FROM RECENCY R
LEFT JOIN FREQUENCY F ON R.contactid = F.contactid
LEFT JOIN MONETARY M ON R.contactid = M.contactid



