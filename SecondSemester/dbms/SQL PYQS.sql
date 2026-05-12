create database pyq1;
use pyq1;
show tables;
select * from Branch;
select * from OwnerTable;
select * from  staff;

create table Branch(
		branchNo varchar(10) primary key,
        city varchar(50)
);

INSERT INTO Branch(branchNo, city) VALUES
('BR001', 'Mumbai'),
('BR002', 'New Delhi'),
('BR003', 'Kolkata'),
('BR004', 'Chennai'),
('BR005', 'Bangalore');

create table Staff(
	staffNo varchar(10) primary key,
    name varchar(20),
    position varchar(15),
    gender varchar(10),
    dob varchar(10),
    salary int,
    branchNo varchar(10),
    foreign key(branchNo) references Branch(branchNo)
);

drop table staff;

insert into Staff( staffNo, name, position, gender, dob, salary, branchNo) values 
('S001', 'Ajay Singh', 'Manager', 'Male', '1985-05-12', 95000, 'BR001'),
('S002', 'Pooja Sharma', 'Supervisor', 'Female', '1990-08-21', 55000, 'BR002'),
('S003', 'Rohit Verma', 'Assistant', 'Male', '1998-11-10', 35000, 'BR003'),
('S004', 'Neha Gupta', 'Manager', 'Female', '1987-02-18', 88000, 'BR002'),
('S005', 'Vikas Kumar', 'Manager', 'Male', '1983-07-15', 92000, 'BR003'),
('S006', 'Ankit Roy', 'Assistant', 'Male', '1999-12-01', 30000, 'BR004'),
('S007', 'Sneha Das', 'Supervisor', 'Female', '1992-06-25', 60000, 'BR005'),
('S008', 'Mohit Jain', 'Manager', 'Male', '1980-03-30', 100000, 'BR002'),
('S009', 'Riya Sen', 'Assistant', 'Female', '2000-09-17', 32000, 'BR001'),
('S010', 'Arjun Patel', 'Supervisor', 'Male', '1991-01-05', 58000, 'BR003');


create table OwnerTable(
		ownerNo varchar(10) primary key,
        name varchar(20),
        address varchar(20),
        contact_no varchar(10)
);

 drop table OwnerTable; 


Insert into OwnerTable(ownerNo, name, address, contact_no) values
('O001', 'Ramesh Kumar', 'Lucknow, Uttar Pradesh', '9876543210'),
('O002', 'Priya Sharma', 'Delhi, India', '9876543211'),
('O003', 'Amit Verma', 'Kolkata, West Bengal', '9876543212'),
('O004', 'Neha Singh', 'Lucknow, Uttar Pradesh', '9876543213'),
('O005', 'Suresh Patel', 'Ahmedabad, Gujarat', '9876543214'),
('O006', 'Karan Mehta', 'Mumbai, Maharashtra', '9876543215'),
('O007', 'Anjali Roy', 'Lucknow, Uttar Pradesh', '9876543216'),
('O008', 'Rahul Das', 'Bangalore, Karnataka', '9876543217');

select * from OwnerTable;

create table Property(
	propertyNo varchar(10) primary key,
    city varchar(20),
    type_of varchar(15),
    rent int,
    ownerNo varchar(10),
    staffNo varchar(10),
    branchNo varchar(10),
    foreign key(ownerNo)references OwnerTable(ownerNo),
    foreign key(staffNo) references Staff(staffNo),
    foreign key(branchNo) references Branch(branchNo)
);

INSERT INTO Property(propertyNo, city, type_of, rent, ownerNo, staffNo, branchNo) VALUES
('P001', 'Mumbai', 'Flat', 4500, 'O001', 'S001', 'BR001'),
('P002', 'New Delhi', 'House', 7000, 'O002', 'S002', 'BR002'),
('P003', 'Kolkata', 'Flat', 3500, 'O003', 'S005', 'BR003'),
('P004', 'Chennai', 'House', 5000, 'O004', 'S006', 'BR004'),
('P005', 'Bangalore', 'Flat', 3000, 'O005', 'S007', 'BR005'),
('P006', 'Mumbai', 'House', 8000, 'O006', 'S001', 'BR001'),
('P007', 'Lucknow', 'Flat', 2500, 'O007', 'S003', 'BR003'),
('P008', 'Delhi', 'House', 6500, 'O008', 'S008', 'BR002'),
('P009', 'Kolkata', 'Flat', 4000, 'O003', 'S010', 'BR003'),
('P010', 'Bangalore', 'House', 9000, 'O005', 'S007', 'BR005');

-- List all the Male staff details who work in Mumbai and salary greater than Rs. 80,000.
Select * from Branch b join staff s on b.branchNo = s.branchNo where b.city = 'Mumbai'AND s.gender='Male' AND s.salary>80000;

-- List all male managers working either in New Delhi or in Kolkata.
select * from branch b join staff s on b.branchNo = s.branchNo 
where s.position = 'Manager' AND s.gender='Male' AND b.city in ('New Delhi', 'Kolkata');

-- List all flats with a rent below Rs. 4000 per day, in ascending order  of price.
Select * from Property where type_of = 'Flat' and rent<4000 order by rent;

-- Find all owners with the string 'Lucknow' in their address.
Select * from OwnerTable where address like '%Lucknow%';

-- Display the total salary of all male staff;
select sum(salary) from staff where gender='Male';

-- Find how many properties cost more than rs 3500 to rent?
select count(rent) from Property where rent>3500;

-- Find the total number of managers and the sum of their salaries.
select count(position) as No_Of_Manager,sum(salary) as sumOfSalary from Staff where position = 'Manager';

-- Find the staff name who has salary higher than the average salary of branchno = BR003
select name from Staff where salary >(select avg(salary) from Staff where branchNo = 'BR003');

-- Give all managers a 5% pay increase
set SQL_SAFE_UPDATES=0;
update staff set salary = salary+salary*0.05 where position = 'Manager';
select * from staff;