--02-configuracion-bitacora
--Natalia Ochoa León
--Actividad 4-Configurar la bitácora
--En la sesión de administrador:
ALTER SYSTEM SET log_connections = on;
ALTER SYSTEM SET log_disconnections = on;
ALTER SYSTEM SET log_line_prefix = '%m [%p] user=%u db=%d app=%a client=%h ';
ALTER SYSTEM SET log_statement = 'ddl';
SELECT pg_reload_conf();

--Verificar el origen de los valores con una consulta nueva (ver el recuadro siguiente):
SELECT name, setting, source, sourcefile
FROM pg_settings
WHERE name IN ('log_connections', 'log_line_prefix', 'log_statement');

--Revisa las últimas líneas de la bitácora:
SELECT num, linea FROM dba.bitacora ORDER BY num DESC LIMIT 6;

--Actividad 5 — Accesos exitosos y fallidos
--Filtra la bitácora por la dirección del cliente:
SELECT linea
FROM dba.bitacora
WHERE linea LIKE '%client=127.0.0.1%'
ORDER BY num;