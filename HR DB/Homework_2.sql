--Job title'i programmer olan kişiler kimlerdir? 
-- Who are the people with the job title "programmer"?

select * from employees 
WHERE job_id in (
select job_id from jobs WHERE job_title ='Programmer'
)
--Marketing departmanında çalışan kişilerin isim-soyisim, telefon numarası, email ve departman id bilgilerini getirin.
-- Retrieve the first name, last name, phone number, email, and department id of employees working in the Marketing department.

select 
concat(first_name,' ',last_name) as full_name
,phone_number
,email
,department_id
from employees 
WHERE department_id in (
select department_id from departments WHERE department_name ='Marketing'
)

--Toronto'da bulunan departmanlarda çalışan kişilerin isimleri nelerdir?
-- What are the names of employees working in departments located in Toronto?

select 
concat(first_name,' ',last_name) as full_name
,phone_number
,email
,department_id
from employees 
WHERE department_id in (	
	select department_id from departments where location_id in (
		select location_id from locations where city = 'Toronto'
) 	
)


--1 ve 2 bölgelerinde olan şehirler hangileridir?
-- Which cities are located in regions 1 and 2?

select city from locations WHERE country_id in (
	select country_id from countries WHERE region_id in (1,2)
)

--Lokasyon ID'si 2400 olan departmanda çalışan kişiler kimlerdir?
-- Who are the employees working in the department with location ID 2400?

select * from employees where department_id in (
	select department_id from departments where location_id = 2400
)

--Europe bölgesinde konumlanan departmanlarda çalışan kişiler kimlerdir?
-- Who are the employees working in departments located in the Europe region?

select * from employees where department_id in (
	select department_id from departments where location_id in (
		select location_id from locations WHERE country_id in (
			select country_id from countries WHERE region_id in (
				select region_id from regions WHERE region_name = 'Europe'			
			)
		)
	)
)

)
--Region ismi Europe ve Asia olan ülkeler nelerdir?
-- What are the countries in the regions named Europe and Asia?

select * from countries WHERE region_id in (
	select region_id from regions WHERE region_name in ('Europe', 'Asia')
)
--En düşük maaş ile en yüksek maaş farkı en fazla olan job title hangisidir?
-- Which job title has the largest difference between the lowest and highest salary?

select
max(salary) - min(salary) as Fark
,job_title 
from employees E
JOIN jobs J on E.job_id = J.job_id
group by job_title
ORDER BY max(salary) - min(salary) DESC LIMIT 1

--%15 zam oranı ile maaşı asgari ücretin (8500) altında kalan kişiler kimlerdir?
-- Who are the people whose salaries remain below the minimum wage (8500) after a 15% raise?

select first_name
,last_name
,salary
,ROUND(salary * 1.15) as zamli
, CASE WHEN salary * 1.15 < 5000 THEN 'Altta'
		ELSE 'Üstte'
		END AS durum
from employees