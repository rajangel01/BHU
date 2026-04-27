-- The following set of tables make up a database that is used by a booking agency to book hotel
-- reservations for their client hotels. 

-- Type of room is a one-character code that refers to Single (S) or Family (N) and Price refers to the price
-- of the room per day. 
-- Hotel (Hotel_No, Name, City)
-- Room (Room_No, Hotel_No, Type, Price)
-- Booking (@Hotel_No, Room_No ,Guest_No, Date_From, Date_To,)
-- Guest (Guest_No, Name, City) 



create database hotel_management1;

use hotel_management1;

create table hotel(
					hotel_no varchar(10) primary key,
                    name varchar(50),
                    city varchar(50)
                    )ENGINE=InnoDB;
                    
                    
create table room(
					room_no int,
                    hotel_no varchar(10),
                    room_type  char,
                    price float,
                    foreign key (hotel_no) references hotel(hotel_no),
                    primary key(room_no, hotel_no)
                    )ENGINE=InnoDB;
                    
create table guest(

                   guest_no varchar(10) primary key, 
                   name varchar(50),
                   city varchar(50)
                   );  
  
create table booking(
						hotel_no varchar(10),
                        room_no int,
                        guest_no varchar(10),
                        date_from date,
                        date_to date,
                        primary key(hotel_no, room_no, guest_no, date_from),
                        foreign key(hotel_no, room_no) references room(hotel_no, room_no),
                        foreign key(guest_no) references guest(guest_no)
                        );
                        
insert into hotel(hotel_no, name, city) values
('H111', 'Empire Hotel', 'New York'),
('H235', 'Park Place', 'New York'),
('H432', 'Brownstone Hotel', 'Toronto'),
('H498', 'James Plaza', 'Toronto'),
('H193', 'Devon Hotel','Boston'),
('H437','Clairmont Hotel', 'Boston');

INSERT INTO room (room_no, hotel_no, room_type, price) VALUES
(313, 'H111', 'S', 145.00),
(412, 'H111', 'N', 145.00),
(1267, 'H235', 'N', 175.00),
(1289, 'H235', 'N', 195.00),
(876, 'H432', 'S', 124.00),
(898, 'H432', 'S', 124.00),
(345, 'H498', 'N', 160.00),
(467, 'H498', 'N', 180.00),
(1001, 'H193', 'S', 150.00),
(1201, 'H193', 'N', 175.00),
(257, 'H437', 'N', 140.00),
(223, 'H437', 'N', 155.00);



insert into guest(guest_no, name, city) values
('G256', 'Adam Wayne', 'Pittsburgh'),
('G367', 'Tara Cummings', 'Baltimore'),
('G879','Vanessa Parry', 'Pittsburgh'),
('G230', 'Tom Hancock', 'Philadelphia'),
('G467','Robert Swift', 'Atlanta'),
('G190','EdwardCane', 'Baltimore');

INSERT INTO booking (hotel_no, guest_no, date_from, date_to, room_no) VALUES
('H111', 'G256', '1999-08-10', '1999-08-15', 412),
('H111', 'G367', '1999-08-18', '1999-08-21', 412),
('H235', 'G879', '1999-09-05', '1999-09-12', 1267),
('H498', 'G230', '1999-09-15', '1999-09-18', 467),
('H498', 'G256', '1999-11-30', '1999-12-02', 345),
('H498', 'G467', '1999-11-03', '1999-11-05', 345),
('H193', 'G190', '1999-11-15', '1999-11-19', 1001),
('H193', 'G367', '1999-09-12', '1999-09-14', 1001),
('H193', 'G367', '1999-10-01', '1999-10-06', 1201),
('H437', 'G190', '1999-10-04', '1999-10-06', 223),
('H437', 'G879', '1999-09-14', '1999-09-17', 223);

-- 1. List full details of all hotels.
select * from hotel;

-- 2. List full details of all hotels in New York.
select * from hotel where city = "New York";

-- 3. List the names and cities of all guests, ordered according to their cities. 
select name, city from guest order by city;

-- 4. List all details for family rooms in ascending order of price. 
select * from room where room_type = 'N' order by price;

-- 5. List the number of hotels there are. 
select count(*) as Total_hotel from hotel;

-- 6. List the cities in which guests live. Each city should be listed only once. 
select distinct city from guest;

-- 7. List the average price of a room. 
select avg(price) from room;

-- 8. List hotel names, their room numbers, and the type of that room
select name, room_no, room_type from 
hotel h join  room r 
on h.hotel_no = r.hotel_no;

-- 9. List the hotel names, booking dates, and room numbers for all hotels in New York. 
select name, date_from, date_to, room_no 
from hotel h join booking b 
on h.hotel_no = b.hotel_no 
where h.city='New York';

-- 10. What is the number of bookings that started in the month of September?
select count(*) from booking 
where date_from like '%09%';
-- 11. List the names and cities of guests who began a stay in New York in August. 
select g.name, g.city from guest g join booking b 
on g.guest_no=b.guest_no 
join hotel h on b.hotel_no=h.hotel_no 
where b.date_from like '%08%';

-- 12. List the hotel names and room numbers of any hotel rooms that have not been booked. 
SELECT h.name, r.room_no FROM hotel h
JOIN room r ON h.hotel_no = r.hotel_no
LEFT JOIN Booking B ON R.Hotel_No = B.Hotel_No 
AND R.Room_No = B.Room_No
WHERE B.Hotel_No IS NULL;

-- 13. List the hotel name and city of the hotel with the highest priced room. 
SELECT Name, City FROM Hotel 
WHERE Hotel_No = (SELECT Hotel_No FROM Room ORDER BY Price DESC LIMIT 1);

-- 14. List hotel names, room numbers, cities, and prices for hotels that have rooms with prices lower
-- than the lowest priced room in a Boston hotel
SELECT H.Name, R.Room_No, H.City, R.Price
FROM Hotel H
JOIN Room R ON H.Hotel_No = R.Hotel_No
WHERE R.Price < (
    SELECT MIN(Price) 
    FROM Room R2 
    JOIN Hotel H2 ON R2.Hotel_No = H2.Hotel_No 
    WHERE H2.City = 'Boston'
);

-- 15. List the average price of a room grouped by city 
SELECT H.City, AVG(R.Price) AS Avg_Price
FROM Hotel H
JOIN Room R ON H.Hotel_No = R.Hotel_No
GROUP BY H.City;
