# EVIDENCIAS
Natalia Ochoa León

# Actividad 12 — El incidente auditado

## Comando ejecutado

**1. Modificación del RFC desde la aplicación:**

```bash
psql "postgresql://app_ventas:Ventas_Practica_2026@127.0.0.1/comercial?application_name=app-ventas-web" -c "UPDATE clientes SET rfc = 'GAMA780912ZZZ' WHERE id = 3"
```

**2. Intento de consultar la auditoría desde la aplicación:**

```bash
psql "postgresql://app_ventas:Ventas_Practica_2026@127.0.0.1/comercial" -c "SELECT * FROM auditoria.cambios_clientes"
```

**3. Consulta de auditoría desde la sesión de administrador:**

```sql
SELECT id_evento, momento, usuario_sesion, usuario_efectivo, aplicacion, ip_cliente, operacion, id_cliente
FROM auditoria.cambios_clientes
ORDER BY id_evento;
```

**4. Comparación de los valores anteriores y nuevos:**

```sql
SELECT a.id_evento, a.momento, a.usuario_sesion, a.ip_cliente,
       d.key AS campo,
       a.valores_antes ->> d.key AS antes,
       d.value #>> '{}' AS despues
FROM auditoria.cambios_clientes a
CROSS JOIN LATERAL jsonb_each(a.valores_despues) d
WHERE a.operacion = 'UPDATE'
AND a.valores_antes -> d.key IS DISTINCT FROM d.value
ORDER BY a.id_evento;
```

## Resultado obtenido

La modificación del RFC se realizó correctamente y apareció:

```text
UPDATE 1
```

Al intentar consultar la tabla de auditoría desde `app_ventas`, PostgreSQL rechazó el acceso:

```text
ERROR: permission denied for schema auditoria
```

Desde la sesión de administrador se encontró el registro del cambio con los siguientes datos:

| Campo | Valor |
|---|---|
| id_evento | 1 |
| usuario_sesion | app_ventas |
| usuario_efectivo | postgres |
| aplicacion | app-ventas-web |
| ip_cliente | 127.0.0.1 |
| operacion | UPDATE |
| id_cliente | 3 |

La comparación de los valores mostró que el campo modificado fue `rfc`:

| Campo | Antes | Después |
|---|---|---|
| rfc | GAMA780912XYZ | GAMA780912ZZZ |

## Interpretación

**1. Compara tu hipótesis de la Actividad 11 con este resultado.**

Mi hipótesis fue correcta porque `app_ventas` pudo modificar los datos y el disparador guardó el cambio en la tabla de auditoría, aunque la aplicación no tuvo permiso para consultar directamente esa tabla. Esto funciona porque la función utiliza `SECURITY DEFINER` y se ejecuta con los permisos de su propietario.

**2. Escribe la sentencia UPDATE que restauraría el valor anterior.**

UPDATE clientes
SET rfc = 'GAMA780912XYZ'
WHERE id = 3;


**3. ¿Qué columna conserva más valor para una investigación: aplicacion o ip_cliente? ¿Cuál puede falsificar el cliente con más facilidad?**

La columna `ip_cliente` conserva más valor porque permite identificar desde qué dirección se realizó la conexión. La columna `aplicacion` puede falsificarse más fácilmente porque el propio cliente puede declarar el nombre que quiera al conectarse.