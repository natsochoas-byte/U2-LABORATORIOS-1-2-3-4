# EVIDENCIAS
# Actividad 9 — Sesiones activas con pg_stat_activity
Natalia Ochoa León
## Comando ejecutado

**1. Simular un reporte de larga duración desde una segunda terminal:**

```bash
psql "postgresql://soporte_ana:Soporte_Practica_2026@127.0.0.1/comercial?application_name=reporte-mensual" -c "SELECT pg_sleep(90)"
```

**2. Consultar las sesiones activas desde pgAdmin:**

```sql
SELECT pid, usename, application_name, client_addr, backend_start, state, left(query, 30) AS query
FROM pg_stat_activity
WHERE backend_type = 'client backend';
```

**3. Buscar el PID en la bitácora:**

```sql
SELECT linea
FROM dba.bitacora
WHERE linea LIKE '%[189]%'
ORDER BY num;
```

**4. Repetir la consulta de sesiones activas después de terminar el reporte.**

## Resultado obtenido

Durante la ejecución del reporte, `pg_stat_activity` mostró dos sesiones activas:

- `postgres`, con la aplicación `psql`, ejecutando la consulta de administración.
- `soporte_ana`, con la aplicación `reporte-mensual`, ejecutando `SELECT pg_sleep(90)` desde `127.0.0.1`.

Al buscar el PID de `soporte_ana` en la bitácora se encontraron sus registros. Después de terminar los 90 segundos, al repetir la consulta, la sesión del reporte ya no apareció como activa.

## Interpretación

**1. ¿Qué columna permite relacionar una sesión con sus líneas de bitácora?**

La columna `pid`, porque permite identificar el proceso de cada sesión y buscar sus registros correspondientes en la bitácora.

**2. Después de que termina el reporte, ¿qué fuente conserva evidencia de que existió?**

La bitácora de PostgreSQL, porque conserva los registros de la sesión aunque ya haya terminado y no aparezca en `pg_stat_activity`.

**3. ¿Por qué `client_addr` aparece vacío en la sesión del administrador?**

Porque la conexión del administrador se realiza localmente desde pgAdmin y no mediante una dirección IP de cliente.