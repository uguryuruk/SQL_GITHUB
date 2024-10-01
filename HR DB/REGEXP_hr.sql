select count(*) from jobs limit 20
select count(*) from dependents limit 20

-- GENERAL LOOKOUT
select * from jobs limit 20
select * from dependents limit 20
select * from countries limit 20
select * from public.departments limit 20
select * from public.locations limit 20
select * from public.regions limit 20
select * from public.employees limit 20



-- REGULAR EXPRESSION
select * from countries 
where lower(country_name) LIKE '%ia'

select * from countries 
where lower(country_name) SIMILAR TO '%(belgium|brazil)%'

select * from dependents
-- where lower(last_name) LIKE '___haan'
where last_name ILIKE '___haan'
-- where lower(first_name) LIKE '_ennifer'
-- where lower(first_name) LIKE '_en%'
-- where lower(last_name) LIKE '%in_'



-- GROUPING ()
select * from jobs
-- WHERE LOWER(job_title) SIMILAR TO '%finance%(manager)%'
WHERE LOWER(job_title) SIMILAR TO '[qwj]'
-- WHERE job_title SIMILAR TO '^Sal%'


-- REGEXP METHODS
SELECT regexp_count('Hello World! this is an example.', 'example') -- sayısı   count
SELECT regexp_instr('Hello World! this is an example.', 'example') -- bulunduğu yer   position
SELECT regexp_like('Hello World! this is an example.', 'example') -- 
SELECT regexp_match(street_address, 'Rd'), * from public.locations --
SELECT regexp_matches(street_address, 'Rd','i'), * from public.locations -- 
SELECT regexp_matches(street_address, 'Rd','g'), * from public.locations -- 
SELECT regexp_substr('Hello World! this is an example.', 'example') -- 


select street_address from public.locations 
-- where street_address ~ '^.*$'
-- where street_address ~ '^[A-Z].*$'  --büyük harfle başlayanlar  -- those that start with a capital letter
-- where street_address ~ '^[0-9].*$'  --rakamla başlayanlar   -- those that start with a number
-- where street_address ~ '^[A-Z]{2}.*$'  --iki harfle başlayanlar   -- those that start with two letters
where street_address ~ '^[0-9]{4}.*$'  --rakam tekrar sayısı   -- count of repeated digits
-- where street_address ~ '^[A-Z][0-9].*$'  --bir harf sonrasında rakam ile devam eden   -- those that have a letter followed by a number


--limit 10 
--offset 10