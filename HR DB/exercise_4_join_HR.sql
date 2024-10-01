
-- 1. tüm çalışanların isim, soyisim, telefon, departman adi ve departman ülke bilgisini getiriniz:
-- 1. Retrieve the first name, last name, phone number, department name, and department country information for all employees:

-- "first_name"		"last_name"		"phone_number"	"department_name"	"country_name"				"city"
-- "Jennifer"		"Whalen"		"515.123.4444"	"Administration"	"United States of America"	"Seattle"
-- "Pat"			"Fay"			"603.123.6666"	"Marketing"			"Canada"					"Toronto"
-- "Michael"		"Hartstein"		"515.123.5555"	"Marketing"			"Canada"					"Toronto"
select 


from employees E
JOIN 
JOIN 
JOIN 


-- 2. her bölgein kapsadığı ülke isimlerini getirin:
-- 2. Retrieve the names of the countries covered by each region:
-- "region_name"	"country_name"
-- "Americas"		"Argentina"
-- "Americas"		"Brazil"
-- "Americas"		"Canada"
select 

from countries C
JOIN 
ORDER BY 


-- 3. departman ismi bazlı ortalama maaşları ve çalışan sayısını getiriniz:
-- 3. Retrieve the average salaries and the number of employees based on department name:

select 
department_name

from employees E
JOIN 
GROUP BY 


-- 4. her şehirde çalışan kişi sayısını getiriniz
-- 4. Retrieve the number of employees working in each city:

select 

from locations L
LEFT JOIN 
LEFT JOIN 
GROUP BY 

-- 5. davete çalışanlar ve çocukları gelecek, toplam sayıyı bulunuz ve gruplayınız:
-- 5. Employees and their children will attend the event; find and group the total number:
-- C: Child, P: Parent
-- "person_type"	"count"
-- "C"				30
-- "P"				40
SELECT person_type, count(*)
FROM
(
SELECT
	
	
		from employees
UNION
	SELECT
	
	
		FROM dependents
)
GROUP BY person_type


-------------------------------------------------- CEVAPLAR --------------------------------------------------

-- 1. tüm çalışanların isim, soyisim, telefon, departman adi ve departman ülke bilgisini getiriniz:
-- 1. Retrieve the first name, last name, phone number, department name, and department country information for all employees:
-- "first_name"		"last_name"		"phone_number"	"department_name"	"country_name"				"city"
-- "Jennifer"		"Whalen"		"515.123.4444"	"Administration"	"United States of America"	"Seattle"
-- "Pat"			"Fay"			"603.123.6666"	"Marketing"			"Canada"					"Toronto"
-- "Michael"		"Hartstein"		"515.123.5555"	"Marketing"			"Canada"					"Toronto"
select 
E.first_name, 
E.last_name, 
e.phone_number
,department_name
,country_name
,city
from employees E
JOIN departments USING(department_id)
JOIN locations USING(location_id)
JOIN countries C USING (country_id)


-- 2. her bölgein kapsadığı ülke isimlerini getirin:
-- 2. Retrieve the names of the countries covered by each region:
-- "region_name"	"country_name"
-- "Americas"		"Argentina"
-- "Americas"		"Brazil"
-- "Americas"		"Canada"
select 
region_name
,country_name
from countries C
JOIN regions USING (region_id)
ORDER BY 1, 2


-- 3. departman ismi bazlı ortalama maaşları ve çalışan sayısını getiriniz:
-- 3. Retrieve the average salaries and the number of employees based on department name:
select 
department_name
,ROUND(avg(salary)) avg_salary
,count(employee_id) employee_count
from employees E
JOIN departments USING(department_id)
GROUP BY department_name


-- 4. her şehirde çalışan kişi sayısını getiriniz
-- 4. Retrieve the number of employees working in each city:
select 
city
-- ,concat(first_name,' ',last_name)
,count(E.employee_id)
from locations L
LEFT JOIN departments USING(location_id)
LEFT JOIN employees E USING(department_id)
GROUP BY city

-- 5. davete çalışanlar ve çocukları gelecek, toplam sayıyı bulunuz ve gruplayınız:
-- 5. Employees and their children will attend the event; find and group the total number:
-- C: Child, P: Parent
-- "person_type"	"count"
-- "C"				30
-- "P"				40
SELECT person_type, count(*)
FROM
(
SELECT
	first_name
	,last_name
	,'P' person_type
		from employees
UNION
	SELECT
	first_name
	,last_name
	,'C' person_type
		FROM dependents
)
GROUP BY person_type



