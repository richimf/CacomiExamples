-- queries.sql
-- Fixtures for SQLRules.

-- CACOMI-EXPECT[SQLRules|critical]: GRANT ALL on production schema
GRANT ALL PRIVILEGES ON DATABASE production TO public;

-- CACOMI-EXPECT[SQLRules|critical]: EXEC with concatenation (dynamic SQL anti-pattern)
EXEC('SELECT * FROM users WHERE name = ''' + @userInput + '''');

-- CACOMI-EXPECT[SQLRules|high]: dynamic DDL built from variable
EXEC ('DROP TABLE ' + @tableName);

-- CACOMI-NEGATIVE[SQLRules]: read-only parameterized query
SELECT id, name FROM users WHERE id = :id;
