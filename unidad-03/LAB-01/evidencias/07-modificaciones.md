# EVIDENCIAS 
## Evidencia 07 — Modificaciones de datos: ddl frente a mod
**Estudiante:** Natalia Ochoa León  

## Comando ejecutado

Primero se realizó una modificación con `log_statement = 'ddl'` desde la terminal:

```bash
psql "postgresql://app_ventas:Ventas_Practica_2026@127.0.0.1/comercial?application_name=app-ventas-web" -c "UPDATE clientes SET rfc = 'GAMA780912XYZ' WHERE id = 3"
```

Después se consultó la bitácora en pgAdmin:

```sql
SELECT linea
FROM dba.bitacora
WHERE linea LIKE '%user=app_ventas%'
ORDER BY num DESC
LIMIT 3;
```

Se cambió la configuración y se recargó:

```sql
ALTER SYSTEM SET log_statement = 'mod';

SELECT pg_reload_conf();
```

Se ejecutó una modificación y una consulta desde la terminal:

```bash
psql "postgresql://app_ventas:Ventas_Practica_2026@127.0.0.1/comercial?application_name=app-ventas-web" -c "UPDATE clientes SET telefono = '6679990000' WHERE id = 3" -c "SELECT nombre, rfc FROM clientes WHERE id = 3"
```

Finalmente, se consultó la bitácora:

```sql
SELECT linea
FROM dba.bitacora
WHERE linea LIKE '%log_statement%'
   OR linea LIKE '%user=app_ventas%statement:%'
ORDER BY num;
```

## Resultado obtenido

Con `log_statement = 'ddl'`, se registraron los eventos de conexión y desconexión de `app_ventas`, pero no apareció la sentencia `UPDATE`.

Después de cambiar la configuración a `log_statement = 'mod'`, la bitácora registró el cambio de configuración y la modificación del teléfono:

```text
parameter "log_statement" changed to "mod"

statement: UPDATE clientes SET telefono = '6679990000' WHERE id = 3
```

La consulta `SELECT` se ejecutó, pero no quedó registrada en la bitácora.

## Interpretación

**1. ¿Qué nivel habría registrado la lectura del RFC? ¿Qué costo tendría en un servidor con miles de consultas por minuto?**

El nivel `all` habría registrado también la consulta `SELECT` que leyó el RFC. Sin embargo, en un servidor con miles de consultas por minuto generaría demasiados registros, ocuparía mucho espacio y podría afectar el rendimiento.

**2. ¿Qué le falta a esta bitácora para revertir el cambio con certeza?**

Le falta guardar el valor anterior del teléfono, ya que solamente registra la sentencia que realizó el cambio. Sin conocer el dato anterior, no se puede recuperar con certeza su valor original.