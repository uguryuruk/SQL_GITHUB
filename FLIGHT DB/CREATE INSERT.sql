CREATE TABLE passenger
(
	ID integer primary key,
	bookingID integer,
	gender char(1),
	name varchar(50),	
	dateOfBirth DATE
)
;
-- GÜNCELLE
COPY passenger FROM 'C:\DATASET_EXERCISE\enuygun/passenger.csv' DELIMITER ',' CSV HEADER;

select * from passenger limit 10

CREATE TABLE booking
-- userid ve userregisterdate sütunlarındaki null ve üyeliksiz yazan verileri sildim, türünü int yaptım.
(
	id	integer primary key,
	contactid	integer,
	contactemail varchar(50),
	company	varchar(50),
	membersales	varchar(50),
	userid	integer,
	userregisterdate TIMESTAMP,
	environment	varchar(3),
	bookingdate TIMESTAMP
)
;
-- GÜNCELLE
COPY booking FROM 'C:\DATASET_EXERCISE\enuygun/booking.csv' DELIMITER ',' CSV HEADER;

select * from booking limit 10

CREATE TABLE payment
(

	ID	integer primary key,
	bookingID integer,	
	amount	integer,
	cardType varchar(20),	
	paymentStatus	varchar(30),	
	cardNumber	varchar(20),
	paymentDate TIMESTAMP
)
;
-- GÜNCELLE
COPY payment FROM 'C:\DATASET_EXERCISE\enuygun/payment.csv' DELIMITER ',' CSV HEADER;

select * from payment limit 10


ALTER TABLE passenger 
ADD CONSTRAINT fk_passenger_bookingId FOREIGN KEY (bookingID) REFERENCES booking(ID) ON DELETE CASCADE;

ALTER TABLE payment 
ADD CONSTRAINT fk_bookingId FOREIGN KEY (bookingID) REFERENCES booking(ID) ON DELETE CASCADE;

-- ALTER TABLE booking 
-- ADD CONSTRAINT fk_booking_userid FOREIGN KEY (userid) REFERENCES passenger(ID) ;




-- DROP TABLE booking
-- DROP TABLE payment
-- DROP TABLE passenger

