# Proyecto Django - Persistencia

## Descripción

Este proyecto está diseñado para **fines educativos**. Su objetivo es servir como una base robusta y bien estructurada para aprender a desarrollar aplicaciones web con Django, poniendo especial énfasis en la persistencia de datos con una base de datos real (MySQL) y el uso de Docker para crear un entorno de desarrollo consistente.

La estructura del proyecto sigue las mejores prácticas de la comunidad de Django, incorporando herramientas modernas como `Docker`, `Ruff` y `Makefile` para crear un entorno de desarrollo profesional y fácil de usar.

## Características

-   Framework: Django 4.2.27
-   Base de datos: MySQL 8.0
-   Entorno de desarrollo: Contenerizado con Docker y Docker Compose
-   Calidad de código: Linter `Ruff` preconfigurado.
-   Automatización: `Makefile` con comandos para las operaciones más comunes.

---

## 1. Requisitos Previos

Antes de empezar, asegúrate de tener las siguientes herramientas instaladas.

### A. Docker Desktop

Docker es la plataforma que nos permitirá ejecutar el proyecto dentro de contenedores, garantizando un entorno consistente.

-   **Para Windows (10/11):**
    -   Descarga e instala Docker Desktop desde [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/).
    -   La instalación requiere permisos de administrador y que tengas WSL2 activado.
-   **Para macOS (Intel/Apple Silicon):**
    -   Descarga e instala Docker Desktop desde [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/).
    -   Sigue las instrucciones del instalador.

### B. GNU Make (Solo para Windows)

Usamos `make` para simplificar los comandos de Docker. `make` viene preinstalado en macOS y Linux. En Windows, puedes instalarlo fácilmente con el gestor de paquetes `winget`.

1.  Abre una terminal (PowerShell o Símbolo del sistema).
2.  Ejecuta el siguiente comando:
    ```bash
    winget install Gnu.Make
    ```
3.  Cierra y vuelve a abrir la terminal para que el comando `make` esté disponible.

---

## 2. Guía de Inicio Rápido

1.  **Clonar el repositorio:**
    ```bash
    git clone https://github.com/alvasenj-nt/django-persistencia.git
    cd django-persistencia
    ```

2.  **Arrancar los servicios:**
    Este único comando construirá las imágenes la primera vez y arrancará el servidor de Django y la base de datos.
    ```bash
    make up
    ```

3.  **Acceder a la aplicación:**
    -   Abre tu navegador en [http://localhost:8000](http://localhost:8000)
    -   Accede al panel de administración en [http://localhost:8000/admin](http://localhost:8000/admin) (las credenciales por defecto son `admin`/`admin`).

---

## 3. Comandos de Makefile Disponibles

-   `make build`: Construye o reconstruye las imágenes de Docker. Útil si cambias `requirements.txt` o `Dockerfile`.
-   `make up`: Arranca todos los servicios en segundo plano.
-   `make down`: Detiene y elimina los contenedores, redes y volúmenes (¡borra los datos de la BD!).
-   `make logs`: Muestra los logs de los servicios en tiempo real.
-   `make shell`: Abre una terminal (`bash`) dentro del contenedor del servidor.
-   `make lint`: Revisa la calidad del código con `Ruff` (se ejecuta localmente).
-   `make lint-fix`: Intenta corregir automáticamente los errores de `linting`.