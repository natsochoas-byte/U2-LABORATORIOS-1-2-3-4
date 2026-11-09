--UNIDAD 3-Laboratorio 1 — Bitácoras y auditoría del dato en PostgreSQL
--PARTE A — Bitácora del servidor
--Natalia Ochoa León

--Actividad 1 — Revisar la configuración de registro por defecto
SELECT name, setting, source
FROM pg_settings
WHERE name IN ('log_destination', 'logging_collector', 'log_directory', 'log_filename',
               'log_connections', 'log_disconnections', 'log_line_prefix',
               'log_statement', 'log_min_error_statement', 'log_timezone')
ORDER BY name;

--Actividad 2 — Que el servidor administre su propia bitácora
--Activa el colector:
ALTER SYSTEM SET logging_collector = on;

SELECT name, setting, pending_restart FROM pg_settings WHERE name = 'logging_collector';

--Comprobar resultado:
SELECT name, setting, source FROM pg_settings WHERE name = 'logging_collector';
SELECT pg_current_logfile();

--La ruta es relativa al directorio de datos (sección 6.3).
--Lee el archivo desde el propio motor:
SELECT linea FROM regexp_split_to_table(pg_read_file(pg_current_logfile()), E'\n') AS linea;

--Crear una vista de uso exclusivo del administrado
CREATE SCHEMA dba;
REVOKE ALL ON SCHEMA dba FROM PUBLIC;

CREATE VIEW dba.bitacora AS
SELECT t.n AS num, t.linea
FROM regexp_split_to_table(pg_read_file(pg_current_logfile()), E'\n')
     WITH ORDINALITY AS t(linea, n)
WHERE t.linea <> '';

-- últimas 10 líneas
SELECT num, linea FROM dba.bitacora ORDER BY num DESC LIMIT 10;

-- líneas que contienen un texto, sin distinguir mayúsculas
SELECT linea FROM dba.bitacora WHERE linea ILIKE '%update%';

-- líneas que cumplen una expresión regular
SELECT linea FROM dba.bitacora WHERE linea ~ '(FATAL|ERROR)';

--Actividad 3 — El incidente sin bitácora
--Buscar evidencia en la sesión de administrador:
SELECT linea FROM dba.bitacora
WHERE linea ILIKE '%update%' OR linea LIKE '%app_ventas%';










