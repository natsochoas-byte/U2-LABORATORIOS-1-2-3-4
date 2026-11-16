# EVIDENCIAS
# Actividad 2. El incidente sin perfilado

**Estudiante:** Natalia Ochoa León  

## Comando o procedimiento

Primero se consultó el estado del perfilador:

```javascript
db.getProfilingStatus()
```

Después, desde el usuario `app_ventas`, se modificó el RFC del cliente con ID 3. Finalmente, se revisó la colección `system.profile` y se buscaron registros relacionados con el RFC y con la aplicación en la bitácora.

## Resultado obtenido

El perfilador estaba apagado:

```text
{ was: 0, slowms: 100, sampleRate: 1, ok: 1 }
```

La colección `system.profile` no tenía registros:

```text
0
```

La búsqueda del RFC modificado en la bitácora también devolvió:

```text
0
```

Sin embargo, aparecieron registros de conexión y autenticación exitosa de la aplicación, identificados con las conexiones `conn36`, `conn37` y `conn38`.

## Análisis

**1. ¿Puedes demostrar qué cambió? ¿Y quién se conectó a esa hora?**

No se puede demostrar el cambio del RFC mediante los registros obtenidos, porque el perfilador estaba apagado y la bitácora no mostró el valor modificado. Sí se puede comprobar que la aplicación se conectó y se autenticó correctamente con el usuario `app_ventas`.

**2. ¿Por qué `mongosh` abre varias conexiones (`conn8`, `conn9`, …) para una sola instrucción? ¿Cuál es la que se autentica?**

Porque `mongosh` puede abrir varias conexiones para comunicarse con el servidor. En los resultados aparecen varias conexiones, pero las que muestran el mensaje `Successfully authenticated` son las que completaron la autenticación.

## Conclusión

Con MongoDB Community no fue posible demostrar qué RFC se modificó cuando el perfilador estaba apagado. La bitácora permitió identificar conexiones y autenticaciones, pero no mostró la operación realizada. Esto demuestra una limitación al investigar incidentes con esta edición.