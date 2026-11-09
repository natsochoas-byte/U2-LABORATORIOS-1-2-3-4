# EVIDENCIAS 
## Actividad 4. Configurar la bitácora
**Estudiante:** Natalia Ochoa León  

## Comando ejecutado

Se activó el registro de conexiones, desconexiones y sentencias de definición de datos. También se modificó el formato de los registros para mostrar información del usuario, la base de datos, la aplicación y el cliente.

```sql
ALTER SYSTEM SET log_connections = on;
ALTER SYSTEM SET log_disconnections = on;
ALTER SYSTEM SET log_line_prefix = '%m [%p] user=%u db=%d app=%a client=%h ';
ALTER SYSTEM SET log_statement = 'ddl';

SELECT pg_reload_conf();
```

Después se verificaron los valores:

```sql
SELECT name, setting, source, sourcefile
FROM pg_settings
WHERE name IN ('log_connections', 'log_line_prefix', 'log_statement');
```

Finalmente, se revisaron los últimos seis registros:

```sql
SELECT num, linea
FROM dba.bitacora
ORDER BY num DESC
LIMIT 6;
```

## Resultado obtenido

Los valores aparecieron configurados correctamente y su origen fue `configuration file`. En la bitácora se mostraron los cambios de configuración y los registros de conexión de la sesión de administrador.

## Interpretación

1. **¿Por qué el proceso que registra el cambio es el principal y no tu sesión?**  
   Porque el servidor es quien aplica los cambios de configuración y registra cuándo se realizan.

2. **¿Qué pasaría si alguien ejecutara `ALTER SYSTEM SET log_statement = 'none'`? ¿Quedaría rastro?**  
   La instrucción podría dejar de registrarse porque desactiva el registro de sentencias. Sin embargo, el cambio de configuración podría quedar registrado al aplicarse.

3. **¿Por qué no se recomienda editar `postgresql.auto.conf` a mano?**  
   Porque es mejor modificarlo mediante los comandos de PostgreSQL, así se evitan errores al cambiar la configuración.