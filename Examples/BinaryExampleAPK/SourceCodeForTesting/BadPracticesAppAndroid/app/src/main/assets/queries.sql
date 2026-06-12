-- queries.sql
-- Equivalente Android de Injection/queries.sql — SQLRules. Empaquetado en assets/ (sobrevive al APK).

-- BAD: GRANT ALL sobre esquema de produccion // CACOMI-EXPECT: SQLRules
GRANT ALL PRIVILEGES ON DATABASE production TO public;

-- BAD: EXEC con concatenacion (SQL dinamico) // CACOMI-EXPECT: SQLRules
EXEC('SELECT * FROM users WHERE name = ''' + @userInput + '''');

-- BAD: DDL dinamico construido desde variable // CACOMI-EXPECT: SQLRules
EXEC ('DROP TABLE ' + @tableName);

-- NEGATIVO: query parametrizada de solo lectura // CACOMI-EXPECT: none
SELECT id, name FROM users WHERE id = :id;
