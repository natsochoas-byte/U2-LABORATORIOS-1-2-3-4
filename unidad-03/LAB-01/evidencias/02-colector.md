# EVIDENCIAS
**Estudiante:** Natalia Ochoa León  
**Actividad:** 2. Activar y consultar la bitácora de PostgreSQL.

## Comando ejecutado

```sql
ALTER SYSTEM SET logging_collector = on;

SELECT name, setting, pending_restart
FROM pg_settings
WHERE name = 'logging_collector';

SELECT name, setting, source
FROM pg_settings
WHERE name = 'logging_collector';

SELECT pg_current_logfile();

SELECT linea
FROM regexp_split_to_table(
    pg_read_file(pg_current_logfile()),
    E'\n'
) AS linea;

CREATE SCHEMA dba;

REVOKE ALL ON SCHEMA dba FROM PUBLIC;

CREATE VIEW dba.bitacora AS
SELECT t.n AS num, t.linea
FROM regexp_split_to_table(pg_read_file(pg_current_logfile()), E'\n')
WITH ORDINALITY AS t(linea, n)
WHERE t.linea <> '';
```

## Resultado obtenido

Se activó correctamente el registro automático después de reiniciar PostgreSQL. La configuración mostró `logging_collector` en `on`.

La ubicación del archivo obtenido fue:

```text
log/postgresql-2026-11-08_200714.log
```

Al consultar el archivo aparecieron registros del inicio del servidor, las conexiones de escucha, la disponibilidad para aceptar conexiones y un proceso de mantenimiento.

## Interpretación

Con esta actividad se logró que PostgreSQL guardara los eventos del servidor en una bitácora. También se pudo consultar su contenido desde pgAdmin y se preparó una vista para facilitar la revisión de esos registros.

El acceso a esta información debe limitarse al administrador y a las personas autorizadas, ya que contiene información sobre lo que ocurre en el servidor.