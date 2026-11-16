# EVIDENCIAS
# Actividad 9. Comparar los tres escenarios

**Estudiante:** Natalia Ochoa León  

## Comparación

| Evento auditable | PostgreSQL (bitácora + disparador) | MongoDB Community (perfilador + bitácora) | MongoDB Enterprise/Atlas (auditoría nativa) |
|---|---|---|---|
| Acceso exitoso | Sí | Sí | Documentado, no practicado |
| Acceso fallido | Sí | Sí | Documentado, no practicado |
| Cambio de privilegios | Sí | Parcial: las instantáneas permiten detectar cambios, pero no identifican quién los realizó. | Documentado, no practicado |
| Cambio de estructura | Sí | No | Documentado, no practicado |
| Modificación de datos | Sí | Sí: el perfilador registró modificaciones. | Documentado, no practicado |
| Valor anterior del dato | Sí: el disparador registró valores anteriores y nuevos. | No | Documentado, no practicado |
| Lectura de datos sensibles | No | Parcial: el nivel 2 registra consultas, pero el filtro aplicado posteriormente excluye las lecturas. | Documentado, no practicado |
| Cambio de configuración del registro | Sí | Parcial: se registró el cambio del perfilador y se identificó al usuario relacionando eventos mediante `ctx`. | Documentado, no practicado |

## Análisis

En PostgreSQL se obtuvo mayor información sobre las operaciones realizadas. La bitácora permitió identificar accesos, cambios de privilegios, modificaciones de estructura y cambios de configuración. Además, el disparador registró las modificaciones de datos con sus valores anteriores y nuevos.

En MongoDB Community también se pudieron identificar accesos exitosos y fallidos, así como modificaciones realizadas en los documentos. Sin embargo, no se obtuvo el valor anterior de los datos ni evidencia directa de los cambios de privilegios. Las instantáneas ayudaron a detectar diferencias, pero no permitieron identificar quién realizó el cambio.

MongoDB Enterprise y Atlas cuentan con auditoría nativa documentada, pero no se realizaron pruebas con esas ediciones durante este laboratorio.

## Conclusión

La comparación permitió identificar que PostgreSQL, mediante la bitácora y los disparadores configurados, proporcionó más información para investigar las operaciones realizadas. MongoDB Community permitió registrar varios eventos, pero tiene limitaciones importantes, especialmente en los cambios de privilegios y la conservación de evidencias. Por eso, es importante considerar estas diferencias al elegir y configurar un sistema de auditoría.