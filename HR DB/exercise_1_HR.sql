-- ALIŞTIRMALAR
-- NOTLAR:
-- CEVAPLAR EN ALTTA
-- F5 İLE SORGUYU ÇALIŞTIRABİLİRSİNİZ
-- CTRL BASILI TUTARKEN MOUSE İLE TIKLAYARAK BİRÇOK YERE İMLEÇ BIRAKABİLİRSİNİZ
-- BOL BOL KOPYALAYIP YAPIŞTIRIN (CTRL+C, CTRL+V)
-- TOOLBOX: KEŞFETMEK İÇİN KULLANABİLİRSİNİZ :)

-- EXERCISES
-- NOTES:
-- ANSWERS AT THE BOTTOM
-- YOU CAN RUN THE QUERY WITH F5
-- WHILE HOLDING CTRL, YOU CAN CLICK WITH THE MOUSE TO PLACE THE CURSOR IN MULTIPLE PLACES
-- COPY AND PASTE AS MUCH AS YOU CAN (CTRL+C, CTRL+V)
-- TOOLBOX: YOU CAN USE IT TO EXPLORE :)


select * from jobs limit 20
select * from dependents limit 20
select * from countries limit 20
select * from departments limit 20
select * from locations limit 20
select * from regions limit 20
select * from employees limit 20


-- 1.A Yöneticiniz birimlerin ortalama maaşlarının yer aldığı şu tarz bir rapor istemiştir. 
-- 1.A Your manager has requested a report showing the average salaries of departments in the following format:
-- "department_name"	"avg_salary"
-- "Accounting"	10150.00
-- "Purchasing"	4150.00
-- "Marketing"	9500.00


select 


from employees as E
JOIN 
GROUP BY 


-- 1.B Raporu en yüksek maaştan en alçağa sıralı olarak tekrar istemiştir:
-- 1.B The manager has requested the report to be sorted from the highest salary to the lowest:




--  2.A Yöneticiniz kişilerin birim ve şehirlerinin yer aldığı aşağıdaki raporu istemiştir:
-- 2.A Your manager has requested the following report showing people's departments and cities:
-- "full_name"	"phone_number"	"email"	"department_name"	"city"
-- "Den Raphaely"	"515.127.4561"	"den.raphaely@sqltutorial.org"	"Purchasing"	"Seattle"
-- "Alexander Khoo"	"515.127.4562"	"alexander.khoo@sqltutorial.org"	"Purchasing"	"Seattle"

select 

from employees E
JOIN 
JOIN 
-- 2.B Yöneticiniz tüm birimleri değil sadece 'Administration', 'Marketing','Purchasing' birimlerini istemiştir.
-- 2.B Your manager has requested only the departments 'Administration', 'Marketing', and 'Purchasing', not all departments.
WHERE E.department_id in (
	
)



-- 3. Yöneticiniz çalışanları ve varsa çocuklarını görmek istemiştir:
-- 3. Your manager wants to see employees and, if applicable, their children:
-- "parent_name"	"dependent_name"
-- "Adam Fripp"	" "
-- "Alexander Hunold"	"Vivien Hunold"
select

from employees E
LEFT JOIN dependents D 
ORDER BY 


-- CEVAPLAR EN ALTTA
-- SOLUTIONS ARE AT THE BOTTOM
-- |
-- |
-- |
-- V















-- CEVAPLARRRRRRRR
-- ANSWERSSSSS


-- 1.A Yöneticiniz birimlerin ortalama maaşlarının yer aldığı şu tarz bir rapor istemiştir. 
-- 1.A Your manager has requested a report showing the average salaries of departments in the following format:

-- "department_name"	"avg_salary"
-- "Accounting"	10150.00
-- "Purchasing"	4150.00
-- "Marketing"	9500.00

select 
D.department_name
,ROUND(AVG(salary), 2) AS avg_salary
from employees as E
JOIN departments as D ON D.department_id = E.department_id
GROUP BY D.department_name


-- 1.B Raporu en yüksek maaştan en alçağa sıralı olarak tekrar istemiştir:
-- 1.B The manager has requested the report to be sorted from the highest salary to the lowest:

select 
D.department_name
,ROUND(AVG(salary), 2) AS avg_salary
from employees as E
JOIN departments as D ON D.department_id = E.department_id
GROUP BY D.department_name
ORDER BY ROUND(AVG(salary), 2) DESC



--  2.A Yöneticiniz kişilerin birim ve şehirlerinin yer aldığı aşağıdaki raporu istemiştir:
-- 2.A Your manager has requested the following report showing people's departments and cities:

-- "full_name"	"phone_number"	"email"	"department_name"	"city"
-- "Den Raphaely"	"515.127.4561"	"den.raphaely@sqltutorial.org"	"Purchasing"	"Seattle"
-- "Alexander Khoo"	"515.127.4562"	"alexander.khoo@sqltutorial.org"	"Purchasing"	"Seattle"
select 
concat(first_name,' ',last_name) as full_name
,phone_number
,email
,D.department_name
,L.city
from employees E
JOIN departments D ON D.department_id = E.department_id
JOIN locations L ON L.location_id = D.location_id

-- 2.B Yöneticiniz tüm birimleri değil sadece 'Administration', 'Marketing','Purchasing' birimlerini istemiştir.
-- 2.B Your manager has requested only the departments 'Administration', 'Marketing', and 'Purchasing', not all departments.
WHERE E.department_id in (
select department_id from departments WHERE department_name in ('Administration',
'Marketing','Purchasing'))



-- 3. Yöneticiniz çalışanları ve varsa çocuklarını görmek istemiştir.
-- 3. Your manager wants to see employees and, if applicable, their children:
-- "parent_name"	"dependent_name"
-- "Adam Fripp"	" "
-- "Alexander Hunold"	"Vivien Hunold"
select concat(E.first_name,' ',E.last_name) as parent_name
, concat(D.first_name,' ',D.last_name) as dependent_name
from employees E
LEFT JOIN dependents D ON D.employee_id = E.employee_id
ORDER BY parent_name


