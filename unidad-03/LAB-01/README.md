# Despliegue del servidor(ANEXO A)

El servidor PostgreSQL se instaló directamente en Ubuntu 24.04 LTS, sin utilizar Docker. Se administró mediante pgAdmin 4 y la terminal del sistema.

Para verificar el estado del servicio se utilizó:

```bash
sudo systemctl status postgresql
```

Para consultar la versión instalada:

```bash
psql --version
```

**Versión utilizada:** PostgreSQL 16.15.
