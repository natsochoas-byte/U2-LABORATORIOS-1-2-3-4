# EVIDENCIAS
Natalia Ochoa León

# Actividad 14 — Intentar manipular la auditoría

## Comando ejecutado

**1. Intentar modificar la auditoría desde la cuenta de la aplicación:**


psql "postgresql://app_ventas:Ventas_Practica_2026@127.0.0.1/comercial?application_name=app-ventas-web" -c "DELETE FROM auditoria.cambios_clientes" -c "ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes"


**2. Desactivar el disparador desde la cuenta de administrador:**


ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes;

UPDATE clientes SET rfc = 'GAMA780912GHI' WHERE id = 3;

ALTER TABLE clientes ENABLE TRIGGER trg_auditoria_clientes;

SELECT count(*) FROM auditoria.cambios_clientes;


**3. Consultar la bitácora:**


SELECT linea FROM dba.bitacora
WHERE linea ~ 'statement: (ALTER TABLE clientes (DIS|EN)ABLE|UPDATE clientes SET rfc = .GAMA780912GHI)'
ORDER BY num;


## Resultado obtenido

La cuenta `app_ventas` no pudo eliminar los registros de auditoría ni desactivar el disparador. PostgreSQL mostró los errores:


ERROR: permission denied for schema auditoria
ERROR: must be owner of table clientes


Desde la cuenta de administrador se desactivó el disparador, se modificó el RFC y después se volvió a activar. El conteo de registros de auditoría permaneció en `3`, por lo que ese cambio no quedó registrado en la tabla de auditoría.

En la bitácora aparecieron las sentencias para desactivar y activar el disparador, además de la modificación del RFC. También quedó registrado el intento de `app_ventas`, aunque la operación fue rechazada.

## Interpretación

**1. ¿Qué evidencia permite detectar que hubo un cambio sin auditar?**

La bitácora del servidor, porque registra que el administrador desactivó el disparador y después modificó el RFC, aunque ese cambio no apareció en la tabla de auditoría.

**2. ¿Qué control administrativo (no técnico) reduciría este riesgo?**

Separar las responsabilidades y establecer que ninguna persona pueda modificar los datos y controlar por sí sola los registros de auditoría. También se deben realizar revisiones periódicas.

**3. Relaciona esta actividad con el principio de separación de funciones de la Unidad II.**

Esta actividad demuestra que quien administra la base de datos no debería ser la misma persona que supervisa y protege las evidencias. Así se evita que alguien pueda modificar información y ocultar sus propias acciones sin que otra persona lo revise.