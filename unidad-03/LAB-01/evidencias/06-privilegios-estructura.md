# EVIDENCIA
## Evidencia 06 — Cambios de privilegios y de estructura

**Estudiante:** Natalia Ochoa León  

## Comando ejecutado

```sql
REVOKE UPDATE ON clientes FROM soporte;

GRANT UPDATE ON clientes TO app_ventas;

ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20);

CREATE ROLE rol_temporal LOGIN PASSWORD 'Temporal_Practica_2026';

DROP ROLE rol_temporal;

SELECT linea
FROM dba.bitacora
WHERE linea LIKE '%statement:%'
ORDER BY num;
```

## Resultado obtenido

Las sentencias se ejecutaron correctamente y aparecieron registradas en la bitácora:

- `REVOKE UPDATE ON clientes FROM soporte`
- `GRANT UPDATE ON clientes TO app_ventas`
- `ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20)`
- `CREATE ROLE rol_temporal LOGIN PASSWORD 'Temporal_Practica_2026'`
- `DROP ROLE rol_temporal`

También se observó que la contraseña del rol temporal quedó registrada en texto claro en la bitácora, aunque después se eliminó el rol.

## Interpretación

**1. ¿Qué tipo de evento es cada una de las tres primeras sentencias (privilegio o estructura)?**

- `REVOKE`: cambio de privilegios, porque retira el permiso de actualización.
- `GRANT`: cambio de privilegios, porque concede el permiso de actualización.
- `ALTER TABLE`: cambio de estructura, porque agrega una columna a la tabla clientes.

**2. ¿Por qué GRANT y REVOKE quedan registrados con log_statement = 'ddl'?**

Porque son sentencias que modifican los permisos de los usuarios sobre los objetos de la base de datos. Por eso PostgreSQL las registra como parte de los cambios administrativos.

**3. Si la bitácora contiene contraseñas, ¿quién debería poder leerla? Relaciónalo con la gestión de secretos de la Unidad II.**

Solamente el administrador y el personal autorizado deberían poder leer la bitácora, ya que puede contener información confidencial como contraseñas. Esto se relaciona con la gestión de secretos de la Unidad II, donde se busca proteger las credenciales y evitar que personas no autorizadas puedan consultarlas.