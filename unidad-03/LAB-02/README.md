
# LAB-02 — Trazabilidad en MongoDB Community

**Estudiante:** Natalia Ochoa León  
**Versión:** MongoDB Community Server 7.0.43

## Despliegue del servidor(ANEXO A)

El laboratorio se realizó en Ubuntu 24.04.4 LTS utilizando Docker y la imagen oficial `mongo:7.0.43`.

Se creó el contenedor `mongo7-lab02`, se habilitó la autorización con `--auth` y se utilizó un volumen para conservar los datos.

Comando utilizado:

```bash
docker run -d \
  --name mongo7-lab02 \
  -p 127.0.0.1:27017:27017 \
  -v mongo7_lab02_data:/data/db \
  mongo:7.0.43 \
  --bind_ip_all --auth
```