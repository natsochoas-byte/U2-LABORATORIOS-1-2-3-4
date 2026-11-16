# EVIDENCIAS
# Actividad 6. Correlacionar un cambio de configuración con su autor

**Estudiante:** Natalia Ochoa León  

## Comando o procedimiento

Se consultó la bitácora para encontrar los eventos de cambio de configuración del perfilador. Después, se tomó la conexión del último cambio (`conn50`) y se buscó el evento de autenticación correspondiente.

## Resultado obtenido

Se encontraron tres cambios de configuración. El último activó el filtro para registrar las operaciones `insert`, `remove` y `update`.

El evento de autenticación de la conexión `conn50` mostró estos datos:

| Campo | Resultado |
|---|---|
| Conexión | `conn50` |
| Usuario | `admin` |
| Base de datos | `admin` |
| Cliente | `127.0.0.1:39662` |
| Fecha y hora | `2026-11-16 04:35:52.890 UTC` |

## Análisis

**1. ¿Qué usuario cambió la configuración del perfilador? ¿Qué dos eventos lo demuestran?**

El usuario `admin` realizó el cambio. Se demuestra con el evento `Profiler settings changed`, que muestra la conexión `conn50`, y el evento `Successfully authenticated`, que identifica a esa misma conexión con el usuario `admin`.

**2. ¿Qué condición debe cumplirse para que esta correlación sea válida?**

Los dos eventos deben pertenecer al mismo periodo de ejecución del servidor. Si MongoDB se reinicia, los números de conexión pueden volver a empezar y ya no sería seguro relacionarlos con registros anteriores.

**3. ¿Por qué es relevante que quede registrado un cambio de configuración del propio mecanismo de registro?**

Porque permite saber cuándo se modificó la forma de registrar las operaciones y quién realizó el cambio. Así se pueden detectar modificaciones que afecten la información disponible para investigar incidentes.

## Conclusión

La bitácora permitió identificar al usuario que cambió la configuración del perfilador relacionando dos eventos mediante la conexión `conn50`. Esto ayuda a conocer quién realizó cambios en el mecanismo de registro.