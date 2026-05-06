-- Name: Raj Kumar
-- Roll: 25419MCA041
-- Enrol: 491196


CREATE DATABASE library;
USE library;

CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(255),
    published_year INT,
    genre VARCHAR(100),
    available_copies INT
);

CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    age INT,
    gender VARCHAR(10)
);

CREATE TABLE Borrowed (
    borrow_id INT PRIMARY KEY,
    book_id INT,
    member_id INT,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Books (book_id, title, author, published_year, genre, available_copies) VALUES
(00551, 'The_Great_Gatsby', 'F_Scott_Fitzgerald', 1925, 'Tragedy', 10000),
(00552, 'ULYSSES', 'James_Joyce', 1922, 'Modernist_Novel', 10000),
(00553, 'Lolita', 'Vladimir_Nabokov', 1955, 'Novel', 10000),
(00554, 'Brave_New_World', 'Aldous_Huxley', 1932, 'Science_Fiction_Dystopian_Fiction', 10000),
(00555, 'The_Sound_And_The_Fury', 'William_Faulkner', 1929, 'Southern_Gothic', 10000),
(00556, 'Catch22', 'Joseph_Heller', 1961, 'Dark_Comedy', 10000),
(00557, 'The_Grapes_Of_Wrath', 'John_Steinbeck', 1939, 'Novel', 10000),
(00558, 'I_Claudius', 'Robert_Graves', 1934, 'Historical', 10000),
(00559, 'To_The_Lighthouse', 'Virginia_Woolf', 1927, 'Modernism', 10000),
(05510, 'Slaughterhouse_Five', 'Kurt_Vonnegut', 1969, 'War_Novel', 10000),
(05511, 'Invisible_Man', 'Ralph_Ellison', 1952, 'African_American_Literature', 10000),
(05512, 'Native_Son', 'Richard_Wright', 1940, 'Social_Protest', 10000),
(05513, 'USA_Trilogy', 'John_Dos_Passos', 1930, 'Political_Fiction', 10000),
(05514, 'A_Passage_To_India', 'E_M_Forster', 1924, 'Novel', 10000),
(05515, 'Tender_Is_The_Night', 'F_Scott_Fitzgerald', 1934, 'Tragedy', 10000),
(05516, 'Animal_Farm', 'George_Orwell', 1945, 'Political_Satire', 10000),
(05517, 'The_Golden_Bowl', 'Henry_James', 1904, 'Philosophy', 10000),
(05518, 'A_Handful_Of_Dust', 'Evelyn_Waugh', 1934, 'Fiction', 10000),
(05519, 'As_I_Lay_Dying', 'William_Faulkner', 1930, 'Black_Comedy', 10000),
(05520, 'The_Heart_Of_The_Matter', 'Graham_Greene', 1948, 'Novel', 10000);


INSERT INTO Members (member_id, name, email, age, gender) VALUES
(1, 'John Smith', 'john@example.com', 25, 'Male'),
(2, 'Sarah Jenkins', 'sarah@example.com', 30, 'Female'),
(3, 'Robert Miller', 'robert@example.com', 70, 'Male');


INSERT INTO Borrowed (borrow_id, book_id, member_id, borrow_date, return_date) VALUES
(101, 00551, 1, '2024-04-01', '2024-04-10'), 
(102, 00554, 2, '2024-04-05', NULL),      
(103, 00555, 3, '2024-04-20', NULL);          


-- List of books borrowed by a specific member (e.g., 'John Smith')
SELECT b.title 
FROM Books b
JOIN Borrowed br ON b.book_id = br.book_id
JOIN Members m ON br.member_id = m.member_id
WHERE m.name = 'John Smith';


-- 2. Find members who borrowed a specific book (e.g., “Atomic Habits”).
SELECT m.name 
FROM Members m
JOIN Borrowed br ON m.member_id = br.member_id
JOIN Books b ON br.book_id = b.book_id
WHERE b.title = 'Atomic Habits';

-- 3. List genre wise available copies of books in library.
SELECT genre, SUM(available_copies) AS total_available
FROM Books
GROUP BY genre;

-- 4. Find the genre most liked by female members of the Library.
SELECT b.genre, COUNT(*) AS borrow_count
FROM Books b
JOIN Borrowed br ON b.book_id = br.book_id
JOIN Members m ON br.member_id = m.member_id
WHERE m.gender = 'Female'
GROUP BY b.genre
ORDER BY borrow_count DESC
LIMIT 1;

-- 5. Find the genre most liked by senior citizen members of the Library.
SELECT b.genre, COUNT(*) AS borrow_count
FROM Books b
JOIN Borrowed br ON b.book_id = br.book_id
JOIN Members m ON br.member_id = m.member_id
WHERE m.age >= 60
GROUP BY b.genre
ORDER BY borrow_count DESC
LIMIT 1;


-- 6. List the members who borrowed and returned the books before overdue (within 14 days from the borrow date).
SELECT DISTINCT m.name
FROM Members m
JOIN Borrowed br ON m.member_id = br.member_id
WHERE br.return_date IS NOT NULL 
AND (br.return_date - br.borrow_date) <= 14;

-- 7. Write a query to find all books that are currently borrowed and overdue (i.e., not returned
-- within 14 days from the borrow date). Display the book titles and the names of members who borrowed them.
SELECT b.title, m.name
FROM Books b
JOIN Borrowed br ON b.book_id = br.book_id
JOIN Members m ON br.member_id = m.member_id
WHERE br.return_date IS NULL 
AND (CURRENT_DATE - br.borrow_date) > 14;

-- 8. Find the most popular genre in the library (Display the genre with the highest total number of books borrowed).
SELECT b.genre, COUNT(br.borrow_id) AS total_borrowed
FROM Books b
JOIN Borrowed br ON b.book_id = br.book_id
GROUP BY b.genre
ORDER BY total_borrowed DESC
LIMIT 1;

-- 9. Add a new column named fine amount to the Borrowed table. This column will store the fine
-- amount (in Rs.) for overdue books. Set an appropriate default value for this column.
ALTER TABLE Borrowed 
ADD fine_amount DECIMAL(10, 2) DEFAULT 0.00;

-- 10. Write a SQL query to calculate the total fines collected from all overdue books. Use the fine
-- amount column and consider all books that are currently overdue.
SELECT SUM((CURRENT_DATE - (borrow_date + 14)) * 5) AS total_fines_collected
FROM Borrowed
WHERE return_date IS NULL 
AND (CURRENT_DATE - borrow_date) > 14;

-- 11. Find the top 5 members who have borrowed the most books. Display their names and the number of books they have borrowed.
SELECT m.name, COUNT(br.borrow_id) AS books_borrowed
FROM Members m
JOIN Borrowed br ON m.member_id = br.member_id
GROUP BY m.member_id, m.name
ORDER BY books_borrowed DESC
LIMIT 5;

-- 12. Add a joint UNIQUE constraint to the book id and member id columns in the Borrowed table
-- to prevent a member from borrowing the same book more than once simultaneously.
ALTER TABLE Borrowed
ADD CONSTRAINT unique_borrow UNIQUE (book_id, member_id);

-- 13. Write a query to find the books that are currently available for borrowing (i.e., books with at
-- least one available copy). Display the book titles and the number of available copies.
SELECT title, available_copies
FROM Books
WHERE available_copies > 0;

-- 14. Create a query that categorizes members based on their borrowing behaviour. Use a CASE
-- statement to categorize them as “Frequent Borrowers” if they have borrowed more than 10
-- books, “Regular Borrowers” if they have borrowed between 5 and 10 books, and “Occasional
-- Borrowers” if they have borrowed less than 5 books. (Hint: use CASE statement)
SELECT m.name, 
       COUNT(br.borrow_id) AS total_borrows,
       CASE 
           WHEN COUNT(br.borrow_id) > 10 THEN 'Frequent Borrower'
           WHEN COUNT(br.borrow_id) BETWEEN 5 AND 10 THEN 'Regular Borrower'
           ELSE 'Occasional Borrower'
       END AS category
FROM Members m
LEFT JOIN Borrowed br ON m.member_id = br.member_id
GROUP BY m.member_id, m.name;

-- 15. Find members who return books quickly. Calculate the average duration it takes for each
-- member to return borrowed books, and then identify members whose average return time is less than 7 days.
SELECT m.name, AVG(return_date - borrow_date) AS avg_return_days
FROM Members m
JOIN Borrowed br ON m.member_id = br.member_id
WHERE br.return_date IS NOT NULL
GROUP BY m.member_id, m.name
HAVING AVG(return_date - borrow_date) < 7;

-- 16. Explore about Triggers in SQL. Then implement following two triggers for your Library database:
-- a. After each book issue, update the available copies of that book in Books table using a Trigger.
CREATE TRIGGER after_borrow_insert
AFTER INSERT ON Borrowed
FOR EACH ROW
UPDATE Books
SET available_copies = available_copies - 1
WHERE book_id = NEW.book_id;


-- b. Similarly, after each book return update the available copies of that book in Books table using a Trigger.

