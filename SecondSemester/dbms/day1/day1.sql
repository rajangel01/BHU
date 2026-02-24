CREATE DATABASE books;

USE books;

CREATE TABLE book1(
		id INT,
        bookName VARCHAR(50),
        writer VARCHAR(30),
        price FLOAT,
        price_in_dollar FLOAT,
        price_in_pound FLOAT,
        publisher VARCHAR(50),
        current_status VARCHAR(50),
        book_number INT,
        location VARCHAR(50),
        total_available INT,
        total INT
);

LOAD DATA INFILE 'C:/Users/RAJ/Downloads/combine.csv'
INTO TABLE book1
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM book1;

TRUNCATE book1;