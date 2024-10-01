-- İPUCU: WHERE yaparken ikili (tuple) eşleşme yapabiliyoruz.
-- HINT: While using WHERE, we can perform tuple matching.

SELECT first_name, department_id, job_id, salary
FROM employees
WHERE (department_id, salary) = (11, 8300) 
ORDER BY department_id;

-- Yöneticiniz her ünvanda en yüksek maaşı alan kişinin ismini maaşını ve unvanını istemiştir.
-- Your manager has requested the name, salary, and title of the person earning the highest salary for each title.

SELECT 
FROM employees E
WHERE 
ORDER BY ;



-- Yöneticiniz her birimde en yüksek maaşı alan kişilerin ismini maaşını ve unvanını istemiştir.
-- Your manager has requested the name, salary, and title of the person earning the highest salary in each department.

SELECT 
FROM employees
WHERE 
ORDER BY department_id;






-- Birimlerin ortalama, min ve max maaşını gösteren aşağıdaki çıktıyı üretiniz:
-- Produce the following output showing the average, minimum, and maximum salary of each department:

-- 		"department_name"	"avg_salary"	"min_salary"	"max_salary"
-- 			"Accounting"	10150.00			8300.00			12000.00
-- 			"Purchasing"	4150.00				2500.00			11000.00
-- 			"Marketing"		9500.00				6000.00			13000.00
select
department_name

from employees E
JOIN departments D on 
GROUP BY 

-- Yöneticiniz çalışanların ad, soyad, maaşını ve çocuk sayısını görmek istemiştir.
-- Your manager has requested to see the first name, last name, salary, and number of children for each employee.

-- "first_name"	"last_name"	"salary"	"child_count"
-- "Guy"		"Himuro"	2600.00			1
-- "Steven"		"King"		24000.00		1
-- "Kimberely"	"Grant"		7000.00			0


select 

from employees E
LEFT JOIN dependents D on 
GROUP BY 


-- Yöneticiniz çalışanları ve çocuklarını alt alta tek bir listede aşağıdaki şekilde görmek istemiştir. 
-- (Kişi ve çocuğu alt alta gelsin istemektedir):
-- Your manager has requested to see employees and their children listed vertically, as follows: 
-- (Each person and their child should be listed one below the other):

-- "first_name"		"last_name"		"type_"
-- "David"			"Austin"		"Employee"
-- "Fred"			"Austin"		"Child"
-- "Hermann"		"Baer"			"Employee"
-- "Kirsten"		"Baer"			"Child"
select  
from employees
UNION
select 
from dependents
ORDER BY 



-- A. İK birimince sizden günümüz itibariyle çalışanların isim, soyisim, kıdem(çalışma süresi-yıl olarak) ve maaş bilgisi istenmiştir. 
-- En yeniden en kıdemliye sıralı istenmiştir.
-- A. The HR department has requested the current names, surnames, seniority (work duration in years), and salary information of the employees. 
-- They want the list sorted from the least senior to the most senior.

select 

from employees
ORDER BY 


-- B. İK birimi sizden ek olarak izin hesaplaması istemiştir. En çok izni olandan en az izni olana sıralı istenmiştir: 
-- yeni bir sütunda(izin) 25 yılını doldurmayanlar için 15, 25-30 yıl arası 20, 30 yıl üstü için 30 gün izin tanımlaması.
-- Beklenen çıktı:
-- B. The HR department has also requested a leave calculation. They want the list sorted from the most leave to the least leave: 
-- In a new column (leave), assign 15 days for those with less than 25 years, 20 days for those between 25-30 years, and 30 days for those with more than 30 years.
-- Expected output:

-- "first_name"		"last_name"	"salary"	"experience_year"	"off_day"
-- "Jennifer"		"Whalen"	4400.00		36					30
-- "Steven"			"King"		24000.00	36					30
select first_name
,last_name 
,salary
, (current_date-hire_date)/365 as experience_year
, CASE 	WHEN (current_date-hire_date)/365 < 25 THEN 15
		WHEN (current_date-hire_date)/365 > 25 AND (current_date-hire_date)/365 < 30 THEN 20
		ELSE 30
	END AS off_day
from employees
ORDER BY 4 DESC





-------------------------------------- CEVAPLAR -------------------------------------------
-------------------------------------- ANSWERS -------------------------------------------




-- İPUCU: WHERE yaparken ikili eşleşme yapabiliyoruz.
-- HINT: While using WHERE, we can perform tuple matching.

SELECT first_name, department_id, job_id, salary
FROM employees
WHERE (department_id, salary) = (11, 8300) 
ORDER BY department_id;

-- Yöneticiniz her ünvanda en yüksek maaşı alan kişinin ismini maaşını ve unvanını istemiştir.
-- Your manager has requested the name, salary, and title of the person earning the highest salary for each title.

SELECT first_name, department_id, job_id, salary
FROM employees E
WHERE (job_id, salary) IN (
    SELECT job_id, MAX(salary)
    FROM employees
    GROUP BY job_id
)
ORDER BY job_id;



-- Yöneticiniz her birimde en yüksek maaşı alan kişilerin ismini maaşını ve unvanını istemiştir.
-- Your manager has requested the name, salary, and title of the person earning the highest salary in each department.

SELECT first_name, department_id, job_id, salary
FROM employees
WHERE (department_id, salary) IN (
    SELECT department_id, MAX(salary)
    FROM employees
    GROUP BY department_id
)
ORDER BY department_id;






-- Birimlerin ortalama, min ve max maaşını gösteren aşağıdaki çıktıyı üretiniz:
-- Produce the following output showing the average, minimum, and maximum salary of each department:

-- 		"department_name"	"avg_salary"	"min_salary"	"max_salary"
-- 			"Accounting"	10150.00			8300.00			12000.00
-- 			"Purchasing"	4150.00				2500.00			11000.00
-- 			"Marketing"		9500.00				6000.00			13000.00
select
department_name
,ROUND(AVG(salary), 2) as avg_salary
,MIN(salary) as min_salary
,MAX(salary) as max_salary
from employees E
JOIN departments D on D.department_id=E.department_id
GROUP BY department_name

-- Yöneticiniz çalışanların ad, soyad, maaşını ve çocuk sayısını görmek istemiştir.
-- Your manager has requested to see the first name, last name, salary, and number of children for each employee.

-- "first_name"	"last_name"	"salary"	"child_count"
-- "Guy"		"Himuro"	2600.00			1
-- "Steven"		"King"		24000.00		1
-- "Kimberely"	"Grant"		7000.00			0


select e.first_name
, e.last_name
, salary
,count(D.dependent_id) as child_count
from employees E
LEFT JOIN dependents D on D.employee_id = E.employee_id
GROUP BY e.first_name ,e.last_name ,salary


-- Yöneticiniz çalışanları ve çocuklarını alt alta tek bir listede aşağıdaki şekilde görmek istemiştir. 
-- (Kişi ve çocuğu alt alta gelsin istemektedir):
-- Your manager has requested to see employees and their children listed vertically, as follows: 
-- (Each person and their child should be listed one below the other):

-- "first_name"		"last_name"		"type_"
-- "David"			"Austin"		"Employee"
-- "Fred"			"Austin"		"Child"
-- "Hermann"		"Baer"			"Employee"
-- "Kirsten"		"Baer"			"Child"
select first_name, last_name, 'Employee' as type_ 
from employees
UNION
select first_name, last_name, 'Child' as type_ 
from dependents
ORDER BY last_name ASC, type_ DESC



-- A. İK birimince sizden günümüz itibariyle çalışanların isim, soyisim, kıdem(çalışma süresi-yıl olarak) ve maaş bilgisi istenmiştir. 
-- En yeniden en kıdemliye sıralı istenmiştir.
-- A. The HR department has requested the current names, surnames, seniority (work duration in years), and salary information of the employees. 
-- They want the list sorted from the least senior to the most senior.

select first_name
, last_name
, salary
, (current_date-hire_date)/365 as experience_year
from employees
ORDER BY 3 DESC


-- B. İK birimi sizden ek olarak izin hesaplaması istemiştir: 
-- yeni bir sütunda(izin) 25 yılını doldurmayanlar için 15, 25-30 yıl arası 20, 30 yıl üstü için 30 gün izin tanımlaması
-- B. The HR department has also requested a leave calculation. They want the list sorted from the most leave to the least leave: 
-- In a new column (leave), assign 15 days for those with less than 25 years, 20 days for those between 25-30 years, and 30 days for those with more than 30 years.
-- Expected output:

select first_name, last_name, salary
, (current_date-hire_date)/365 as experience_year
, CASE 	WHEN (current_date-hire_date)/365 < 25 THEN 15
		WHEN (current_date-hire_date)/365 > 25 AND (current_date-hire_date)/365 < 30 THEN 20
		ELSE 30
	END AS off_day
from employees