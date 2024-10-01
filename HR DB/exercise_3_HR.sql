
-- GROUP BY EXERCISES
-- Maaşı genel maaş ortalamasının üzerinde olanları getiriniz.
-- Retrieve those with a salary above the overall average salary.

select 

from employees 
WHERE 


-- Londra'daki birimlerin çalışan sayısı ve ödenen maaş toplamını getiriniz.
-- Retrieve the number of employees and the total salaries paid for departments in London.

select 

from employees 
WHERE department_id IN 
(	
	IN
		
)
group by department_id



-- Her departmandaki çalışan sayısını ve benzersiz unvan (kaç farklı unvan olduğunu) hesaplayınız.
-- Calculate the number of employees and unique titles (how many different titles) in each department.

select 

from employees 
group by 
ORDER BY 


-- işe giriş tarihi 1997 yılı olan çalışan sayısını bulunuz.
-- Find the number of employees who were hired in the year 1997.

SELECT 
COUNT(CASE WHEN hire_date >= '1997-01-01'            ) AS employee_count
FROM employees




-- Departmanlara göre farklı maaş artış oranlarını hesaplayınız:
-- 3 ve 5 için 1.1
-- 11 için *1.15
-- 9 için 1.2
-- kalanı için 1.05
-- beklenen çıktı: 

-- Calculate different salary increase rates by department:
-- For departments 3 and 5, use 1.1
-- For department 11, use 1.15
-- For department 9, use 1.2
-- For the rest, use 1.05
-- Expected output:


-- "department_id"	"employee_id"	"salary"	"new_salary"
-- 1	200	4400.00	4620.0000
-- 2	201	13000.00	13650.0000

SELECT 
department_id
,employee_id
,salary
,CASE 	WHEN 
		WHEN 
		WHEN 
		ELSE 
		END AS new_salary
FROM employees
ORDER BY 


-- departman bazlı maaş ve zamlı maaş toplamları (yukarıdaki sorunun toplam ile çözümü)
-- Beklenen çıktı:

-- Department-based total salary and increased salary totals (solution for the above question with totals)
-- Expected output:

-- "department_id"	"existing_total_salary"	"new_total_salary"
-- 1	4400.00	4620.0000
-- 2	19000.00	19950.0000
-- 3	24900.00	27390.000
SELECT 
department_id
,sum(     ) existing_total_salary
,sum(CASE 	WHEN 
			WHEN 
			WHEN 
			ELSE 
			END  ) AS new_total_salary
FROM employees
group by
ORDER BY


-- Subquery ile çözümü
-- Solution with subquery

SELECT 
department_id

FROM
	(SELECT 
	
	 
	,CASE 	WHEN 
			WHEN 
			WHEN 
			ELSE 
			END AS new_salary
	FROM employees) AS A
group by
ORDER BY 1

-- birim ve birim içi role göre gruplayıp sayı ve maaş hesabı
-- Group by unit and role within the unit, and calculate count and salary.

-- "department_id"	"job_id"	"employee_count"	"total_salary"
-- 		1				3				1				4400.00
-- 		2				10				1				13000.00
-- 		2				11				1				6000.00
select 
department_id


from employees 
group by 
ORDER BY 


-- her departmandaki en eski ve en yeni işe giriş tarihleri
-- Find the earliest and latest hire dates for each department.

-- "department_id"	"min"			"max"
-- 			1		"1987-09-17"	"1987-09-17"
-- 			2		"1996-02-17"	"1997-08-17"
-- 			3		"1994-12-07"	"1999-08-10"
select 
department_id


from employees 
group by
ORDER BY 

-- maaşı 10000 den küçük departmanlarla ilgili özel düzenleme yapmak istiyoruz:
-- We want to make a special adjustment for departments with salaries below 10,000.

-- "department_id"	"avg_salary"
-- 			1			4400
-- 			2			9500
-- 			3			4150
select 
department_id


from employees 
group by 
HAVING 
ORDER BY 1


-- 2. çözüm-uzun
-- Second solution - long

select * from (
	select department_id,
		CASE WHEN 
		ELSE 
		END as avg_salary_check
	from employees 
	group by  )
WHERE  
ORDER BY 

-- ortalama maaşı 7000 ₺ üzerinde olan job idleri getiriniz. Yüksek maaştan alçak maaşa sıralayınız.
-- Retrieve the job IDs with an average salary above 7,000 ₺. Sort from highest to lowest salary.

-- "job_id"		"avg_salary"
-- 		4		24000
-- 		5		17000
-- 		15		13750
select 
job_id


from employees 
group by 
HAVING 
ORDER BY


-- EUROPE Regionunda kaç tane ülke bulunmaktadır?
-- How many countries are there in the EUROPE Region?

-- "country_name"	"count"
-- "Europe"				8
select 'Europe' as country_name
,count(    ) 
from countries 
where     IN
(select 
 from regions 
 WHERE     
)


-- Human Resources departmanına en son ne zaman işe alım yapılmıştır?
-- When was the last hire made in the Human Resources department?


select 
'Last Hire Date',

from employees 
WHERE       IN(
select 
	
	from departments 
	Where       = 'Human Resources')



-------------------------------------- CEVAPLAR -------------------------------------------



-- GROUP BY EXERCISES
-- Maaşı genel maaş ortalamasının üzerinde olanlar
-- Those with salaries above the overall average salary


select first_name
, last_name
, salary
from employees 
WHERE salary > (SELECT AVG(salary) FROM employees)


-- Londra'daki birimlerin çalışan sayısı ve ödenen maaş toplamı
-- The number of employees and total salaries paid for departments in London

select department_id
, SUM(salary)
, COUNT(employee_id)
from employees 
WHERE department_id IN 
(	SELECT department_id FROM departments WHERE location_id IN
		(SELECT location_id from locations WHERE city = 'London') 
)
group by department_id



-- Her departmandaki çalışan sayısını ve benzersiz unvan (kaç farklı unvan olduğunu) hesaplayınız.
-- Calculate the number of employees and unique titles (how many different titles) in each department.

select department_id
,COUNT(*) AS employee_count
,COUNT(distinct job_id) as job_title_count
from employees 
group by department_id
ORDER BY 1


-- işe giriş tarihi 1997 yılı olan çalışan sayısını bulunuz.
-- Find the number of employees who were hired in the year 1997.

SELECT 
COUNT(CASE WHEN hire_date >= '1997-01-01' AND hire_date <= '1998-01-01' THEN employee_id END) AS employee_count
FROM employees

-- departmana göre eleman ve (benzersiz) unvan sayısı
-- Number of employees and unique titles by department

select department_id
,COUNT(*) AS employee_count
,COUNT(distinct job_id) as job_title_count
from employees
group by 1


-- Departmanlara göre farklı maaş artış oranlarını hesaplayınız:
-- 3 ve 5 için 1.1
-- 11 için *1.15
-- 9 için 1.2
-- beklenen çıktı: 

-- Calculate different salary increase rates by department:
-- For departments 3 and 5, use 1.1
-- For department 11, use 1.15
-- For department 9, use 1.2
-- Expected output:

-- "department_id"	"employee_id"	"salary"	"new_salary"
-- 1	200	4400.00	4620.0000
-- 2	201	13000.00	13650.0000
SELECT 
department_id
,employee_id
,salary
,CASE 	WHEN department_id IN (3,5) THEN salary*1.1
		WHEN department_id = 11 THEN salary*1.15
		WHEN department_id = 9 THEN salary*1.2
		ELSE salary * 1.05
		END AS new_salary
FROM employees
ORDER BY 1


-- departman bazlı maaş ve zamlı maaş toplamları (yukarıdaki sorunun toplam ile çözümü)
-- Beklenen çıktı:
-- Department-based total salary and increased salary totals (solution for the above question with totals)
-- Expected output:

-- "department_id"	"existing_total_salary"	"new_total_salary"
-- 1	4400.00	4620.0000
-- 2	19000.00	19950.0000
-- 3	24900.00	27390.000

SELECT 
department_id
,sum(salary) existing_total_salary
,sum(CASE 	WHEN department_id IN (3,5) THEN salary*1.1
		WHEN department_id = 11 THEN salary*1.15
		WHEN department_id = 9 THEN salary*1.2
		ELSE salary * 1.05
		END  ) AS new_total_salary
FROM employees
group by 1
ORDER BY 1


-- Subquery ile çözümü
-- Solution with subquery

SELECT 
department_id
,sum(salary)
,sum(new_salary)
FROM
	(SELECT 
	department_id
	,employee_id
	,salary
	,CASE 	WHEN department_id IN (3,5) THEN salary*1.1
			WHEN department_id = 11 THEN salary*1.15
			WHEN department_id = 9 THEN salary*1.2
			ELSE salary * 1.05
			END AS new_salary
	FROM employees) AS A
group by department_id
ORDER BY 1

-- birim ve birim içi role göre gruplayıp sayı ve maaş hesabı
-- Group by unit and role within the unit, and calculate count and salary

select department_id
,job_id
,COUNT(*) AS employee_count
,sum(salary) as total_salary
from employees 
group by department_id ,job_id
ORDER BY 1, 2


-- her departmandaki en eski ve en yeni işe giriş tarihleri
-- The earliest and latest hire dates for each department

select department_id
,min(hire_date)
,max(hire_date)
from employees 
group by department_id
HAVING min(hire_date)>'1994-07-07'
ORDER BY 1

-- maaşı 10000 den küçük departmanlarla ilgili özel düzenleme yapmak istiyoruz:
-- We want to make a special adjustment for departments with salaries below 10,000

select department_id
,round(avg(salary)) as avg_salary
from employees 
group by department_id
HAVING round(avg(salary))< 10000
ORDER BY 1


-- 2. çözüm-uzun
-- Second solution - long

select * from (
	select department_id,
		CASE WHEN round(avg(salary))< 10000 THEN 1
		ELSE 0 END as avg_salary_check
	from employees 
	group by department_id)
WHERE avg_salary_check=1
ORDER BY 1

-- ortalama maaşı 7000 ₺ üzerinde olan job idleri getiriniz.
-- Retrieve the job IDs with an average salary above 7,000 ₺.

select job_id
,round(avg(salary)) as avg_salary
from employees 
group by job_id
HAVING round(avg(salary)) >= 7000
ORDER BY 2 DESC


-- EUROPE Regionunda kaç tane ülke bulunmaktadır?
-- How many countries are there in the EUROPE Region?

select 'Europe' as country_name
,count(distinct country_id) from countries where region_id IN
(select region_id from regions WHERE region_name = 'Europe')


-- Human Resources departmanına en son ne zaman işe alım yapılmıştır?
-- When was the last hire made in the Human Resources department?

select 'Last Hire Date'
,MAX(hire_date) as last_hire_date
from employees 
WHERE department_id IN(
select department_id from departments Where department_name = 'Human Resources')


