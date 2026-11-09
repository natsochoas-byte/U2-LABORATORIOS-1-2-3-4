# EVIDENCIAS
## Actividad 1 — Revisar la configuración de registro por defecto
**Estudiante:** Natalia Ochoa León  

## Objetivo

Revisar la configuración inicial de registro de PostgreSQL para identificar qué información guarda el servidor sobre las conexiones, las sentencias ejecutadas y los eventos que ocurren en la base de datos.

## Comando ejecutado

Se ejecutó la siguiente consulta desde pgAdmin 4 utilizando el usuario administrador `postgres`:

```sql
SELECT name, setting, source
FROM pg_settings
WHERE name IN (
    'log_destination',
    'logging_collector',
    'log_directory',
    'log_filename',
    'log_connections',
    'log_disconnections',
    'log_line_prefix',
    'log_statement',
    'log_min_error_statement',
    'log_timezone'
)
ORDER BY name;
```

## Resultado obtenido

La consulta devolvió 10 filas con los siguientes valores:

| Parámetro | Valor | Source |
|---|---|---|
| log_connections | off | default |
| log_destination | stderr | default |
| log_directory | log | default |
| log_disconnections | off | default |
| log_filename | postgresql-%Y-%m-%d_%H%M%S.log | default |
| logging_collector | off | default |
| log_line_prefix | %m [%p] %q%u@%d | configuration file |
| log_min_error_statement | error | default |
| log_statement | none | default |
| log_timezone | America/Mazatlan | configuration file |

## Interpretación

1. Con esta configuración no se registra quién se conecta, porque `log_connections` está desactivado (`off`).

2. Las sentencias `UPDATE` no se registran de manera general, porque `log_statement` está configurado en `none`. Esto significa que PostgreSQL no registra normalmente las sentencias SQL ejecutadas.

3. La línea de bitácora incluye información como la fecha, hora, identificador del proceso, usuario y base de datos. Esto se debe a que `log_line_prefix` contiene los parámetros `%m`, `%p`, `%u` y `%d`. Sin embargo, no incluye la dirección IP del cliente.

4. Los eventos se registran utilizando la zona horaria `America/Mazatlan`. Esto importa al reconstruir una cronología porque permite relacionar los eventos con su hora correspondiente y evitar confusiones al compararlos con registros de otros sistemas.

5. Como `logging_collector` está desactivado, PostgreSQL envía los mensajes de registro a `stderr`. Por lo tanto, el destino final depende del mecanismo con el que se inició o desplegó el servidor, como el servicio del sistema operativo que administra PostgreSQL.

## Conclusión

Con esta actividad pude identificar cómo se encuentra configurado inicialmente el registro de PostgreSQL y qué información permite consultar. Observé que algunas opciones importantes están desactivadas, por lo que todavía no se registran las conexiones ni las sentencias SQL ejecutadas de manera general. Esta configuración servirá como punto de partida para activar el colector y mejorar el seguimiento de las actividades realizadas en la base de datos.