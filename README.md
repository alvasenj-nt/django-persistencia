# Proyecto Django - Persistencia

## Descripción

Este proyecto está diseñado para **fines educativos**. Su objetivo es servir como una base robusta y bien estructurada para aprender a desarrollar aplicaciones web con Django, poniendo especial énfasis en la persistencia de datos con una base de datos real (MySQL) y el uso de Docker para crear un entorno de desarrollo consistente.

La estructura del proyecto sigue las mejores prácticas de la comunidad de Django, separando claramente la configuración del proyecto de la lógica de las aplicaciones.

## Características

- Framework: Django 4.2.27
- Base de datos: MySQL 8.0
- Entorno de desarrollo: Contenedorizado con Docker y Docker Compose

---

## Guía de Instalación para el Entorno Local

### Docker Desktop en Windows (con WSL2)

Docker nos permite empaquetar la aplicación y sus dependencias en "contenedores". Esto garantiza que el entorno de desarrollo sea idéntico para todos los miembros del equipo, eliminando el clásico problema de "en mi máquina sí funciona".

Esta guía asume que ya tienes WSL2 (Subsistema de Windows para Linux) instalado y configurado en tu máquina.

1.  **Desinstalar Versiones Anteriores:**
    *   Ve a "Agregar o quitar programas" en la configuración de Windows.
    *   Busca "Docker Desktop" en la lista de aplicaciones y selecciónalo.
    *   Haz clic en "Desinstalar". **Necesitarás proporcionar una contraseña de administrador** para confirmar la acción.

2.  **Instalar Docker Desktop:**
    *   Descarga el instalador oficial desde la página de Docker: [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
    *   Ejecuta el archivo descargado. La instalación también **requerirá permisos de administrador**.
    *   Sigue las instrucciones del asistente de instalación, asegurándote de que la opción para usar WSL2 esté seleccionada.

### Instalación de Git y Clonación del Proyecto

Git es un sistema de control de versiones que nos permite guardar un historial de los cambios en nuestro código. Es una herramienta esencial para colaborar en equipo, gestionar diferentes versiones del proyecto y poder volver a un estado anterior si algo sale mal.

1.  **Instalar Git:**
    *   Descarga Git para Windows desde el sitio web oficial: [https://git-scm.com/downloads](https://git-scm.com/downloads)
    *   Ejecuta el instalador. Generalmente, puedes aceptar las opciones por defecto durante la instalación.

2.  **Clonar el Repositorio:**
    *   Abre una terminal (como Git Bash, que se instala con Git, o la Terminal de Windows).
    *   Navega al directorio donde quieras guardar el proyecto.
    *   Ejecuta el siguiente comando para clonar el repositorio:
        ```bash
        git clone https://github.com/dvarrui/django-persistencia.git
        ```

---

## ¿Qué es Django?

Django es un framework de desarrollo web de alto nivel, escrito en Python, que promueve un desarrollo rápido y un diseño limpio y pragmático. Su filosofía es "baterías incluidas", lo que significa que viene con casi todo lo que un desarrollador podría necesitar para construir una aplicación web completa, como un ORM (Mapeador Objeto-Relacional) para interactuar con la base de datos, un panel de administración automático, un sistema de autenticación de usuarios y mucho más. Su arquitectura principal se basa en el patrón MVT (Modelo-Vista-Plantilla).

---

## Creación del Proyecto (Desde Cero)

Para entender cómo se ha construido esta estructura, aquí están los comandos fundamentales que se ejecutaron.

1.  **Crear la estructura base del proyecto:**
    El primer paso es usar el comando `django-admin` para crear el esqueleto del proyecto.

    ```bash
    # Este comando crea el directorio 'django_persistencia' con los ficheros de configuración.
    django-admin startproject django_persistencia .
    ```
    *Nota: El `.` al final es importante. Le dice a Django que cree el proyecto en el directorio actual, evitando un nivel de anidamiento innecesario.*

2.  **Crear la aplicación principal de trabajo:**
    Un proyecto de Django se compone de una o más "apps". Las apps son módulos que encapsulan una funcionalidad específica.

    ```bash
    # Desde el directorio raíz, junto a manage.py
    python manage.py startapp app
    ```
    *Este comando crea el directorio `app/` con su propia estructura de archivos (`models.py`, `views.py`, etc.), que es donde los estudiantes desarrollarán la lógica de la aplicación.*

---

## Primer Uso del Proyecto

### Opción Recomendada: Ejecución con Docker

Este método es el más sencillo y fiable, ya que abstrae toda la configuración del entorno.

1.  **Construir y ejecutar los contenedores:**
    Este comando leerá el `docker-compose.yml`, construirá la imagen de Docker para el servidor de Django (si no existe) y arrancará los servicios de la aplicación y la base de datos.

    ```bash
    docker-compose up --build -d
    ```

2.  **Acceder a la aplicación:**
    - Abrir el navegador en: http://localhost:8000
    - El servidor se recargará automáticamente cada vez que se modifique un archivo del código.

3.  **Para detener los servicios:**
    - Presionar `Ctrl + C` en la terminal donde se ejecutó el `docker-compose`.
    - Para eliminar los contenedores y el volumen de la base de datos: `docker-compose down -v`

### Opción 2: Ejecución Local (Avanzado)

Este método requiere tener Python y MySQL instalados y configurados en la máquina local. Es útil para ejecutar herramientas como el linter localmente.

1.  **Crear y activar un entorno virtual:**
    ```bash
    python -m venv venv
    source venv/bin/activate  # En Linux/Mac
    # venv\Scripts\activate   # En Windows
    ```

2.  **Instalar dependencias:**
    Esto instalará Django y también `ruff`, la herramienta que usamos para el linting.
    ```bash
    pip install -r requirements.txt
    ```

3.  **Ejecutar las migraciones:**
    Este comando crea las tablas en la base de datos basándose en los modelos definidos.
    ```bash
    python manage.py migrate
    ```

4.  **Iniciar el servidor de desarrollo:**
    ```bash
    python manage.py runserver
    ```

---
### Entendiendo la Configuración Avanzada con Docker

El `docker-compose.yml` de este proyecto utiliza una configuración avanzada para automatizar el entorno de desarrollo. Aunque puede parecer complejo al principio, está diseñado para seguir las mejores prácticas y hacerte la vida más fácil.

Aquí te explicamos los componentes clave:

#### 1. Fichero de Entorno: `_env/devel.env`

En lugar de escribir "secrets" (como contraseñas o claves secretas) directamente en los ficheros de configuración, usamos un fichero de entorno.

-   **Ubicación:** `_env/devel.env`
-   **Propósito:** Centraliza toda la configuración que puede cambiar entre entornos (desarrollo, producción, etc.). Aquí defines el usuario y la contraseña de la base de datos, la `SECRET_KEY` de Django y las credenciales del superusuario que se crea al inicio.
-   **Ventaja:** Separa la configuración del código, una práctica de seguridad y organización fundamental en el desarrollo de software.

#### 2. El Script de Arranque: `docker-entrypoint.sh`

Este script es el "cerebro" que se ejecuta cada vez que se inicia el contenedor del servidor.

-   **Propósito:** Automatiza las tareas de inicialización necesarias para que la aplicación Django funcione correctamente.
-   **¿Qué hace?:**
    1.  **`--migrate`**: Ejecuta `python manage.py migrate` para asegurarse de que la base de datos tiene las tablas más recientes.
    2.  **`--create-superuser`**: Crea un superusuario en Django usando las variables de entorno `DJANGO_SUPERUSER_USERNAME` y `DJANGO_SUPERUSER_PASSWORD` definidas en `_env/devel.env`. Si el usuario ya existe, simplemente continúa.
    3.  **`--runserver`**: Inicia el servidor de desarrollo de Django, que es lo que finalmente te permite ver la aplicación en tu navegador.

#### 3. Orquestación: `docker-compose.yml`

Este fichero es el director de orquesta. Define los servicios (`servidor`, `db`) y cómo se conectan y configuran.

-   **`env_file`**: Le dice al servicio `servidor` que cargue toda su configuración desde `_env/devel.env`.
-   **`entrypoint` y `command`**: Le indica al `servidor` que use nuestro script `docker-entrypoint.sh` y le pasa los comandos a ejecutar (`--migrate`, `--create-superuser`, `--runserver`).
-   **`depends_on: condition: service_healthy`**: Es una regla crucial. Le dice al `servidor` que **no intente arrancar hasta que el servicio `db` (la base de datos) esté completamente listo**. Esto evita los típicos errores de "no se puede conectar a la base de datos" durante el arranque.

---
## Automatización con Makefile

Para simplificar aún más los comandos de Docker, este proyecto incluye un `Makefile`. La herramienta `make` permite definir "recetas" o "comandos" para automatizar tareas comunes.

Esto te permite ejecutar operaciones complejas con un comando muy simple desde tu terminal.

### Comandos Disponibles

-   `make build`: Construye o reconstruye las imágenes de Docker para los servicios. Útil después de cambiar `requirements.txt` o el `Dockerfile`.
-   `make up`: Arranca todos los servicios en segundo plano (`-d` de "detached"). Es el comando que usarás habitualmente para iniciar el entorno.
-   `make down`: Detiene y elimina los contenedores y redes. Añadimos la opción `-v` para borrar también los volúmenes de la base de datos (¡cuidado, esto borra los datos!).
-   `make logs`: Muestra los logs de todos los servicios en tiempo real. Esencial para ver qué está pasando o para depurar errores.
-   `make shell`: Abre una terminal (`bash`) dentro del contenedor del `servidor`. Esto es extremadamente útil para ejecutar comandos de Django manualmente, como `python manage.py shell`, `python manage.py dbshell`, etc.
-   `make lint`: Ejecuta el linter `ruff` para revisar la calidad del código y el cumplimiento de los estándares de estilo de Python. Se ejecuta localmente (no en Docker) y necesita que instales las dependencias con `pip install -r requirements.txt`.
-   `make lint-fix`: Igual que `make lint`, pero además intenta corregir automáticamente todos los errores que sea posible.

---