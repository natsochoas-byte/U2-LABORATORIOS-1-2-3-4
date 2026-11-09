# EVIDENCIAS
# Evidencia 05 — Accesos exitosos y fallidos
**Estudiante:** Natalia Ochoa León  

## Comando ejecutado

Se realizaron tres intentos de conexión desde la terminal:

```bash
psql "postgresql://app_ventas:incorrecta@127.0.0.1/comercial" -c "SELECT 1"

psql "postgresql://usuario_inexistente:x@127.0.0.1/comercial" -c "SELECT 1"

psql "postgresql://app_ventas:Ventas_Practica_2026@127.0.0.1/comercial?application_name=app-ventas-web" -c "SELECT count(*) FROM clientes"
```

Después, en pgAdmin se consultaron los registros de conexiones:

```sql
SELECT linea
FROM dba.bitacora
WHERE linea LIKE '%client=127.0.0.1%'
ORDER BY num;
```

## Resultado obtenido

Los primeros dos intentos de conexión fueron rechazados por errores de autenticación. El primero indicó que la contraseña de `app_ventas` era incorrecta y el segundo que el rol `usuario_inexistente` no existía.

El tercer intento se realizó correctamente y devolvió un total de **5 clientes**.

En la bitácora aparecieron los intentos fallidos, los mensajes de error, la regla de autenticación aplicada de `pg_hba.conf` y la conexión exitosa de `app_ventas` con la aplicación `app-ventas-web`.

## Interpretación

**1. ¿La bitácora registra el usuario app_ventas en el intento fallido? ¿Eso prueba que la aplicación de ventas intentó entrar? ¿Qué prueba realmente?**

Sí, registra el nombre `app_ventas`, pero eso no demuestra que haya sido la aplicación de ventas. Solamente demuestra que alguien intentó conectarse usando ese usuario desde la dirección `127.0.0.1`, pero la contraseña fue incorrecta.

**2. ¿Qué información adicional registra PostgreSQL cuando el rol no existe? ¿Por qué aparece en la bitácora y no en el mensaje del cliente?**

Registra que el rol `usuario_inexistente` no existe. Esta información queda en la bitácora para que el administrador pueda revisar lo ocurrido, mientras que al cliente se le muestra un mensaje más general para no revelar información sobre los usuarios de la base de datos.

**3. ¿Por qué aparece app=[unknown] en el intento fallido, pero app=app-ventas-web en la desconexión?**

Porque el intento fallido no logró establecer una conexión, por lo que PostgreSQL no pudo identificar la aplicación. En cambio, en la conexión exitosa sí se pudo identificar mediante el nombre `app-ventas-web`.

**4. ¿Qué patrón de varias líneas haría sospechar un ataque de fuerza bruta? Escribe una consulta que cuente intentos fallidos por usuario.**

Muchos intentos fallidos en poco tiempo, especialmente desde una misma dirección IP y probando diferentes contraseñas o usuarios, podrían indicar un ataque de fuerza bruta.

La siguiente consulta permite contar los intentos fallidos por usuario:

```sql
SELECT
    substring(linea FROM 'password authentication failed for user "([^"]+)"') AS usuario,
    COUNT(*) AS intentos_fallidos
FROM dba.bitacora
WHERE linea LIKE '%FATAL:  password authentication failed%'
GROUP BY usuario
ORDER BY intentos_fallidos DESC;
```
## Lectura de una línea campo por campo

| Campo | Valor | Significado |
|---|---|---|
| Fecha y hora | `2026-10-25 22:50:00.334 UTC` | Indica cuándo ocurrió el intento de conexión. |
| PID | `91` | Identifica el proceso de PostgreSQL que atendió la conexión. |
| Usuario | `app_ventas` | Es el usuario que intentó iniciar sesión. |
| Base de datos | `comercial` | Es la base de datos a la que intentó conectarse. |
| Aplicación | `[unknown]` | No se pudo identificar la aplicación porque la conexión falló. |
| Cliente | `127.0.0.1` | Indica la dirección desde donde se realizó el intento. |
| Severidad | `FATAL` | Señala que ocurrió un error que impidió establecer la conexión. |
| Mensaje | `password authentication failed` | Indica que la contraseña proporcionada fue incorrecta. |
| Regla aplicada | `pg_hba.conf` línea 119 | Identifica la regla de autenticación utilizada por PostgreSQL. |
