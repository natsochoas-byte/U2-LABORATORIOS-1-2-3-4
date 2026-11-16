# Informe — LAB-02: Trazabilidad en MongoDB Community

## 1. Despliegue, edición y limitación

El servidor se desplegó en Ubuntu 24.04.4 LTS mediante Docker, utilizando MongoDB Community Server 7.0.43. Se creó el contenedor `mongo7-lab02`, se habilitó la autorización con `--auth` y se utilizó un volumen para conservar los datos.

Se verificó que MongoDB Community no cuenta con auditoría nativa. Para realizar las actividades se utilizaron el perfilador y la bitácora de `mongod`, reconociendo que estos mecanismos no sustituyen la auditoría nativa.

## 2. Perfilador

Al inicio, el perfilador estaba desactivado en la base `comercial`, por lo que la modificación realizada en la Actividad 2 no quedó registrada en `system.profile`.

En la Actividad 3 se activó el nivel 2 y se registraron una consulta, una modificación del RFC y una eliminación realizadas por `app_ventas`. Los registros mostraron el usuario, cliente, aplicación y momento de cada operación. La modificación del RFC a `GAMA780912XYZ` ocurrió el `2026-11-16T04:35:08.268Z`, desde la aplicación `app-ventas-web`.

En la Actividad 4 se configuró un filtro para registrar únicamente operaciones `insert`, `update` y `remove`. Como resultado, la consulta realizada no apareció en el perfilador, pero sí se registró la modificación.

El nivel 2 permite observar más operaciones, pero genera más registros y puede aumentar el uso de recursos. También puede almacenar datos personales incluidos en las consultas.

## 3. Bitácora de `mongod`

La bitácora se consultó mediante `getLog: "global"` y también se exportó desde los registros del contenedor Docker.

Se identificaron intentos de acceso fallidos con una contraseña incorrecta y con un usuario inexistente. También se encontró un acceso exitoso de `app_ventas`, utilizando la aplicación `app-ventas-web`.

En la Actividad 6 se identificaron cambios en la configuración del perfilador. Mediante el contexto `conn50` se relacionó uno de esos cambios con una sesión autenticada del usuario administrador `admin`.

La bitácora de `getLog` conserva únicamente los 1024 eventos más recientes en memoria y se pierde al reiniciar el servidor. Por eso, no representa un historial completo.

## 4. Privilegios

En la Actividad 7 se tomaron dos instantáneas de los privilegios. En la primera, `app_ventas` tenía el rol `readWrite`. En la segunda, realizada después del cambio, también tenía el rol `dbAdmin`.

La comparación permitió detectar que se agregó ese privilegio. Sin embargo, no se pudo identificar quién realizó el cambio ni su hora exacta mediante el perfilador o la bitácora.

Finalmente, se revocó el rol `dbAdmin` para regresar a los privilegios iniciales. Las instantáneas funcionaron como control compensatorio, pero no sustituyen la auditoría nativa.

## 5. Conservación

Se exportaron los registros de `system.profile` en `system-profile.json` y la bitácora del servidor en `bitacora-mongod.log`.

También se generó `hashes.sha256` para comprobar la integridad de ambos archivos. Al ejecutar `sha256sum -c`, las dos sumas coincidieron.

Se comprobó que la bitácora en memoria se pierde al reiniciar el servidor y que los registros disponibles deben exportarse para conservarlos.

## 6. Comparación

En la Actividad 9 se comparó PostgreSQL del LAB-01 con MongoDB Community del LAB-02.

Ambos permitieron obtener información sobre accesos y modificaciones de datos. Sin embargo, MongoDB Community presentó limitaciones para identificar quién realizó cambios de privilegios y para recuperar los valores anteriores de los datos.

El perfilador permitió conocer algunas operaciones, mientras que las instantáneas ayudaron a detectar diferencias en los privilegios. Aun así, ninguno de estos mecanismos proporcionó un historial completo de auditoría.

## 7. Recomendación

Para una organización que necesite auditar cambios de privilegios en MongoDB, recomendaría utilizar MongoDB Enterprise y configurar su auditoría nativa para registrar las operaciones administrativas y la identidad de los usuarios.

En este laboratorio se comprobó que MongoDB Community no permitió identificar quién agregó el rol `dbAdmin` a `app_ventas`. Las instantáneas únicamente mostraron la diferencia entre los privilegios anteriores y posteriores.

Si la organización continúa utilizando Community, recomendaría mantener los privilegios mínimos necesarios, revisar periódicamente los roles y conservar las evidencias. La limitación debe documentarse como un riesgo aceptado o por resolver.

## 8. Preguntas de reflexión

**1. ¿Por qué el perfilador no debe presentarse como un mecanismo de auditoría de seguridad?**

Porque su propósito principal es registrar operaciones para revisar el comportamiento y rendimiento de la base de datos. No garantiza un historial completo ni permite identificar siempre a la persona responsable.

**2. ¿Por qué el perfilador sí aporta trazabilidad aunque no sea auditoría?**

Porque permite conocer qué operación se realizó, qué usuario la ejecutó, desde qué cliente o aplicación y en qué momento.

**3. ¿Qué riesgo introduce el nivel 2 al registrar filtros de consultas que pueden contener datos personales?**

Puede almacenar información personal incluida en las consultas, lo que representa un riesgo si los registros no están protegidos. También aumenta el uso de recursos y almacenamiento.

**4. ¿Qué diferencia hay entre detectar un cambio y atribuirlo a alguien?**

Detectar un cambio significa comprobar que algo se modificó. Atribuirlo significa identificar quién realizó esa acción. En este laboratorio se detectó el cambio de privilegios, pero no se pudo identificar quién lo hizo.

**5. ¿Por qué reconocer una limitación técnica es parte del trabajo profesional del DBA?**

Porque debe conocer qué información puede demostrar el sistema y qué cosas no puede comprobar. Esto evita conclusiones incorrectas y permite recomendar controles adicionales.