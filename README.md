# Proyecto Django - Persistencia

## Descripción

Este proyecto está diseñado para **fines educativos**. Su objetivo es servir como una base robusta y bien estructurada para aprender a desarrollar aplicaciones web con Django, poniendo especial énfasis en la persistencia de datos con una base de datos real (MySQL) y el uso de Docker para crear un entorno de desarrollo consistente.

La estructura del proyecto sigue las mejores prácticas de la comunidad de Django, incorporando herramientas modernas como `Docker`, `Ruff` y `Makefile` para crear un entorno de desarrollo profesional y fácil de usar.

## Características

- Framework: Django 4.2.27
- Base de datos: MySQL 8.0
- Entorno de desarrollo: Contenerizado con Docker y Docker Compose
- Calidad de código: Linter `Ruff` preconfigurado.
- Automatización: `Makefile` con comandos para las operaciones más comunes.

---

## Guía de Inicio Rápido

Este proyecto está diseñado para funcionar con Docker. Asegúrate de tenerlo instalado.

1.  **Clonar el repositorio:**
    ```bash
    git clone https://github.com/dvarrui/django-persistencia.git
    cd django-persistencia
    ```

2.  **Arrancar los servicios:**
    Este único comando construirá las imágenes, descargará las dependencias y arrancará el servidor de Django y la base de datos.
    ```bash
    make up
    ```

3.  **Acceder a la aplicación:**
    - Abre tu navegador en [http://localhost:8000](http://localhost:8000)
    - Accede al panel de administración en [http://localhost:8000/admin](http://localhost:8000/admin) (las credenciales por defecto son `admin`/`admin`).

> **Nota:** Para una guía detallada sobre la instalación, los conceptos de Django y Docker, y la configuración avanzada de este proyecto, consulta el fichero [clase_1_iniciacion.md](clase_1_iniciacion.md).

---

## Comandos de Makefile Disponibles

El `Makefile` incluido simplifica la gestión del ciclo de vida del proyecto.

-   `make build`: Construye o reconstruye las imágenes de Docker.
-   `make up`: Arranca todos los servicios en segundo plano.
-   `make down`: Detiene y elimina los contenedores, redes y volúmenes.
-   `make logs`: Muestra los logs de los servicios en tiempo real.
-   `make shell`: Abre una terminal (`bash`) dentro del contenedor del servidor.
-   `make lint`: Revisa la calidad del código con `Ruff` (se ejecuta localmente).
-   `make lint-fix`: Intenta corregir automáticamente los errores de `linting`.
