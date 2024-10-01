--Marketing departmanında çalışan kişilerin isim-soyisim, telefon numarası, email ve departman id bilgilerini getirin.
-- Retrieve the first name, last name, phone number, email, and department id of employees working in the Marketing department.

select 
CONCAT(first_name, ' ',last_name) AS full_name
,phone_number
,email
,department_id
from employees 
where department_id in 
(SELECT department_id from departments where department_name = 'Marketing')

--5 idli departmanda çalışan kişilerin isim-soyisim, telefon numarası, email ve departman id bilgilerini getirin.
-- Retrieve the first name, last name, phone number, email, and department id of employees working in the department with id 5.
select 
first_name
,last_name
,phone_number
,email
,department_id
from employees 
where department_id = 5 

--Kişileri kullandıkları telefon numaralarının ilk 3 hanesine göre segmente edin.
-- Segment people based on the first 3 digits of their phone numbers.
-- STEP 1
select 
DISTINCT LEFT(phone_number, 3) as gsm_op
from employees 
-- STEP 2
SELECT 
first_name
,last_name
, CASE WHEN (left(phone_number,3)) = '515' THEN '515 Op'
            WHEN (left(phone_number,3)) = '590' THEN '590 Op'
            WHEN (left(phone_number,3)) = '603' THEN '603 Op'
            WHEN (left(phone_number,3)) = '650' THEN '650 Op'
            ELSE 'Other Op'
			END AS gsm_segment
from employees 


--3 idli departmanda en yüksek maaş alan 3 kişi kimdir?
-- Who are the 3 highest-paid employees in the department with id 3?

select 
first_name
,last_name
,salary
,department_id
from employees
where department_id = 3 
ORDER BY salary DESC 
LIMIT 3

--13 job_id li en düşük maaş alan 2 kişi kimdir?
-- Who are the 2 lowest-paid employees with job_id 13?

select 
first_name
,last_name
,salary
, job_id
from employees
where job_id = 13 
ORDER BY salary ASC 
LIMIT 2

--Telefon no 650 kodu ile başlayan kişilerden kaçı 1997'de işe girmiştir?
-- How many people whose phone numbers start with the code 650 were hired in 1997?

select 
first_name
,last_name
,hire_date
,phone_number
,hire_date
from employees
where 	LEFT(phone_number, 3) = '650' 
and 	EXTRACT(YEAR FROM hire_date) = 1997

--100 id'li managerin ekibinde çalışan ve telefon kodu 515 ile başlayan kişilerin id, isim ve soyisimi nedir?
-- What are the id, first name, and last name of the employees working under the manager with id 100 whose phone numbers start with 515?

SELECT EMPLOYEE_ID,
	FIRST_NAME,
	LAST_NAME
FROM EMPLOYEES
WHERE LEFT(PHONE_NUMBER,3) = '515'
	AND MANAGER_ID = 100

--Job title'i programmer olan kişiler kimlerdir? 
--Zorunlu değil.
-- Who are the people with the job title "programmer"?
-- Not mandatory.

select
employee_id
,first_name
,last_name
,e.job_id
,jb.job_title
from employees e
JOIN jobs as jb ON e.job_id = jb.job_id
WHERE e.job_id IN (
SELECT job_id FROM jobs 
	WHERE job_title = 'Programmer' )