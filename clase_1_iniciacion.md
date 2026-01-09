# Clase 1: Introducción a Django y Docker

En esta clase vamos a sentar las bases para entender cómo construir aplicaciones web que guardan información. Para ello, no solo usaremos Django, un framework de Python, sino que también aprenderemos a empaquetar y ejecutar nuestra aplicación de manera profesional con Docker.

El objetivo es que al final de esta clase entendamos los conceptos clave, sin preocuparnos de entender los conceptos en profundidad. La idea
es que nos sirvan de base para entender nuestro objetivo: **La persistencia en base de datos.**

---

## Preparando el Entorno (Instalación en Windows)

Para poder seguir los ejercicios, necesitarás tener instalados Docker y Docker Compose. En Windows, la forma más sencilla y recomendada es instalar **Docker Desktop**.

Docker Desktop es un paquete todo-en-uno que incluye:
- El motor de Docker (Docker Engine).
- La herramienta de línea de comandos `docker`.
- La herramienta `docker-compose`.

### Requisito Previo: WSL 2

Docker Desktop para Windows utiliza el **Subsistema de Windows para Linux (WSL) 2** para funcionar de forma eficiente. WSL 2 es una tecnología de Microsoft que te permite ejecutar un entorno de Linux real directamente en Windows.

**Paso 1: Instalar WSL**
1. Abre una terminal de PowerShell o el Símbolo del sistema de Windows **como Administrador**.
2. Ejecuta el siguiente comando. Este comando habilitará las características necesarias, descargará la última versión de Linux (normalmente Ubuntu) y la instalará por ti.
   ```powershell
   wsl --install
   ```
3. Reinicia tu ordenador cuando te lo pida para completar la instalación.

### Paso 2: Instalar Docker Desktop

1.  **Descarga:** Ve a la página oficial de Docker y descarga el instalador de Docker Desktop para Windows: [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
2.  **Instala:** Ejecuta el instalador que has descargado (el fichero `.exe`). Sigue los pasos del asistente. Asegúrate de que la opción "Use WSL 2 instead of Hyper-V" esté marcada.
3.  **Reinicia:** Es muy probable que Docker Desktop te pida reiniciar el sistema una vez más al finalizar la instalación.

### Paso 3: Verificación

Una vez reiniciado, Docker Desktop debería iniciarse automáticamente. Sabrás que está funcionando porque verás el icono de la ballena de Docker en tu barra de tareas.

Para confirmar que todo está correcto, abre una nueva terminal (PowerShell o CMD) y ejecuta estos dos comandos:

```bash
docker --version
```
Debería devolverte la versión de Docker.

```bash
docker-compose --version
```
Debería devolverte la versión de Docker Compose.

¡Si ambos comandos funcionan, tu entorno está listo!

---

## 1. El Servidor Web: La Pizzería de Internet

Imagina que pedimos una pizza a domicilio. Todo ese proceso es muy similar a cómo funciona la web.

1.  **Petición (Request):** Llamas por teléfono (tu navegador hace una petición HTTP) y pides una "pizza barbacoa grande" (la URL, `/pizzas/barbacoa`).

2.  **El Servidor Web (La pizzería):** La persona que atiende el teléfono es el servidor web principal (como Apache o Nginx). No cocina, pero sabe a quién pasarle el pedido.

3.  **El "Backend" (La cocina - Django):** El pedido llega a la cocina. Aquí es donde "se procesa la petición":
    *   **Enrutamiento (`urls.py`):** El jefe de cocina mira el pedido (`/pizzas/barbacoa`) y, según su recetario (`urls.py`), sabe que debe ejecutar la función `preparar_pizza_barbacoa`.
    *   **Lógica de la Vista (`views.py`):** El cocinero asignado (la "vista") sigue la receta. Consulta el almacén (la base de datos, usando `models.py`) para ver si quedan ingredientes, los mezcla, y mete la pizza al horno.
    *   **Renderizado de Plantilla (`templates`):** La pizza ya hecha se mete en una caja con el logo y folletos (la plantilla HTML). La vista de Django coge los datos (la pizza) y los "renderiza" dentro de esta plantilla, creando el producto final.

4.  **Respuesta (Response):** El repartidor (el servidor web) coge la caja con la pizza (la respuesta HTML) y te la lleva (la devuelve a tu navegador).

### ¿Por qué es tan importante y qué hace con HTTP?

Una petición HTTP es un mensaje de texto con un formato estricto. El servidor web es el especialista en leer ese formato. Esto es lo que hace:

1.  **Escucha Constante:** Es el único que está "escuchando" en los puertos de red (como el puerto 80 para HTTP). Sin él, ninguna petición llegaría a ningún sitio. Es la puerta de entrada.

2.  **Descodifica el Mensaje HTTP:** Lee la petición y extrae las piezas clave:
    *   **El método:** ¿Qué quiere hacer el usuario? (`GET` para pedir datos, `POST` para enviar datos).
    *   **La URL:** ¿Qué recurso específico quiere? (`/pizzas/barbacoa/`).
    *   **Las cabeceras (Headers):** Información extra como qué tipo de navegador se está usando, qué idioma prefiere el usuario, etc.
    *   **El cuerpo (Body):** Si el usuario envía datos (como un formulario), vienen aquí.

3.  **Enrutamiento primario:** Una vez entiende la petición, toma la primera decisión:
    *   **¿Es un archivo estático?** Si la URL es `/imagenes/pizza_barbacoa.png`, un servidor de producción como Nginx es ultra-rápido sirviendo estos archivos directamente, sin molestar a Django.
    *   **¿Es una petición dinámica?** Si la URL es `/pizzas/barbacoa`, el servidor sabe que esto requiere lógica. Prepara la información de la petición en un formato estándar (llamado WSGI en el mundo Python) y la pasa a la aplicación (a nuestra "cocina" Django).

En resumen, el servidor web es el **recepcionista y guardia de seguridad** de nuestra aplicación. Se encarga del trabajo "sucio" de hablar el protocolo HTTP y gestionar el tráfico, para que Django solo se preocupe de la lógica de negocio (las "recetas").

### El Servidor de Desarrollo de Django: `runserver`

Para no tener que montar una "pizzería" completa (un servidor de producción como Apache) solo para probar nuestras recetas, Django incluye un "horno-portátil" o un servidor de desarrollo.

- Lo ejecutamos con `python manage.py runserver`.
- Es un servidor web ligero, escrito completamente en Python.
- **Importante:** Es fantástico para desarrollar y probar, pero **no** es seguro ni eficiente para usar en un entorno de producción real. Para eso se usan servidores más robustos.

---

## 2. Docker: Una "Caja Mágica" para tu Aplicación

### ¿Qué es Docker?

Imagina que cocinas un plato increíble, con ingredientes y especias muy específicas. Si quieres que un amigo lo pruebe exactamente igual, lo ideal sería meterlo en un tupper mágico que no solo contenga la comida, sino también el plato, los cubiertos y hasta el aire de tu cocina.

**Docker** es ese "tupper mágico" para el software. Permite empaquetar una aplicación con **absolutamente todo lo que necesita para funcionar**: el código, las librerías, las configuraciones, etc. A este paquete lo llamamos **contenedor (container)**.

Técnicamente, Docker funciona usando una tecnología llamada **virtualización a nivel de sistema operativo**. Esto nos lleva a una comparación clave.

### Docker vs. Máquinas Virtuales: La Gran Diferencia

Para entender por qué Docker es tan eficiente, comparémoslo con las **Máquinas Virtuales (VMs)**, que eran la solución anterior al mismo problema.

*   **Una Máquina Virtual (una casa entera):** Una VM es un ordenador completo (con su propio sistema operativo) simulado por software encima de tu sistema operativo real. Es como construir **una casa nueva con sus propios cimientos y estructura** en tu terreno solo para añadir una cocina. Es pesado, consume muchos recursos (RAM, disco) y tarda minutos en arrancar.

*   **Un Contenedor Docker (una habitación):** Un contenedor no necesita un sistema operativo propio. En su lugar, comparte el "kernel" (el núcleo) del sistema operativo de la máquina anfitriona. Es como **construir solo la cocina dentro de tu casa ya existente**. Comparte los cimientos y la estructura principal. Por eso es:
    *   **Ligero:** Ocupa mucho menos espacio en disco.
    *   **Rápido:** Arranca en segundos, no minutos.
    *   **Eficiente:** Consume menos RAM y CPU.

### ¿Por qué se ha vuelto tan imprescindible?

1.  **Soluciona el "¡En mi ordenador sí funciona!":** El contenedor es un entorno estandarizado. Si funciona en el `tupper` del desarrollador, funcionará exactamente igual en el `tupper` del servidor de producción. Se eliminan los problemas por diferencias de configuración o versiones de librerías.

2.  **Facilita la Arquitectura de Microservicios:** Las aplicaciones modernas se suelen construir como un conjunto de servicios pequeños e independientes (microservicios). Docker es la herramienta perfecta para empaquetar, aislar y ejecutar cada uno de estos microservicios.

3.  **Impulsa la cultura DevOps (CI/CD):** Docker crea un artefacto único (la imagen) que se mueve a través de todo el ciclo de vida del software: desarrollo, pruebas, producción. Esto crea un pipeline de **Integración Continua y Despliegue Continuo (CI/CD)** mucho más fiable y automatizable.

4.  **Portabilidad y Escalabilidad:** Una aplicación dentro de un contenedor se puede ejecutar en cualquier sitio donde haya Docker (un portátil, un servidor en la oficina, la nube de Amazon, Google, etc.). Además, si tu app necesita más potencia, es tan fácil como lanzar más copias del mismo contenedor.

### Comandos básicos de Docker

- `docker build -t nombre-de-mi-app .`: Construye la "caja" (llamada **imagen**) a partir de un archivo de instrucciones llamado `Dockerfile`. El `-t` es para ponerle un nombre (`tag`).
- `docker run -p 8000:8000 nombre-de-mi-app`: Pone en marcha la "caja" (un **contenedor**) a partir de la imagen que creamos. El `-p 8000:8000` conecta el puerto 8000 de nuestro ordenador con el puerto 8000 de dentro del contenedor, para que podamos acceder a la aplicación desde el navegador.
- `docker ps`: Muestra los contenedores que están en funcionamiento.
- `docker stop <id_del_contenedor>`: Detiene un contenedor.

---

## 3. Docker Compose: El Director de Orquesta

### ¿Qué es Docker Compose?

Rara vez una aplicación web es una sola "caja". Normalmente, necesitas varias que trabajen juntas. En nuestro caso:
1.  **Una caja para la aplicación Django.**
2.  **Una caja para la base de datos** (donde se guardará la información).

**Docker Compose** es una herramienta que nos permite definir y gestionar este conjunto de cajas (contenedores) desde un único archivo de configuración: `docker-compose.yml`.

Este archivo es como el guion de una obra de teatro: dice qué actores (contenedores) participan, qué papel hace cada uno y cómo se comunican entre ellos.

### Comandos básicos de Docker Compose

- `docker-compose up`: Lee el archivo `docker-compose.yml` y levanta todos los servicios definidos. Si además le añades `-d`, se ejecuta en segundo plano.
- `docker-compose down`: Detiene y elimina todos los contenedores creados con `up`.
- `docker-compose ps`: Muestra el estado de los servicios de nuestro `docker-compose.yml`.

---

## 4. Docker vs. Docker Compose

| Característica | Docker | Docker Compose |
| :--- | :--- | :--- |
| **Propósito** | Gestionar contenedores individuales. | Orquestar múltiples contenedores que forman una aplicación. |
| **Uso Típico** | Para ejecutar una sola cosa (una base de datos, una herramienta, etc.). | Para ejecutar una aplicación completa (web + base de datos + otros servicios). |
| **Comando** | `docker run`, `docker build` | `docker-compose up`, `docker-compose down` |
| **Configuración** | Argumentos en la línea de comandos. | Un archivo `docker-compose.yml`. |

**En resumen:** Docker Compose no reemplaza a Docker, sino que lo complementa. Docker Compose utiliza Docker por debajo para hacer su magia.

---

## 5. Django: El Framework para Perfeccionistas con Prisas

### ¿Qué es Django?

Django es un **framework de desarrollo web de alto nivel escrito en Python**. Un "framework" es un conjunto de herramientas y librerías que nos da una estructura y nos facilita la vida para no tener que empezar desde cero.

La filosofía de Django es "Don't Repeat Yourself" (No te repitas) y viene con "pilas incluidas", lo que significa que nos da muchísimas cosas ya hechas:
- Un panel de administración.
- Un sistema para hablar con la base de datos (**ORM**, lo veremos en detalle).
- Herramientas de seguridad.
- Y mucho más.

### Comandos básicos de Django

Django tiene un archivo mágico en cada proyecto, `manage.py`, que es nuestro asistente para todo.

- `python manage.py runserver`: Inicia el servidor web de desarrollo.
- `python manage.py startapp nombre_app`: Crea una nueva "mini-aplicación" dentro de nuestro proyecto. Un proyecto Django se compone de varias de estas apps.
- `python manage.py makemigrations`: Django mira tus modelos (la definición de tus datos) y prepara los archivos necesarios para actualizar la base de datos.
- `python manage.py migrate`: Aplica esos cambios y modifica la base de datos para que coincida con tus modelos.

¡Y esto es todo por hoy! Ahora que tenemos una visión general de las herramientas, en la próxima sesión empezaremos a usarlas para ver cómo nuestra aplicación Django puede guardar y recuperar datos de una base de datos.

---

## 6. Estructura de Ficheros de un Proyecto Django

Ahora que hemos visto los conceptos, vamos a mapearlos a los ficheros de nuestro proyecto.

### 1. `manage.py`

-   **Qué es:** La navaja suiza de tu proyecto. Es un script con el que le das órdenes a Django.
-   **Explicación:** No editaremos este archivo, pero lo usaremos constantemente desde la terminal para tareas como arrancar el servidor (`runserver`), crear nuevas aplicaciones (`startapp`) o, muy importante para nosotros, interactuar con la base de datos (`makemigrations`, `migrate`).

### 2. `requirements.txt`

-   **Qué es:** La lista de la compra de nuestro proyecto Python.
-   **Explicación:** Aquí se especifican las librerías de Python que necesita el proyecto para funcionar (como por ejemplo, `Django==4.2`). El `Dockerfile` usa este archivo para instalar todo lo necesario dentro del contenedor.

### 3. El directorio `django_persistencia/` (El Proyecto)

Este directorio representa el "proyecto" Django. Contiene los archivos de configuración que afectan a todo el sitio web.

-   **`settings.py`:**
    -   **Qué es:** El panel de control central de tu aplicación.
    -   **Explicación:** Aquí se configura la base de datos, se registran las `apps` que forman el proyecto, se define la zona horaria, etc. Es uno de los archivos más importantes.

-   **`urls.py`:**
    -   **Qué es:** El recepcionista principal de tu web.
    -   **Explicación:** Cuando un usuario visita una URL, Django mira este archivo para saber qué vista (qué función de Python) debe encargarse de esa petición.

### 4. El directorio `app/` (La App)

Un proyecto Django se compone de una o más "apps". Una app es un módulo que hace una cosa concreta (un blog, un sistema de usuarios, etc.). Esto ayuda a mantener el código ordenado.

-   **`models.py`:**
    -   **Qué es:** Los planos de nuestra base de datos.
    -   **Explicación:** ¡Este es el fichero clave para la persistencia! Aquí definimos, usando clases de Python, cómo queremos que sean nuestros datos. Django usará esto para crear las tablas en la base de datos automáticamente.

-   **`views.py`:**
    -   **Qué es:** La sala de máquinas.
    -   **Explicación:** Aquí vive la lógica de la aplicación. Cuando `urls.py` decide qué vista se encarga de una petición, la función correspondiente en este archivo se ejecuta.

-   **`admin.py`:**
    -   **Qué es:** Un atajo al panel de control de datos.
    -   **Explicación:** En este archivo, con una sola línea de código, podemos "registrar" nuestros modelos para que se puedan gestionar desde una interfaz web de administrador que Django crea automáticamente.
