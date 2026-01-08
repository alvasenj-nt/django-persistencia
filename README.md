# Proyecto Django - Persistencia

## Descripción

Este proyecto está diseñado para **fines educativos** y demuestra el uso de Django como framework web con persistencia de datos.

## Características

- Framework: Django 4.2.27
- Base de datos: MySQL
- Contenedorización con Docker

## Primer uso del proyecto

### Opción 1: Ejecución local

1. **Crear un entorno virtual:**
   ```bash
   python -m venv venv
   ```

2. **Activar el entorno virtual:**
   ```bash
   source venv/bin/activate  # En Linux/Mac
   # o
   venv\Scripts\activate     # En Windows
   ```

3. **Instalar dependencias:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Ejecutar migraciones:**
   ```bash
   python manage.py migrate
   ```

5. **Iniciar el servidor de desarrollo:**
   ```bash
   python manage.py runserver
   ```

6. **Acceder a la aplicación:**
   - Abrir navegador en: http://127.0.0.1:8000

### Opción 2: Ejecución con Docker

1. **Construir y ejecutar los contenedores:**
   ```bash
   docker-compose up --build
   ```

2. **Acceder a la aplicación:**
   - Abrir navegador en: http://localhost:8000

## Estructura del proyecto

```
├── django_persistencia/            # Configuración principal de Django
├── app/                # Aplicación de ejemplo
├── init_db/            # Scripts de inicialización de base de datos
├── manage.py           # Comando principal de Django
├── requirements.txt    # Dependencias del proyecto
├── Dockerfile          # Configuración de contenedor
└── docker-compose.yml  # Orquestación de servicios
```

## Notas importantes

- Este proyecto es únicamente para aprendizaje y experimentación
- Crear tu propio entorno virtual asegura un entorno de desarrollo limpio y aislado