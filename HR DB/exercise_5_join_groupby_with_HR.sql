-- 1. Tüm çalışanlar ile birlikte, maaşı 10000 TL den büyük olan kişilerin job_title bilgisini 
-- VE tüm çalışanların departman bilgisini getiriniz!
-- 1. Retrieve all employees, including the job_title information of those with a salary greater than 10,000 TL
-- AND retrieve the department information of all employees!

-- "first_name"	"last_name"	"salary"	"job_title"			"department_name"
-- "Jennifer"	"Whalen"	4400.00							"Administration"
-- "Pat"		"Fay"		6000.00							"Marketing"
-- "Michael"	"Hartstein"	13000.00	"Marketing Manager"	"Marketing"
select 





from employees e
LEFT JOIN
LEFT JOIN

-- case when çözümü -- case when solution

select 

,CASE WHEN     THEN     END AS job_title -- yoksa null döndürür -- returns null if not found

from employees e
LEFT JOIN 
LEFT JOIN 

-- 2. her çalışan bilgisi ile birlikte, maaşlarını ve çalışmakta olduğu departmanın ortalama maaşını getiriniz.
-- İPUCU: Subquery + join :)
-- 2. Retrieve each employee's information along with their salary and the average salary of the department they work in.
-- HINT: Subquery + join :)

-- "first_name"	"last_name"	"salary"	"department_id"		"avg_salary"
-- "Steven"		"King"		24000.00		9				19333.33
-- "Neena"		"Kochhar"	17000.00		9				19333.33
-- "Lex"		"De Haan"	17000.00		9				19333.33
SELECT 
	
	
FROM EMPLOYEES E
LEFT JOIN
	(SELECT 
	 
		FROM EMPLOYEES
		GROUP BY 
	) AS A 
		ON 
		


-- 2.b. WITH ile çözünüz:
-- 2.b. Solve using WITH:

WITH dep AS (
SELECT 
	
	
	from employees 
	group by 
	
) 
select 


from employees e
LEFT JOIN dep ON 

-- 2.c. çalışan ortalamanın altında mı alıyor, üstünde mi? ek bir sütunla OK-NOK şeklinde gösteriniz. (FLAG)
-- 2.c. Is the employee earning above or below the average? Display with an additional column as OK-NOK. (FLAG)

-- "first_name"	"last_name"	"salary"	"department_id"		"avg_salary"	"salary_check"
-- "Steven"		"King"		24000.00		9				19333.33		"OK"
-- "Neena"		"Kochhar"	17000.00		9				19333.33		"NOK"
-- "Lex"		"De Haan"	17000.00		9				19333.33		"NOK"
select 


from employees e
LEFT JOIN (
SELECT 
	
	from employees 
	group by 
) AS  A 
on e.department_id  = A.department_id

-- 3. her çalışan bilgisi ile birlikte, maaşlarını ve çalışmakta olduğu departmanın ortalama maaşını ve çalıştığı job_id nin (unvanın) ortalama maaşını getiriniz.
-- 3. Retrieve each employee's information along with their salary, the average salary of the department they work in, and the average salary of the job_id (title) they hold.

-- "first_name"	"last_name"	"salary"	"department_id"	"avg_dep_salary"	"avg_job_salary"
-- "Steven"		"King"		24000.00		9				19333.33			24000.00
-- "Neena"		"Kochhar"	17000.00		9				19333.33			17000.00
-- "Lex"		"De Haan"	17000.00		9				19333.33			17000.00

WITH dep AS (
SELECT 
	
	
	from employees 
	group by
),
job as (
SELECT 
	
	
	from employees 
	group by 
)
select 


from employees e
LEFT JOIN dep ON 
LEFT JOIN job ON 


-------------------------------------------------- CEVAPLAR --------------------------------------------------


-- 1. Tüm çalışanlar ile birlikte, maaşı 10000 TL den büyük olan kişilerin job_title bilgisini 
-- VE tüm çalışanların departman bilgisini getiriniz!
-- 1. Retrieve all employees, including the job_title information of those with a salary greater than 10,000 TL
-- AND retrieve the department information of all employees!

-- "first_name"	"last_name"	"salary"	"job_title"			"department_name"
-- "Jennifer"	"Whalen"	4400.00							"Administration"
-- "Pat"		"Fay"		6000.00							"Marketing"
-- "Michael"	"Hartstein"	13000.00	"Marketing Manager"	"Marketing"
select e.first_name
,e.last_name
,e.salary
,j.job_title
,d.department_name
from employees e
LEFT JOIN jobs j ON j.job_id = e.job_id and e.salary>10000
LEFT JOIN departments d on D.department_id = e.department_id

-- case when çözümü -- case when solution

select e.first_name
,e.last_name
,e.salary
,CASE WHEN e.salary>10000 THEN j.job_title END AS job_title -- yoksa null döndürür -- returns null if not found
,d.department_name
from employees e
LEFT JOIN jobs j ON j.job_id = e.job_id  
LEFT JOIN departments d on D.department_id = e.department_id

-- 2. her çalışan bilgisi ile birlikte, maaşlarını ve çalışmakta olduğu departmanın ortalama maaşını getiriniz.
-- İPUCU: Subquery + join :)
-- 2. Retrieve each employee's information along with their salary and the average salary of the department they work in.
-- HINT: Subquery + join :)

-- "first_name"	"last_name"	"salary"	"department_id"		"avg_salary"
-- "Steven"		"King"		24000.00		9				19333.33
-- "Neena"		"Kochhar"	17000.00		9				19333.33
-- "Lex"		"De Haan"	17000.00		9				19333.33
SELECT E.FIRST_NAME,
	E.LAST_NAME,
	E.SALARY,
	E.DEPARTMENT_ID,
	A.AVG_SALARY
FROM EMPLOYEES E
LEFT JOIN
	(SELECT DEPARTMENT_ID ,
			ROUND(AVG(SALARY),
				2) AS AVG_SALARY
		FROM EMPLOYEES
		GROUP BY DEPARTMENT_ID) AS A 
		ON E.DEPARTMENT_ID = A.DEPARTMENT_ID


-- 2.b. WITH ile çözünüz: -- 2.b. Solve using WITH:

WITH dep AS (
SELECT department_id
	,ROUND(AVG(salary), 2) as avg_salary
	from employees group by department_id
) 
select e.first_name
,e.last_name
,e.salary
,e.department_id
,dep.avg_salary
from employees e
LEFT JOIN dep ON e.department_id = dep.department_id

-- 2.c. çalışan ortalamanın altında mı alıyor, üstünde mi? ek bir sütunla OK-NOK şeklinde gösteriniz.
-- 2.c. Is the employee earning above or below the average? Display with an additional column as OK-NOK. (FLAG)

-- "first_name"	"last_name"	"salary"	"department_id"		"avg_salary"	"salary_check"
-- "Steven"		"King"		24000.00		9				19333.33		"OK"
-- "Neena"		"Kochhar"	17000.00		9				19333.33		"NOK"
-- "Lex"		"De Haan"	17000.00		9				19333.33		"NOK"
select 
e.first_name
,e.last_name
,e.salary
,e.department_id
,A.avg_salary
,CASE WHEN salary>avg_salary THEN 'OK'
ELSE 'NOK'
END AS salary_check
from employees e
LEFT JOIN (
SELECT department_id
	, ROUND(AVG(salary), 2) as avg_salary
	from employees group by department_id
) AS  A on e.department_id  = A.department_id

-- 3. her çalışan bilgisi ile birlikte, maaşlarını ve çalışmakta olduğu departmanın ortalama maaşını ve çalıştığı job_id nin (unvanın) ortalama maaşını getiriniz.
-- 3. Retrieve each employee's information along with their salary, the average salary of the department they work in, and the average salary of the job_id (title) they hold.

-- "first_name"	"last_name"	"salary"	"department_id"	"avg_dep_salary"	"avg_job_salary"
-- "Steven"		"King"		24000.00		9				19333.33			24000.00
-- "Neena"		"Kochhar"	17000.00		9				19333.33			17000.00
-- "Lex"		"De Haan"	17000.00		9				19333.33			17000.00

WITH dep AS (
SELECT department_id
	,ROUND(AVG(salary), 2) as avg_salary
	from employees group by department_id
),
job as (
SELECT job_id
	,ROUND(AVG(salary), 2) as avg_salary
	from employees group by job_id
)
select e.first_name
,e.last_name
,e.salary
,e.department_id
,dep.avg_salary avg_dep_salary
,job.avg_salary as avg_job_salary
from employees e
LEFT JOIN dep ON e.department_id = dep.department_id
LEFT JOIN job ON e.job_id = job.job_id

