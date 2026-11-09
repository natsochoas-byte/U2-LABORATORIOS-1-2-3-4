# EVIDENCIAS
**Estudiante:** Natalia Ochoa León  
## Actividad 3. El incidente sin bitácora.

## Comando ejecutado

Desde la terminal se realizó el cambio del RFC con el usuario de ventas:

```bash
psql "postgresql://app_ventas:Ventas_Practica_2026@127.0.0.1/comercial?application_name=app-ventas-web" -c "UPDATE clientes SET rfc = 'GAMA780912XXX' WHERE id = 3"
```

Después, desde pgAdmin se buscó el cambio en la bitácora:

```sql
SELECT linea
FROM dba.bitacora
WHERE linea ILIKE '%update%'
   OR linea LIKE '%app_ventas%';
```

## Resultado obtenido

La terminal mostró:

```text
UPDATE 1
```

Al consultar la bitácora, el resultado fue:

```text
(0 rows)
```

Esto significa que el RFC se modificó, pero no apareció ningún registro del cambio ni de la conexión de `app_ventas`.

## Interpretación

1. **¿Puedes demostrar quién modificó el RFC?**  
   No. Aunque se utilizó el usuario `app_ventas`, la bitácora no guardó información que permita comprobar quién realizó el cambio.

2. **¿Puedes demostrar que el cambio no lo hizo `soporte_ana`?**  
   No. Al no existir un registro de la operación, tampoco se puede descartar que haya sido otro usuario.

3. **¿Los privilegios de la Unidad II impidieron el cambio? ¿Debían impedirlo?**  
   No lo impidieron porque el usuario de ventas tenía permiso para modificar ese dato. Los permisos debían limitar los cambios según las funciones de cada usuario.

4. **¿Qué tendría que haber estado configurado antes del incidente?**  
   Se debía configurar el registro de conexiones y de instrucciones SQL para guardar quién se conectó y qué cambios realizó.