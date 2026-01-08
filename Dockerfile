# Usamos una imagen ligera de Python 3.10
FROM python:3.10-slim

# Evita que Python genere archivos .pyc y fuerza que los logs salgan inmediatos
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Instalamos dependencias del sistema necesarias para compilar mysqlclient
RUN apt-get update && apt-get install -y \
    pkg-config \
    default-libmysqlclient-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copiamos los requerimientos e instalamos
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# El código no lo copiamos aquí, lo montaremos con docker-compose para poder editar en vivo