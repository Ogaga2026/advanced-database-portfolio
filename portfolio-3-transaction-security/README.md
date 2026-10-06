# Portfolio 3: Transactions and Security

This portfolio covers transaction management and database security.

## Contents
- security_and_transactions.sql

## A. Transactions

### Why Transactions?
To ensure data stays consistent when doing multiple operations.

### Examples
1.  **Successful Transaction:** When a book is sold, we reduce stock and add to sales table together. Both must happen or none.
    - `START TRANSACTION; ... COMMIT;`

2.  **Rollback:** If stock goes negative, we can undo with `ROLLBACK;`

3.  **Isolation Level:** `SERIALIZABLE` prevents dirty reads when two people buy same book.

## B. Security

### Users Created
- `book_admin` - Full access
- `book_staff` - Can SELECT, INSERT, UPDATE
- `book_reader` - Can only SELECT (read only)

### Privileges
- `GRANT ALL PRIVILEGES` for admin
- `GRANT SELECT, INSERT, UPDATE` for staff
- `GRANT SELECT` for reader

### How to Check
```sql
SHOW GRANTS FOR 'book_staff'@'localhost';
C. Backup and RecoveryBackup: mysqldump -u root -p bookstore > bookstore_backup.sqlRestore: mysql -u root -p bookstore < bookstore_backup.sqlThis ensures data can be recovered if system fails.
