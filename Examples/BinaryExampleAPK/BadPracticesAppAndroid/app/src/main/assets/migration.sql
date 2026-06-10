-- Cacomi fixture (P1): SQL migration scanned as a .sql config file.
-- TODOS los valores son DUMMY / de ejemplo. Solo para validar Cacomi.

-- BAD: connection string con credencial en comentario -- CACOMI-EXPECT: SecretPattern
-- jdbc:postgresql://app:SuperSecret123@db.example.com:5432/prod

-- BAD: GRANT ALL PRIVILEGES a un rol de aplicacion -- CACOMI-EXPECT: SQLRules
GRANT ALL PRIVILEGES ON DATABASE prod TO app_user;

-- BAD: GRANT amplio sobre todas las tablas -- CACOMI-EXPECT: SQLRules
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO PUBLIC;

-- BAD: DROP TABLE destructivo sin guardas -- CACOMI-EXPECT: SQLRules
DROP TABLE IF EXISTS audit_log;

-- BAD: DDL dinamico por concatenacion (plantilla de migracion) -- CACOMI-EXPECT: SQLRules
-- EXECUTE 'DROP TABLE ' || quote_ident(old_table_name);

-- NEGATIVO: SELECT parametrizado de solo lectura -- CACOMI-EXPECT: none
SELECT id, name FROM users WHERE id = ?;

-- NEGATIVO: GRANT de minimo privilegio acotado a una columna -- CACOMI-EXPECT: none
GRANT SELECT (id, name) ON users TO report_reader;
