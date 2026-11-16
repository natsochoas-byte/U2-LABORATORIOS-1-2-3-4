# EVIDENCIAS
# Actividad 8. Conservación: exportar antes de perder

**Estudiante:** Natalia Ochoa León  

## Comando o procedimiento

Primero se exportó la bitácora de MongoDB a `evidencias/bitacora-mongod.log`. Después se reinició el contenedor y se consultó nuevamente el estado del perfilador, los documentos de `system.profile` y la cantidad de eventos disponibles en `getLog`.

Posteriormente, se exportó la colección `system.profile` a `evidencias/system-profile.json`. Finalmente, se calcularon los hashes SHA-256 de ambos archivos y se verificaron.

## Resultado obtenido

Después del reinicio se obtuvieron estos resultados:

| Comprobación | Resultado |
|---|---|
| Nivel del perfilador | `0` |
| Documentos en `system.profile` | `2` |
| Eventos actuales en `getLog` | `79` |

Se generaron los siguientes archivos:

- `bitacora-mongod.log` (223 KB).
- `system-profile.json` (601 bytes).
- `hashes.sha256`.

La verificación de los hashes mostró que ambos archivos coincidían correctamente.

## Análisis

**1. Menciona tres formas en que la evidencia del perfilador o de la bitácora puede perderse sin que nadie la borre deliberadamente.**

La evidencia puede perderse por un reinicio del servidor, porque los eventos de `getLog` se guardan en memoria. También puede desaparecer por la rotación de los archivos de bitácora o porque `system.profile` alcance su límite de tamaño y se descarten registros antiguos.

**2. ¿Por qué el tamaño de 1 MB de `system.profile` es un problema de conservación y no solo de espacio?**

Porque tiene una capacidad limitada y, cuando se llena, los registros antiguos pueden dejar de estar disponibles. Esto puede provocar que se pierda información necesaria para investigar cambios u operaciones anteriores.

**3. ¿Por qué `getLog` sirve para interpretar pero no para conservar?**

Porque permite consultar los eventos recientes de MongoDB, pero solamente mantiene los últimos 1024 en memoria y se vacía al reiniciar el servidor. Por eso es necesario exportar la información a un archivo.

## Conclusión

La actividad permitió comprobar que el nivel del perfilador volvió a cero después del reinicio, aunque los dos documentos registrados permanecieron en `system.profile`. También se exportaron la bitácora y los registros del perfilador, y se verificó su integridad mediante hashes SHA-256. Esto demuestra la importancia de conservar las evidencias antes de que puedan perderse.