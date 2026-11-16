# EVIDENCIAS
# Actividad 7. Cambios de privilegios: el límite más importante

**Estudiante:** Natalia Ochoa León  

## Comando o procedimiento

Se tomó una primera instantánea de los privilegios actuales. Después se activó el nivel 2 del perfilador y se otorgó temporalmente el rol `dbAdmin` al usuario `app_ventas`.

Se consultó el perfilador y la bitácora de MongoDB para buscar evidencia del cambio. Posteriormente, se tomó una segunda instantánea y se compararon los privilegios registrados.

Finalmente, se revocó el rol adicional y se restableció el filtro del perfilador.

## Resultado obtenido

Las consultas para buscar el cambio de privilegios devolvieron `0` en ambas fuentes:

- Perfilador: `0`.
- Bitácora de mongod: `0`.

La comparación de las instantáneas mostró lo siguiente:

| Dato | Primera instantánea | Segunda instantánea |
|---|---|---|
| Usuario | `app_ventas` | `app_ventas` |
| Rol | `readWrite` | `readWrite`, `dbAdmin` |
| Tomada por | `admin` | `admin` |
| Fecha | 2026-11-16 04:44:18 UTC | 2026-11-16 04:50:03 UTC |

Después se ejecutó la revocación del rol `dbAdmin` y se restableció el filtro del perfilador. Ambos comandos devolvieron `ok: 1`.

## Análisis

**1. ¿Por qué un cambio de privilegios es uno de los eventos auditables más importantes?**

Porque puede permitir que un usuario obtenga permisos adicionales y realice acciones que antes no podía. Esto puede poner en riesgo la información y la seguridad de la base de datos.

**2. ¿Con qué frecuencia tomarías instantáneas? ¿Qué factores influyen?**

Las tomaría diariamente y también después de cada cambio importante de usuarios o roles. La frecuencia dependería del nivel de riesgo, la cantidad de usuarios y la importancia de la información.

**3. ¿Quién debería poder escribir en `auditoria.instantaneas_privilegios`?**

Solamente el personal responsable de administrar y supervisar la seguridad, con permisos limitados. Los usuarios de las aplicaciones no deberían poder modificar estas evidencias.

**4. Redacta en tres líneas cómo comunicarías esta limitación a Dirección.**

MongoDB Community no registra directamente los cambios de privilegios en las fuentes revisadas.  
Las instantáneas permiten comparar los roles y detectar diferencias, pero no identifican quién realizó el cambio ni la hora exacta.  
Por eso, este control es una medida compensatoria y representa una limitación que debe considerarse en la gestión de riesgos.

## Conclusión

Las instantáneas permitieron identificar que el usuario `app_ventas` recibió temporalmente el rol `dbAdmin`. Sin embargo, no fue posible determinar quién realizó el cambio ni el momento exacto mediante las fuentes consultadas. Por eso, las instantáneas funcionan como un control compensatorio, pero no sustituyen una auditoría nativa.