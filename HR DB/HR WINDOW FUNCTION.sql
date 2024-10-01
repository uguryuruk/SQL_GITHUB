select count(*) from jobs
select count(*) from dependents 

-- GENERAL LOOKOUT
select * from jobs limit 20
select * from dependents limit 20
select * from countries limit 20
select * from departments limit 20
select * from locations limit 20
select * from regions limit 20
select * from employees limit 20

-- TOOLBOX
-- select
-- employee_id	
-- ,first_name	
-- ,last_name	
-- ,email	
-- ,phone_number	
-- ,hire_date	
-- ,job_id	
-- ,salary	
-- ,manager_id	
-- ,department_id
-- from employees limit 20

-- WINDOW FUNCTION
-- RANK 1
-- Çalışanları maaşı ve maaş sıralamasında kaçıncı olduğuna göre listeleyiniz. Beklenen çıktı:
-- List the employees based on their salary and their rank in the salary hierarchy. Expected output:

-- "employee_id"	"first_name"	"last_name"	"salary"	"salary_rank"
-- 176	"Jonathon"	"Taylor"	8600.00	13
-- 177	"Jack"	"Livingston"	8400.00	14
select  
employee_id	
,first_name	
,last_name	
,salary	
, RANK() OVER (ORDER BY salary DESC) as salary_rank

from employees

-- RANK 2
-- Çalışanları maaşı ve kıdemde (işe giriş tarihi) kaçıncı olduğuna göre listeleyiniz. Maaşlar YÜKSEKTEN ALÇAĞA sıralansın. Beklenen çıktı:
-- List the employees based on their salary and their seniority (hire date). Salaries should be sorted from HIGHEST to LOWEST. Expected output:

-- "employee_id"	"first_name"	"last_name"	"hire_date"	"experience_rank"
-- 100	"Steven"	"King"	"1987-06-17"	1
-- 200	"Jennifer"	"Whalen"	"1987-09-17"	2

select  
employee_id	
,first_name	
,last_name	
,hire_date		
, RANK() OVER (ORDER BY hire_date ASC) as experience_rank
from employees


-- RANK 3
-- Çalışanları maaşı ve maaş sıralamasında kaçıncı olduğuna göre listeleyiniz. Maaşlar YÜKSEKTEN ALÇAĞA sıralansın. Beklenen çıktı:
-- List the employees based on their salary and their rank in the salary hierarchy. Salaries should be sorted from HIGHEST to LOWEST. Expected output:

-- "employee_id"	"first_name"	"last_name"	"salary"	"salary_rank"	"salary_dense_rank"
-- 100	"Steven"	"King"	24000.00	1	1
-- 101	"Neena"	"Kochhar"	17000.00	2	2
select  
employee_id	
,first_name	
,last_name	
,salary	
, RANK() OVER (ORDER BY salary DESC) as salary_rank
, DENSE_RANK() OVER (ORDER BY salary DESC) as salary_dense_rank

from employees

--PERCENT_RANK 3
-- Çalışanları maaşı, maaş sıralamasında kaçıncı olduğuna, aldığı maaşın toplam içindeki YÜZDELİK DİLİMİ (xx,yy) ve toplam ödenen maaşa göre listeleyiniz. 
-- Maaşlar YÜKSEKTEN ALÇAĞA sıralansın. Beklenen çıktı:
-- List employees by their salary, their rank in the salary hierarchy, their percentage (xx,yy) of the total salary paid, and the total salary paid. 
-- Salaries should be sorted from HIGHEST to LOWEST. Expected output:

-- "employee_id"	"first_name"	"last_name"	"salary"	"salary_dense_rank"	"salary_percent_rank"	"total_salary_budget"
-- 100	"Steven"	"King"	24000.00	1	0	322400.00
-- 101	"Neena"	"Kochhar"	17000.00	2	3	322400.00
select  
employee_id	
,first_name	
,last_name	
,salary	
, DENSE_RANK() OVER (ORDER BY salary DESC) as salary_dense_rank
, ROUND(((PERCENT_RANK() OVER (ORDER BY salary DESC)) * 100)) as salary_percent_rank
, (select	SUM(salary) from employees) as total_salary_budget
from employees 


-- NTILE 4
-- Çalışanların maaşlarını 4 eşit dilime bölerek, en yüksek maaşı alan ilk dilimdeki çalışanları listeleyiniz. 
-- Maaşlar YÜKSEKTEN ALÇAĞA sıralansın. Beklenen çıktı:
-- Divide the employees' salaries into 4 equal groups and list those in the top salary group. 
-- Salaries should be sorted from HIGHEST to LOWEST. Expected output:

-- "employee_id"	"first_name"	"last_name"	"salary"	"salary_rank"	"total_salary_budget"
-- 100	"Steven"	"King"	24000.00	1	322400.00
-- 101	"Neena"	"Kochhar"	17000.00	1	322400.00

select  
	employee_id	
	,first_name	
	,last_name	
	,salary	
	, NTILE(4) OVER (ORDER BY salary DESC) as salary_rank
	, (select	SUM(salary) from employees) as total_salary_budget
from employees 

-- FIRST_VALUE 5
-- Her birimdeki ortalama maaşı ve en yüksek maaş alan elemanı listeleyiniz.
-- List the average salary and the highest-paid employee for each department.

-- ÇALIŞMADI -- DID NOT WORK

SELECT 
	department_id
	-- , round(AVG(salary)) AS avg_salary
	, FIRST_VALUE(first_name || ' ' || last_name) OVER (PARTITION BY department_id ORDER BY salary DESC) AS highest_paid_employee
	, LAST_VALUE(first_name || ' ' || last_name) OVER (PARTITION BY department_id ORDER BY salary DESC) AS highest_paid_employee
	FROM employees
	GROUP BY department_id
	,first_name,last_name, salary;

-- LAST_VALUE 5
-- çalışanların maaşlarının artış oranını ve son maaşlarını belirlemek için
-- To determine the employees' salary increase rates and their final salaries

SELECT employee_id, hire_date, salary, 

       (salary - LAG(salary, 1, salary) OVER (PARTITION BY employee_id ORDER BY hire_date)) / LAG(salary, 1, salary) 
	   OVER (PARTITION BY employee_id ORDER BY hire_date) AS increase_rate,

       LAST_VALUE(salary) OVER (PARTITION BY employee_id ORDER BY hire_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_salary

FROM employees;

-- SORU: Her çalışan bilgisi ile ilgili departmanın ortalama maaş bilgisini getirin
-- QUESTION: Retrieve the department's average salary information along with each employee's information.

-- DENEME: dümdüz yaparsak başarısız olur :)
-- TRIAL: If we do it straightforwardly, it will fail :)

SELECT
	first_name	
	,last_name	
	,salary
	,e.department_id
	,AVG(salary)
FROM employees e
GROUP BY first_name, last_name, salary, e.department_id


-- UZUN VE ESKİ YÖNTEM yani WITH
-- LONG AND OLD METHOD, i.e., WITH

WITH avg_salary AS (
	SELECT 	department_id
			,AVG(salary) as avg_salary
	FROM employees
	GROUP BY department_id
	ORDER BY 1
)
SELECT
	first_name	
	,last_name	
	,salary
	,e.department_id
	,a.avg_salary
FROM employees e
JOIN avg_salary a on a.department_id = e.department_id
ORDER BY e.department_id


-- KISA VE YENİ YÖNTEM (WINDOW FUNCTION)
-- SHORT AND NEW METHOD (WINDOW FUNCTION)

SELECT *
	,AVG(salary) OVER (PARTITION BY department_id ORDER BY department_id) as avg_salary
FROM employees;


SELECT
	department_name
	,ROUND(AVG(salary)OVER (PARTITION BY E.department_id ORDER BY e.department_id) ) as avg_salary
	,MIN(salary) OVER (PARTITION BY E.department_id) as min_salary
	,MAX(salary) OVER (PARTITION BY E.department_id) as max_salary
FROM employees E
JOIN departments D on D.department_id=E.department_id
-- GROUP BY department_name, salary


-- SORU: Her çalışan bilgisi(ad, soyad, maaş) ile ilgili departmanın ortalama maaş bilgisini, ilgili unvanın ortalama maaş bilgisini getirin
-- QUESTION: Retrieve the department's average salary and the job title's average salary along with each employee's information (first name, last name, salary).

SELECT
	first_name	
	,last_name	
	,salary
	,e.department_id
	,ROUND(AVG(salary)OVER (PARTITION BY E.department_id) ) as dep_avg_salary
	,ROUND(AVG(salary)OVER (PARTITION BY E.job_id) ) as job_avg_salary
FROM employees E

-- Her departman, job_id(unvan)=19 ve sıralaması
-- Each department, job_id (title) = 19 and its ranking

SELECT
	employee_id
	,first_name	
	,last_name
	,job_id
	,hire_date
	,ROW_NUMBER() OVER (PARTITION BY job_id order BY DATE_TRUNC('YEAR',hire_date)) rn
	,RANK() OVER (PARTITION BY job_id order BY DATE_TRUNC('YEAR',hire_date)) rank_
	,DENSE_RANK() OVER (PARTITION BY job_id order BY DATE_TRUNC('YEAR',hire_date)) dense_rank_ 	
FROM employees E
ORDER BY job_id, hire_date








