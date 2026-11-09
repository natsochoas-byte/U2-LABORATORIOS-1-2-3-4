# EVIDENCIAS
Natalia Ochoa León
# Actividad 10 — Diseñar y crear el registro de auditoría

## Comando ejecutado

```sql
CREATE SCHEMA auditoria;

REVOKE ALL ON SCHEMA auditoria FROM PUBLIC;

CREATE TABLE auditoria.cambios_clientes (
    id_evento        BIGSERIAL PRIMARY KEY,
    momento          TIMESTAMPTZ NOT NULL DEFAULT now(),
    usuario_sesion   TEXT        NOT NULL DEFAULT session_user,
    usuario_efectivo TEXT        NOT NULL DEFAULT current_user,
    aplicacion       TEXT        DEFAULT current_setting('application_name'),
    ip_cliente       INET        DEFAULT inet_client_addr(),
    operacion        TEXT        NOT NULL,
    id_cliente       BIGINT,
    valores_antes    JSONB,
    valores_despues  JSONB
);
```

## Resultado obtenido

Se creó el esquema `auditoria` y la tabla `auditoria.cambios_clientes` con los campos necesarios para guardar los cambios realizados en la tabla `clientes`.

La tabla incluye un identificador para cada evento, la fecha y hora, los usuarios, la aplicación, la dirección IP, el tipo de operación y los valores anteriores y nuevos del registro.

## Diseño de los campos

| Campo propuesto | Tipo | ¿Qué pregunta responde? | ¿Puede ser nulo? ¿Por qué? |
|---|---|---|---|
| `id_evento` | BIGSERIAL | ¿Cuál es el identificador del evento? | No, se genera automáticamente. |
| `momento` | TIMESTAMPTZ | ¿Cuándo ocurrió el cambio? | No, tiene un valor predeterminado. |
| `usuario_sesion` | TEXT | ¿Qué usuario inició la sesión? | No, se obtiene automáticamente. |
| `usuario_efectivo` | TEXT | ¿Con qué usuario se ejecutó la operación? | No, se obtiene automáticamente. |
| `aplicacion` | TEXT | ¿Desde qué aplicación se realizó? | Sí, puede no proporcionarse un nombre. |
| `ip_cliente` | INET | ¿Desde qué dirección IP se realizó? | Sí, puede ser una conexión local. |
| `operacion` | TEXT | ¿Qué tipo de operación se realizó? | No, debe identificarse el tipo de cambio. |
| `id_cliente` | BIGINT | ¿Qué cliente fue modificado? | Sí, puede no existir un cliente asociado. |
| `valores_antes` | JSONB | ¿Cómo estaban los datos antes del cambio? | Sí, cuando se trata de una inserción. |
| `valores_despues` | JSONB | ¿Cómo quedaron los datos después del cambio? | Sí, cuando se trata de una eliminación. |

## Interpretación

**1. ¿Por qué `momento` usa `TIMESTAMPTZ` y no `TIMESTAMP`?**

Porque permite guardar la fecha y hora considerando la zona horaria, lo que ayuda a identificar correctamente cuándo ocurrió cada cambio.

**2. ¿Por qué se guarda el registro completo en `JSONB` y no solo la columna que cambió?**

Porque permite conservar todos los datos del cliente antes y después de la modificación. Así se puede consultar el estado completo del registro y recuperar información si ocurre un cambio incorrecto.

**3. La tabla de auditoría también contendrá RFC. ¿Qué implica eso para su clasificación y su control de acceso?**

Significa que la tabla también contiene información sensible y debe protegerse. Su acceso debe limitarse únicamente al administrador y al personal autorizado para consultar la auditoría.