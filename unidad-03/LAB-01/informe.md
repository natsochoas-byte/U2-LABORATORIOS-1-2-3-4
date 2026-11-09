# INFORME

## 1. Despliegue y situación inicial

Para realizar el laboratorio utilicé PostgreSQL 16.15 instalado directamente en Ubuntu 24.04. El servidor se administró desde pgAdmin 4 y la terminal, trabajando con la base de datos `natalia_ochoa`.

Al inicio, la configuración de registro no era suficiente para investigar todos los eventos que ocurrían en la base de datos. Se podían consultar algunas operaciones, pero no se tenía un registro completo de los accesos, errores, cambios de estructura y modificaciones realizadas por los usuarios.

Esto representaba un problema porque, si ocurría un incidente con información sensible, no siempre era posible identificar quién había realizado el cambio, desde dónde se conectó o cuál era el valor anterior del dato. Por eso fue necesario configurar la bitácora y crear un mecanismo adicional de auditoría.

## 2. Configuración aplicada

Se modificaron los parámetros de PostgreSQL para registrar las conexiones, desconexiones y sentencias que modifican información o la estructura de la base de datos.

Los principales parámetros utilizados fueron:

| Parámetro | Valor configurado | Función |
|---|---|---|
| `logging_collector` | `on` | Permite que PostgreSQL recopile los mensajes de registro en archivos. |
| `log_connections` | `on` | Registra los intentos de conexión. |
| `log_disconnections` | `on` | Registra cuando una sesión se desconecta. |
| `log_statement` | `mod` | Registra sentencias que modifican datos o estructuras. |
| `log_line_prefix` | `%m [%p] user=%u db=%d app=%a client=%h ` | Agrega información para identificar cada evento. |

El colector de registros requirió reiniciar el servidor para aplicar el cambio. Los demás parámetros pudieron aplicarse mediante una recarga de la configuración.

El prefijo de cada línea permite identificar la fecha y hora, el proceso, el usuario, la base de datos, la aplicación y la dirección del cliente. Esto facilita relacionar los eventos con las sesiones que los generaron.

Se eligió `log_statement = mod` porque permite registrar operaciones como `INSERT`, `UPDATE`, `DELETE` y cambios de estructura, sin registrar todas las consultas de lectura.

## 3. Eventos observados

Durante las actividades se observaron diferentes eventos en la bitácora:

- **Accesos fallidos:** se realizaron intentos de conexión con una contraseña incorrecta y con un usuario inexistente. Estos intentos quedaron registrados como fallidos, lo que permite identificar posibles problemas o intentos de acceso no autorizado.

- **Acceso exitoso y desconexión:** se comprobó que PostgreSQL registra tanto el establecimiento de una conexión como la desconexión de la sesión. Esto permite conocer cuándo un usuario inició y terminó su acceso.

- **Cambios de privilegios:** se ejecutaron instrucciones `GRANT` y `REVOKE` para otorgar y retirar permisos. Estos cambios son importantes porque modifican las acciones que puede realizar cada usuario.

- **Cambios en la estructura:** se utilizó `ALTER TABLE` para agregar una columna a la tabla `clientes`. La sentencia quedó registrada en la bitácora.

- **Modificación de datos:** se realizaron operaciones `UPDATE`. El registro permite identificar al usuario, la aplicación y la dirección IP desde donde se ejecutó la operación.

- **Errores de permisos:** cuando un usuario intentó realizar una operación para la que no tenía autorización, PostgreSQL registró el error y la sentencia relacionada.

- **Cambios de configuración:** también se observaron mensajes que indican cuando un parámetro de configuración cambia de valor.

Con estos ejemplos comprobé que la bitácora permite conocer diferentes actividades del servidor, incluyendo operaciones exitosas y rechazadas.

## 4. Auditoría del dato

Además de la bitácora, se creó el esquema `auditoria` y la tabla `auditoria.cambios_clientes`, diseñada para conservar información de los cambios realizados en la tabla `clientes`.

La tabla contiene los siguientes campos:

| Campo | Función |
|---|---|
| `id_evento` | Identificador único de cada evento. |
| `momento` | Fecha y hora en que ocurrió el cambio. |
| `usuario_sesion` | Usuario con el que se inició la conexión. |
| `usuario_efectivo` | Usuario cuyos permisos se utilizan al ejecutar la operación. |
| `aplicacion` | Aplicación desde la que se realizó la operación. |
| `ip_cliente` | Dirección IP del cliente conectado. |
| `operacion` | Tipo de operación: INSERT, UPDATE o DELETE. |
| `id_cliente` | Identificador del cliente modificado. |
| `valores_antes` | Información del registro antes del cambio. |
| `valores_despues` | Información del registro después del cambio. |

Se configuró un disparador para que las operaciones de inserción, actualización y eliminación generaran automáticamente un registro de auditoría.

La función utiliza `SECURITY DEFINER`, lo que permite que se ejecute con los permisos de su propietario. Esto fue importante porque el usuario `app_ventas` podía modificar registros de `clientes`, pero no tenía permiso para consultar directamente el esquema de auditoría.

También se utilizaron `session_user` y `current_user`. El primero permite identificar al usuario que inició la sesión, mientras que el segundo identifica al usuario efectivo durante la ejecución. En el incidente auditado, esta diferencia permitió observar que `app_ventas` realizó la operación, mientras que la función se ejecutó con los permisos de `postgres`.

Durante el incidente, `app_ventas` modificó el RFC del cliente con ID 3. El registro de auditoría mostró que el valor anterior era `GAMA780912XYZ` y el nuevo valor era `GAMA780912ZZZ`. También se identificaron el usuario de sesión, el usuario efectivo, la aplicación y la dirección IP.

Esto permitió relacionar el cambio con la sesión que lo realizó y conocer exactamente qué valor tenía el RFC antes de ser modificado.

## 5. Limitaciones

Durante las pruebas también se identificaron algunas limitaciones de la auditoría.

La primera es que las consultas de lectura no quedan registradas en la tabla de auditoría, porque el disparador solamente está configurado para operaciones `INSERT`, `UPDATE` y `DELETE`. Por ejemplo, cuando `soporte_ana` consultó el nombre, RFC y teléfono de un cliente, no se generó un evento en la tabla.

Otra limitación es el volumen de información. Una actualización que modifica muchos registros puede generar una gran cantidad de eventos. En la práctica, una actualización masiva produjo cinco registros nuevos de auditoría, uno por cada cliente modificado.

También se comprobó que el administrador tiene control sobre la configuración y los mecanismos de auditoría. Puede desactivar el disparador, modificar datos y volver a activarlo. Cuando esto ocurrió, el cambio realizado mientras el disparador estaba desactivado no quedó registrado en la tabla de auditoría.

Por lo tanto, la auditoría ayuda a detectar y reconstruir cambios, pero no garantiza por sí sola que todas las operaciones queden registradas.

## 6. Riesgos de la bitácora

La bitácora puede contener información sensible. Si se configura para registrar todas las sentencias, también podría guardar datos como RFC, teléfonos, correos o información de acceso que aparezca en las consultas. Por eso es importante seleccionar correctamente qué operaciones se registran y proteger los archivos.

Otro riesgo es la pérdida de información. Si los archivos permanecen únicamente en el servidor y este se daña, se reinstala o se eliminan los registros, la evidencia podría desaparecer.

Para reducir este riesgo se exportó la bitácora a `evidencias/bitacora-lab01.log` y se generó un archivo SHA-256 para verificar si su contenido cambia. Sin embargo, el hash no impide que alguien modifique el archivo; solamente permite comprobar si el contenido ya no coincide con el valor calculado.

También existe el riesgo de que terceros accedan a los archivos. Por eso deben protegerse los permisos, limitarse el acceso y conservarse las evidencias en un lugar seguro. La información debe mantenerse durante el periodo establecido por las políticas de la organización.

## 7. Cronología y conclusión

Durante el laboratorio se observaron eventos que permitieron reconstruir parte de la actividad del servidor. Primero se identificaron intentos de conexión fallidos, después cambios en los privilegios y en la estructura de la base de datos. Posteriormente se creó el mecanismo de auditoría y se realizaron pruebas de inserción, eliminación y actualización de registros.

También se comprobó que un usuario de aplicación podía modificar información sin tener acceso directo a la tabla de auditoría, gracias al uso de `SECURITY DEFINER`. En el incidente del RFC del cliente con ID 3, el registro permitió identificar al usuario de sesión `app_ventas`, el usuario efectivo `postgres`, la aplicación utilizada, la IP y los valores anterior y posterior.

Sin embargo, también se comprobó que un administrador puede desactivar el disparador y realizar cambios que no quedan registrados en la tabla de auditoría. Además, las lecturas no se registran con el mecanismo implementado.

**¿Con esta configuración puede demostrarse quién cambió un dato sensible y qué valor tenía antes?**

Sí, cuando el cambio queda registrado por el disparador, es posible identificar al usuario de sesión, la fecha, la aplicación, la IP y los valores anteriores y posteriores del dato. Sin embargo, no se puede garantizar que todos los cambios queden registrados, especialmente si un administrador desactiva el disparador o modifica los mecanismos de registro.

Por lo tanto, considero que la configuración implementada mejora considerablemente la capacidad de investigar incidentes, pero debe complementarse con controles de acceso, protección de los archivos de bitácora y una separación de responsabilidades para evitar que una sola persona pueda modificar tanto los datos como las evidencias.

## 8. Preguntas de reflexión

**1. ¿Por qué la auditoría no puede configurarse después de un incidente para investigarlo?**

Porque la auditoría registra los cambios desde el momento en que está configurada. Si se activa después de un incidente, no puede recuperar automáticamente los valores anteriores ni identificar quién realizó las operaciones que ocurrieron antes.

**2. ¿Por qué conviene que la bitácora la administre el propio servidor y no el mecanismo de despliegue?**

Porque PostgreSQL es quien conoce las conexiones, las operaciones y los errores que ocurren dentro del servidor. Si el registro depende solamente del mecanismo de despliegue, podrían perderse eventos que suceden directamente en la base de datos.

**3. ¿Por qué el prefijo de línea es tan importante como el nivel de `log_statement`?**

Porque `log_statement` determina qué sentencias se registran, pero el prefijo permite saber quién las ejecutó, cuándo, desde qué aplicación y desde qué dirección IP. Sin esa información, sería más difícil relacionar una sentencia con una sesión específica.

**4. ¿Qué diferencia práctica hay entre registrar la sentencia y registrar el cambio en el dato?**

Registrar la sentencia permite conocer qué instrucción se ejecutó, por ejemplo, un `UPDATE`. En cambio, registrar el cambio en el dato permite conocer qué registro fue modificado y comparar sus valores anteriores y posteriores. Ambos mecanismos se complementan.

**5. ¿Qué evidencia ofrece `pg_stat_activity` que no ofrece la bitácora, y viceversa?**

`pg_stat_activity` permite consultar las sesiones que están activas en ese momento, sus usuarios, aplicaciones y consultas en ejecución. La bitácora conserva eventos que ya ocurrieron, por lo que permite revisar conexiones, errores y sentencias después de que terminaron.

**6. Si el administrador puede cambiar `log_statement` a `none` y desactivar el disparador, ¿quién audita al administrador?**

El administrador debe ser supervisado mediante controles externos al mismo servidor, como una bitácora centralizada en otro sistema, controles de acceso y una persona responsable de revisar las evidencias. Así se evita que el mismo administrador tenga control total sobre los datos y los registros que deberían demostrar sus acciones.


## Actividad 16 — Exportar y conservar la bitácora

Se exportó la bitácora de PostgreSQL al archivo `evidencias/bitacora-lab01.log`, sustituyendo la contraseña de práctica por `<REDACTED>` para evitar que quedara expuesta. Después, se calculó su resumen criptográfico SHA-256 y se guardó en `evidencias/bitacora-lab01.sha256`.

### Preguntas

**1. Un resumen SHA-256, ¿impide que alguien modifique la bitácora? ¿Qué permite demostrar?**

No impide que alguien modifique la bitácora, pero permite comprobar si el archivo cambió. Si se calcula nuevamente el hash y el resultado es diferente, significa que el archivo fue modificado.

**2. ¿Dónde debería guardarse el hash para que sea útil como control de integridad?**

Debe guardarse separado de la bitácora, en un lugar seguro al que no tengan acceso las mismas personas que pueden modificar el archivo original.

**3. ¿Qué riesgos tiene conservar la bitácora solo en el servidor que la produce?**

Si el servidor falla, se reinstala o se eliminan sus archivos, la bitácora puede perderse. También existe el riesgo de que alguien con permisos de administrador la modifique o elimine. Por eso es importante conservar una copia externa.

**4. Propón durante cuánto tiempo conservarías esta bitácora y justifica tu criterio.**

La conservaría durante cinco años, porque puede servir como evidencia para investigar incidentes y revisar actividades anteriores. También tomaría en cuenta las políticas de seguridad y protección de datos de la organización.