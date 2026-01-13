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
    docker-compose up --build
    ```

2.  **Acceder a la aplicación:**
    - Abrir el navegador en: http://localhost:8000
    - El servidor se recargará automáticamente cada vez que se modifique un archivo del código.

3.  **Para detener los servicios:**
    - Presionar `Ctrl + C` en la terminal donde se ejecutó el `docker-compose`.
    - Para eliminar los contenedores y el volumen de la base de datos: `docker-compose down -v`

### Opción 2: Ejecución Local (Avanzado)

Este método requiere tener Python y MySQL instalados y configurados en la máquina local.

1.  **Crear y activar un entorno virtual:**
    ```bash
    python -m venv venv
    source venv/bin/activate  # En Linux/Mac
    # venv\Scripts\activate   # En Windows
    ```

2.  **Instalar dependencias:**
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

## Glosario de Archivos y Directorios

Aquí tienes una explicación de los componentes clave de este proyecto, como si fuera una clase.

### El Directorio Raíz

| Archivo / Directorio       | Explicación                                                                                                                                                                                                                                                                             |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`manage.py`**            | **El "Control Remoto" de tu proyecto.** Es un script que te permite interactuar con tu proyecto Django desde la línea de comandos. Lo usarás para casi todo: arrancar el servidor (`runserver`), crear migraciones (`makemigrations`), aplicarlas (`migrate`), crear nuevas apps (`startapp`), etc. |
| **`requirements.txt`**     | **La "Lista de Ingredientes".** Aquí se especifican todas las librerías de Python que el proyecto necesita para funcionar (como Django, `mysqlclient`, etc.). `pip install -r requirements.txt` lee este archivo e instala todo lo necesario.                                          |
| **`Dockerfile`**           | **Las "Instrucciones de Montaje" para nuestro servidor.** Define una receta paso a paso para crear una imagen de contenedor. Instala Python, las dependencias del sistema y las librerías de Python. Es como automatizar la preparación de un ordenador desde cero.                   |
| **`docker-compose.yml`**   | **El "Orquestador" de nuestros servicios.** Este archivo define y conecta los diferentes contenedores que necesita nuestra aplicación para funcionar. En nuestro caso, define dos servicios: `servidor` (nuestra app de Django) y `db` (la base de datos MySQL), y cómo se comunican entre ellos. |
| **`init_db/`**             | Un directorio para scripts SQL que se ejecutan al crear la base de datos por primera vez. Útil para precargar datos iniciales.                                                                                                                                                          |
| **`.gitignore`**           | **La "Lista de Cosas que Ignorar".** Le dice a Git qué archivos o directorios no debe incluir en el control de versiones (como entornos virtuales, archivos `.pyc`, la base de datos local, etc.).                                                                                          |

### El Directorio de Configuración (`django_persistencia/`)

Este directorio contiene los ajustes globales del proyecto. Su nombre coincide con el del proyecto para mayor claridad.

| Archivo         | Explicación                                                                                                                                                                                                                       |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`settings.py`** | **El "Panel de Control" del proyecto.** Es el archivo más importante aquí. Define toda la configuración: la base de datos a usar, las apps instaladas (`INSTALLED_APPS`), la gestión de archivos estáticos, las zonas horarias y un largo etcétera. |
| **`urls.py`**     | **El "Mapa de Rutas" principal.** Cuando un usuario visita una URL, Django consulta este archivo para ver qué vista de Python debe gestionar esa petición. Es el primer punto de entrada para el enrutamiento de URLs.           |
| **`wsgi.py`**     | **El "Enlace" con los servidores web tradicionales.** Proporciona un estándar para que los servidores web (como Apache o Nginx) puedan ejecutar tu aplicación Django.                                                         |
| **`asgi.py`**     | Similar a `wsgi.py`, pero para servidores web **asíncronos**. Permite funcionalidades más avanzadas como WebSockets.                                                                                                             |

### El Directorio de la Aplicación (`app/`)

| Archivo / Directorio | Explicación                                                                                                                                                                                                                                                                 |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`models.py`**      | **Los "Planos" de tus datos.** Aquí se definen las tablas de la base de datos como si fueran clases de Python. Cada clase representa una tabla y cada atributo de la clase, una columna. Django se encarga de traducir esto a SQL. Es el corazón de la persistencia de datos. |
| **`views.py`**       | **La "Lógica" detrás de cada petición.** Cuando una URL se asigna a una vista, la función o clase correspondiente en este archivo se ejecuta. Su trabajo es recibir la petición, interactuar con los modelos (si es necesario) y devolver una respuesta (normalmente, renderizando una plantilla HTML). |
| **`admin.py`**       | **Configuración del "Panel de Administrador".** Django viene con un panel de administración listo para usar. En este archivo, registras tus modelos para que se puedan gestionar (crear, editar, borrar) fácilmente desde una interfaz web. |
| **`tests.py`**       | **El "Control de Calidad".** Aquí se escriben las pruebas unitarias y de integración para asegurar que tu código funciona como se espera y que no se rompe nada al hacer cambios.                                                                                        |
| **`migrations/`**    | **El "Historial de Cambios" de tu base de datos.** Cada vez que modificas `models.py` y ejecutas `makemigrations`, Django crea un archivo aquí que describe los cambios. `migrate` aplica esos cambios a la base de datos. ¡Nunca edites estos archivos manualmente! |

---

## Notas Importantes

- Este proyecto es únicamente para aprendizaje y experimentación.
- La separación entre `django_persistencia/` (configuración) y `app/` (lógica) es una práctica fundamental que este proyecto busca enseñar.
- El uso de Docker simplifica enormemente el desarrollo y asegura que todos los alumnos trabajen en un entorno idéntico.