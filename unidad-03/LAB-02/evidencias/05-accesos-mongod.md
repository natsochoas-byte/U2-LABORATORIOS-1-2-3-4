# EVIDENCIAS
# Actividad 5. Accesos en la bitácora de mongod

**Estudiante:** Natalia Ochoa León  
## Comando o procedimiento

Se realizaron dos intentos de acceso fallidos: uno utilizando el usuario `app_ventas` con una contraseña incorrecta y otro utilizando el usuario `usuario_inexistente`.

Después, desde la sesión del DBA, se consultó la bitácora para identificar los accesos fallidos y el último acceso exitoso de la aplicación.

## Resultado obtenido

Se encontraron los siguientes intentos fallidos:

| Usuario | Error | Resultado | Aplicación |
|---|---|---|---|
| `app_ventas` | Contraseña incorrecta | 18 | `mongosh 2.12.0` |
| `usuario_inexistente` | Usuario no encontrado | 11 | `mongosh 2.12.0` |

El segundo intento apareció dos veces en la bitácora, pero corresponde a un solo intento de acceso.

También se encontró el último acceso exitoso:

| Usuario | Conexión | Cliente | Resultado | Aplicación |
|---|---|---|---|---|
| `app_ventas` | `conn56` | `127.0.0.1:58682` | 0 | `app-ventas-web` |

## Análisis

**1. ¿Qué campo distingue un acceso fallido de uno exitoso?**

El campo `msg`, porque muestra si la autenticación fue exitosa (`Successfully authenticated`) o fallida (`Failed to authenticate`). El campo `result` también permite distinguirlos: 0 indica éxito y los valores 18 y 11 indican errores.

**2. ¿Qué diferencia hay entre el error de contraseña incorrecta y el de usuario inexistente? ¿Por qué el cliente recibe el mismo mensaje en ambos casos?**

En el primer caso, el usuario existe, pero la contraseña es incorrecta. En el segundo, el usuario no existe en la base de datos. MongoDB muestra el mismo mensaje al cliente para no revelar información sobre qué usuarios están registrados.

**3. ¿Por qué el nombre de la aplicación del intento fallido es `mongosh 2.12.0` y no `app-ventas-web`?**

Porque los intentos fallidos se realizaron directamente desde la terminal utilizando `mongosh`, sin indicar el nombre de la aplicación `app-ventas-web`.

## Conclusión

La bitácora de `mongod` permitió identificar los intentos de acceso fallidos y exitosos, así como los usuarios, las direcciones de conexión y los errores. Esta información ayuda a revisar problemas de autenticación y detectar accesos incorrectos.