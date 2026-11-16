# EVIDENCIAS
# Actividad 10. Responder a Dirección

**Estudiante:** Natalia Ochoa León  

**1. ¿Quién cambió el RFC de María García en la Actividad 2? ¿Y en la Actividad 3?**

En la Actividad 2 no hay evidencia con esta edición, porque el perfilador estaba desactivado y la bitácora de `mongod` no registró directamente la modificación del RFC.

En la Actividad 3 se identificó al usuario `app_ventas`, mediante el registro del perfilador. Sin embargo, el registro no permite identificar a una persona específica, solamente al usuario de MongoDB que realizó la operación.

**2. ¿Cuándo y desde qué aplicación?**

En la Actividad 2 no hay evidencia con esta edición para determinar la fecha exacta ni la aplicación que realizó el cambio.

En la Actividad 3, la modificación quedó registrada el 16 de noviembre de 2026 a las 04:35:08 UTC, desde la aplicación `app-ventas-web`.

**3. ¿Qué valor tenía antes?**

No hay evidencia con esta edición para conocer el valor anterior del RFC. El perfilador registró el valor nuevo mediante la operación `$set`, pero no conservó el valor anterior del documento.

**4. ¿Cambió alguien los privilegios de `app_ventas`?**

Sí. Las dos instantáneas demostraron que se agregó temporalmente el rol `dbAdmin` al usuario `app_ventas`, además de su rol `readWrite`. Sin embargo, no hay evidencia con esta edición para identificar quién realizó el cambio ni la hora exacta, porque ni el perfilador ni la bitácora registraron directamente esta operación. Posteriormente, el rol adicional fue revocado.

## Conclusión

MongoDB Community permitió identificar algunas operaciones y el usuario de base de datos que realizó una modificación. Sin embargo, no proporcionó toda la información necesaria para responder las preguntas de Dirección, especialmente el valor anterior del RFC y la identidad de quien cambió los privilegios. Estas limitaciones deben considerarse al investigar incidentes.