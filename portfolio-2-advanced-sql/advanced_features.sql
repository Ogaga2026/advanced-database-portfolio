-- Portfolio 2: Advanced SQL Features

-- 1. VIEW: Show book details with author and publisher
CREATE VIEW vw_book_details AS
SELECT 
    b.title,
    a.name AS author_name,
    p.name AS publisher_name,
    b.price
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN publishers p ON b.publisher_id = p.publisher_id;

-- 2. STORED PROCEDURE: Get books by author
DELIMITER //
CREATE PROCEDURE GetBooksByAuthor(IN authorName VARCHAR(100))
BEGIN
    SELECT b.title, b.price, b.publication_year
    FROM books b
    JOIN authors a ON b.author_id = a.author_id
    WHERE a.name = authorName;
END //
DELIMITER ;

-- 3. TRIGGER: Update stock log after book purchase
CREATE TABLE IF NOT EXISTS stock_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    action VARCHAR(50),
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER after_book_insert
AFTER INSERT ON books
FOR EACH ROW
BEGIN
    INSERT INTO stock_log (book_id, action) 
    VALUES (NEW.book_id, 'New book added');
END //
DELIMITER ;

-- 4. INDEX for performance
CREATE INDEX idx_book_title ON books(title);
CREATE INDEX idx_author_name ON authors(name);
