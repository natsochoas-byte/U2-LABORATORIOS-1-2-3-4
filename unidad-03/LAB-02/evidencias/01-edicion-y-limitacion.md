# EVIDENCIAS
# Actividad 1. Lo que no existe en esta edición

**Estudiante:** Natalia Ochoa León  
**Actividad:** 01 - Edición y limitación

## Comando o procedimiento

Se ejecutaron los siguientes comandos en MongoDB:

```javascript
db.version()
db.adminCommand({ buildInfo: 1 }).modules
db.serverCmdLineOpts().parsed
```

También se consultó la bitácora desde la terminal:

```bash
docker logs --tail 10 mongo7-lab02
```

## Resultado obtenido

La versión instalada fue:

```text
7.0.43
```

El resultado de los módulos fue:

```javascript
[]
```

La configuración mostró que la autorización está activada:

```javascript
{
  net: { bindIp: '*' },
  security: { authorization: 'enabled' }
}
```

Al consultar los registros del contenedor aparecieron eventos de conexión y autenticación.

## Análisis

**1. ¿Qué edición MongoDB usas? ¿Qué evidencia lo demuestra?**

Utilizo MongoDB Community 7.0.43. Esto se demuestra porque el comando de los módulos devolvió un arreglo vacío (`[]`), lo que indica que no cuenta con el módulo Enterprise.

**2. ¿A dónde escribe el servidor su bitácora? ¿Cómo lo sabes?**

La bitácora se muestra en la salida del contenedor Docker. Lo comprobé utilizando el comando `docker logs`, donde aparecieron los registros de conexión y autenticación.

**3. Según REF-U3-04, ¿qué cuatro categorías de eventos registraría auditoría nativa?**

Las cuatro categorías son autenticación y autorización, operaciones sobre los datos, cambios en la estructura de la base de datos y cambios administrativos o de configuración del servidor.

**4. ¿Qué tendría que evaluar una organización antes de licenciar Enterprise o migrar a Atlas solo para obtener auditoría?**

Tendría que revisar cuánto cuesta, qué tanta auditoría necesita, qué información debe registrar y si realmente le conviene pagar por una edición o servicio más avanzado. También tendría que considerar los cambios que implicaría migrar sus bases de datos.

## Conclusión

MongoDB Community permite consultar los registros del servidor y revisar algunas operaciones mediante el perfilador, pero no incluye la auditoría nativa. Por eso, es importante conocer las necesidades de la organización antes de decidir si conviene utilizar una versión de pago.