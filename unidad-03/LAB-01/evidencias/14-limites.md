# EVIDENCIA
Natalia Ochoa León

# Actividad 15 — Límites: lecturas y volumen

## Comando ejecutado

**1. Consultar datos sensibles desde la cuenta de soporte:**

```bash
psql "postgresql://soporte_ana:Soporte_Practica_2026@127.0.0.1/comercial" -c "SELECT nombre, rfc, telefono FROM clientes WHERE id = 3"
```

**2. Realizar una modificación masiva:**

```sql
UPDATE clientes SET segmento = 'regular';
```

**3. Consultar las líneas registradas en la bitácora:**

```sql
SELECT count(*) AS lineas_bitacora
FROM dba.bitacora
WHERE linea LIKE '%statement: UPDATE clientes SET segmento%';
```

**4. Consultar los registros de auditoría por operación:**

```sql
SELECT operacion, count(*)
FROM auditoria.cambios_clientes
GROUP BY operacion
ORDER BY operacion;
```

**5. Consultar las lecturas realizadas por soporte:**

```sql
SELECT count(*) AS lecturas_soporte
FROM dba.bitacora
WHERE linea LIKE '%user=soporte_ana%SELECT nombre, rfc%';
```

## Resultado obtenido

Los resultados mostraron lo siguiente:

**Líneas en la bitácora:**

```text
lineas_bitacora
-----------------
1
```

**Operaciones registradas en auditoría:**

```text
operacion | count
----------+------
DELETE    | 1
INSERT    | 1
UPDATE    | 6
```

**Lecturas de soporte:**

```text
lecturas_soporte
-----------------
0
```

El cambio masivo produjo una línea en la bitácora y cinco registros nuevos en la tabla de auditoría. La consulta de datos sensibles no quedó registrada porque no existe un disparador para las operaciones `SELECT` y la configuración `log_statement = 'mod'` no registra lecturas.

## Interpretación

**1. Si clientes tuviera un millón de registros, ¿qué ocurriría con la auditoría tras un UPDATE sin WHERE?**

Se generarían un millón de registros de auditoría, uno por cada cliente modificado. Esto aumentaría considerablemente el espacio utilizado y podría afectar el rendimiento de la base de datos.

**2. Propón quién podría autorizar la depuración de auditoria.cambios_clientes.**

La depuración debería ser autorizada por el responsable de seguridad de la información junto con el área encargada de protección de datos, siguiendo las políticas de retención de la organización.

**3. ¿Por qué log_statement = 'all' puede convertir la bitácora en un nuevo depósito de datos sensibles?**

Porque registraría todas las consultas, incluyendo aquellas que muestran RFC, teléfonos y otros datos personales. De esta manera, la bitácora también almacenaría información sensible que necesitaría protección y control de acceso.