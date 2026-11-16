# EVIDENCIAS
# Actividad 3. Activar el perfilador y registrar operaciones

**Estudiante:** Natalia Ochoa León  

## Comando o procedimiento

Se activó el perfilador en nivel 2 en la base de datos `comercial`:

```javascript
db.setProfilingLevel(2)
db.getProfilingStatus()
```

Después, desde el usuario `app_ventas`, se realizó una consulta, una actualización del RFC y la eliminación de un cliente. Finalmente, se consultaron los registros de `system.profile`.

## Resultado obtenido

El perfilador quedó activado en nivel 2. En `system.profile` aparecieron tres operaciones:

| # | `op` | Usuario | Cliente | Aplicación | Momento (UTC) | Qué hizo | Documentos afectados |
|---|---|---|---|---|---|---|---|
| 1 | `query` | `app_ventas@comercial` | `127.0.0.1` | `app-ventas-web` | 04:35:08.265 | Consultó clientes de Culiacán | 3 devueltos |
| 2 | `update` | `app_ventas@comercial` | `127.0.0.1` | `app-ventas-web` | 04:35:08.268 | Cambió el RFC del cliente con ID 3 | 1 modificado |
| 3 | `remove` | `app_ventas@comercial` | `127.0.0.1` | `app-ventas-web` | 04:35:08.276 | Eliminó el cliente con ID 2 | 1 eliminado |

La consulta revisó 5 documentos y devolvió 3. La actualización modificó 1 documento y la eliminación borró 1 documento.

## Análisis

**1. ¿Puedes saber cuál era el RFC antes del cambio con la información de `system.profile`?**

No. El perfilador muestra el nuevo RFC que se estableció, pero no guarda el valor anterior.

**2. ¿Puedes saber qué datos tenía el documento eliminado?**

No. Se puede identificar que se eliminó el documento con ID 2, pero el perfilador no muestra todos sus datos.

**3. A diferencia de `log_statement = 'mod'` en PostgreSQL, el nivel 2 sí registró la consulta. ¿Qué ventaja y qué riesgo tiene eso?**

La ventaja es que permite revisar también las consultas y saber qué información se buscó. El riesgo es que puede registrar información sensible y generar muchos registros, además de ocupar espacio.

**4. ¿Por qué el campo `user` incluye `@comercial`?**

Porque indica el usuario que realizó la operación y la base de datos donde está autenticado. En este caso, el usuario fue `app_ventas` y la base de datos fue `comercial`.

## Conclusión

El perfilador en nivel 2 permitió registrar las consultas, actualizaciones y eliminaciones realizadas por la aplicación. Esto ayuda a investigar operaciones, aunque no permite recuperar los valores anteriores ni todos los datos de documentos eliminados.