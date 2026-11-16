# EVIDENCIAS
# Actividad 4. Reducir el volumen con un filtro

**Estudiante:** Natalia Ochoa León  

## Comando o procedimiento

Primero se apagó el perfilador y se eliminaron los registros anteriores de `system.profile`. Después se configuró un filtro para registrar únicamente las operaciones `insert`, `update` y `remove`.

Desde el usuario `app_ventas` se realizó una consulta y se actualizó el teléfono del cliente con ID 1. Finalmente, se revisaron los registros del perfilador.

## Resultado obtenido

La configuración mostró que el filtro quedó activo con las operaciones `insert`, `remove` y `update`.

Al consultar `system.profile`, solamente apareció esta operación:

| Operación | Colección | Usuario | Aplicación | Cambio |
|---|---|---|---|---|
| `update` | `comercial.clientes` | `app_ventas@comercial` | `app-ventas-web` | Se actualizó el teléfono del cliente con ID 1 a `6670000000`. |

La consulta realizada no apareció en los registros.

## Análisis

**1. ¿Qué perdiste de evidencia al aplicar el filtro? ¿Qué ganaste?**

Perdí el registro de las consultas que realiza la aplicación. A cambio, se guardan solamente las modificaciones, por lo que hay menos registros y es más fácil revisar los cambios realizados.

**2. ¿Qué filtro usarías si solo interesaran operaciones sobre la colección `clientes`?**

Usaría un filtro sobre el campo `ns` para registrar únicamente las operaciones de la colección `comercial.clientes`.

## Conclusión

El filtro permitió reducir la cantidad de registros y conservar solamente las modificaciones realizadas en la base de datos. Sin embargo, también dejó fuera las consultas, por lo que se pierde parte de la información que podría servir para investigar un incidente.