--03-privilegios-estructura.sql
--Natalia Ochoa León

--Actividad 6 — Cambios de privilegios y de estructura
--Con log_statement = 'ddl', en la sesión de administrador:
SELECT current_user, current_database();
REVOKE UPDATE ON clientes FROM soporte;
GRANT UPDATE ON clientes TO app_ventas;
ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20);

--Crear un rol desechable escribiendo la contraseña en la sentencia, y elimínalo:
CREATE ROLE rol_temporal LOGIN PASSWORD 'Temporal_Practica_2026';
DROP ROLE rol_temporal;

--Consulta las sentencias registradas:
SELECT linea FROM dba.bitacora WHERE linea LIKE '%statement:%' ORDER BY num;

--Actividad 7 — Modificaciones de datos: ddl frente a mod
--Repite el cambio del incidente con log_statement = 'ddl':
SELECT linea FROM dba.bitacora WHERE linea LIKE '%user=app_ventas%' ORDER BY num DESC LIMIT 3;

--Cambia el nivel:
ALTER SYSTEM SET log_statement = 'mod';
SELECT pg_reload_conf();

--Ejecuta una modificación y una consulta:
SELECT linea FROM dba.bitacora
WHERE linea LIKE '%log_statement%' OR linea LIKE '%user=app_ventas%statement:%'
ORDER BY num;

--Actividad 8 — Errores y operaciones rechazadas
--El administrador intenta eliminar un rol que todavía tiene privilegios:
CREATE ROLE soporte_ana LOGIN PASSWORD 'Soporte_Practica_2026';
GRANT SELECT ON clientes TO soporte_ana;
DROP ROLE soporte_ana;

SELECT linea FROM dba.bitacora
WHERE linea ~ '(ERROR|STATEMENT|DETAIL):  (permission|privileges|role|DELETE|DROP)'
ORDER BY num;

--Actividad 9 — Sesiones activas con pg_stat_activity
--En la sesion de administrador
SELECT pid, usename, application_name, client_addr, backend_start, state, left(query, 30) AS query
FROM pg_stat_activity
WHERE backend_type = 'client backend';

--Busca el mismo PID en la bitácora (sustituye 189 por el tuyo):
SELECT linea FROM dba.bitacora WHERE linea LIKE '%[189]%' ORDER BY num;