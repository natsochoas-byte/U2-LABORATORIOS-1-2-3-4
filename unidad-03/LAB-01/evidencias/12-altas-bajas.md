# EVIDENCIAS
Natalia Ochoa León

# Actividad 13 — Altas y bajas

## Comando ejecutado

**1. Insertar un nuevo cliente:**

```sql
INSERT INTO clientes (nombre, correo, rfc, edad, ciudad, codigo_postal)
VALUES ('Pedro Ruiz', 'pedro.ruiz@example.test', 'RUPE950101AAA', 30, 'Guasave', '81000');
```

**2. Eliminar el cliente:**

```sql
DELETE FROM clientes WHERE nombre = 'Pedro Ruiz';
```

**3. Consultar los registros de auditoría:**

```sql
SELECT id_evento, usuario_sesion, aplicacion, ip_cliente, operacion, id_cliente,
       valores_antes ->> 'rfc' AS rfc_antes,
       valores_despues ->> 'rfc' AS rfc_despues
FROM auditoria.cambios_clientes
ORDER BY id_evento;
```

## Resultado obtenido

Se insertó y después se eliminó el cliente Pedro Ruiz. Aunque ya no aparece en la tabla `clientes`, la auditoría conservó los dos eventos:

| id_evento | usuario_sesion | aplicacion | ip_cliente | operacion | id_cliente | rfc_antes | rfc_despues |
|---|---|---|---|---|---|---|---|
| 1 | app_ventas | app-ventas-web | 127.0.0.1 | UPDATE | 3 | GAMA780912XYZ | GAMA780912ZZZ |
| 2 | postgres | psql | | INSERT | 6 | | RUPE950101AAA |
| 3 | postgres | psql | | DELETE | 6 | RUPE950101AAA | |

## Interpretación

**1. El cliente Pedro Ruiz ya no existe en clientes. ¿Dónde queda evidencia de que existió y de sus datos?**

La evidencia queda en la tabla `auditoria.cambios_clientes`, porque conserva el registro de inserción y eliminación, incluyendo los datos anteriores y nuevos del cliente.

**2. ¿Por qué ip_cliente está vacía en los eventos 2 y 3?**

Porque las operaciones se realizaron desde una sesión local del administrador, por lo que no había una dirección IP de cliente registrada.

**3. La política de retención de la Unidad II pedía eliminar datos cuando ya no fueran necesarios. ¿Qué conflicto aparece? ¿Quién debe resolverlo?**

El conflicto es que, aunque se elimine un cliente de la tabla principal, sus datos personales permanecen guardados en la auditoría. La organización debe definir cuánto tiempo conservar esos registros y cuándo eliminarlos, tomando en cuenta las necesidades de auditoría y la protección de datos personales.