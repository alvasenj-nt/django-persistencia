# Sesión 3: Vistas de Lectura y Creación (API con Django Puro)

Hoy crearemos vistas que actúen como una API, comunicándose mediante JSON. Aprenderemos a leer datos de la base de datos y a crear nuevos registros a través de peticiones HTTP directas.

**Objetivos de hoy:**
1.  Crear vistas que devuelvan respuestas en formato JSON con `JsonResponse`.
2.  Manejar diferentes métodos HTTP (`GET`, `POST`) en una misma vista.
3.  Convertir manualmente un QuerySet de Django a una estructura de datos serializable (lista de diccionarios).
4.  Crear nuevos objetos en la base de datos a partir de datos recibidos en una petición.
5.  Usar `cURL` para probar nuestros endpoints de API.

---

## 1. Ejercicio: Endpoint de Lista de Pizzas (`GET /pizzas/`)

Nuestro primer objetivo es crear una URL (`/pizzas/`) que, al ser consultada con el método `GET`, devuelva una lista de todas las pizzas en nuestra base de datos en formato JSON.

### 1.1. Organizando las URLs de la App

Es una buena práctica que cada app gestione sus propias URLs. Crearemos un fichero `urls.py` dentro de nuestra `app`.

**Acción:** Crea el fichero `app/urls.py` con el siguiente contenido.

```python
# en app/urls.py
from django.urls import path
from . import views

urlpatterns = [
    # De momento lo dejamos vacío
]
```

### 1.2. Incluyendo las URLs de la App en el Proyecto

Ahora, le decimos al proyecto principal que tenga en cuenta las URLs de nuestra `app`.

**Acción:** Modifica el fichero `django_persistencia/urls.py` para que quede así.

```python
# en django_persistencia/urls.py
from django.contrib import admin
from django.urls import path, include # Asegúrate de importar 'include'

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('app.urls')), # ¡Línea nueva!
]
```
Esto le dice a Django: "para cualquier URL que no sea `/admin/`, ve a buscar las reglas en `app.urls`".

### 1.3. Creando la Vista de Lista

Ahora, la lógica principal.

**Acción:** Reemplaza el contenido de `app/views.py` con esto:

```python
# en app/views.py
from django.http import JsonResponse
from .models import Pizza

def pizzas_view(request):
    if request.method == 'GET':
        pizzas = Pizza.objects.all()
        # Convertimos el QuerySet a una lista de diccionarios
        data = []
        for pizza in pizzas:
            data.append({
                'id': pizza.id,
                'nombre': pizza.nombre,
                'precio': str(pizza.precio), # Convertimos Decimal a string
                'estado': pizza.get_estado_display(), # Usamos un método útil de Django
            })
        return JsonResponse({'pizzas': data})
    
    # Dejaremos espacio para el POST más adelante
    return JsonResponse({'error': 'Método no soportado'}, status=405)
```
**Explicación:**
- Importamos `JsonResponse`, que convierte diccionarios de Python a JSON.
- `Pizza.objects.all()`: Es el comando del ORM que dice "dame todos los registros de la tabla Pizza".
- `get_estado_display()`: Como `estado` es un campo con `choices`, Django nos regala este método para obtener el texto legible (ej: "Disponible") en lugar del valor guardado en la BD (ej: "DIS").

### 1.4. Conectando URL y Vista

**Acción:** Vuelve a `app/urls.py` y modifícalo para que conecte la URL `/pizzas/` con la vista que acabamos de crear.

```python
# en app/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('pizzas/', views.pizzas_view, name='pizzas_view'),
]
```

### 1.5. Probar con `cURL`

Abre una **nueva terminal** (no la de `runserver`) y ejecuta:
```bash
curl http://localhost:8000/pizzas/
```
**Resultado esperado:** Deberías ver una respuesta JSON con una lista vacía, porque aún no hemos creado ninguna pizza.
```json
{"pizzas": []}
```

---

## 2. Ejercicio: Endpoint de Creación de Pizzas (`POST /pizzas/`)

Ahora, vamos a añadir la lógica para que el mismo endpoint `/pizzas/` pueda crear una pizza nueva cuando reciba una petición `POST`.

### 2.1. Modificar la Vista para Aceptar `POST`

> **Nota del profesor: ¡Cuidado con el error 403 (CSRF)!**
>
> Al hacer una petición `POST` a una vista de Django desde una herramienta externa como `cURL`, es casi seguro que te encuentres con un error `403 Forbidden` por un fallo de verificación `CSRF`. Es una medida de seguridad vital de Django. Como nuestra vista es una API y no un formulario web tradicional, debemos indicarle a Django que la exima de esta verificación. Lo hacemos con el decorador `@csrf_exempt`.

**Acción:** Modifica de nuevo `app/views.py` para añadir la lógica `POST` y el decorador.

```python
# en app/views.py
from django.http import JsonResponse
from .models import Pizza, Topping # Importamos Topping
from django.views.decorators.csrf import csrf_exempt # ¡Importante!
import json

@csrf_exempt # ¡Importante!
def pizzas_view(request):
    if request.method == 'GET':
        pizzas = Pizza.objects.all()
        data = []
        for pizza in pizzas:
            data.append({
                'id': pizza.id,
                'nombre': pizza.nombre,
                'precio': str(pizza.precio),
                'estado': pizza.get_estado_display(),
            })
        return JsonResponse({'pizzas': data})

    if request.method == 'POST':
        # Creamos una pizza con los datos del POST
        # Ojo: esto es una simplificación, no hay validación de datos
        nombre = request.POST.get('nombre')
        precio = request.POST.get('precio')
        
        if not nombre or not precio:
            return JsonResponse({'error': 'Faltan nombre o precio'}, status=400)

        pizza = Pizza.objects.create(nombre=nombre, precio=precio)
        
        # Gestionar la relación ManyToMany para los toppings
        topping_ids = request.POST.getlist('toppings')
        if topping_ids:
            pizza.toppings.set(topping_ids)
        
        # Devolvemos la pizza creada
        return JsonResponse({
            'message': 'Pizza creada con éxito',
            'pizza': {
                'id': pizza.id,
                'nombre': pizza.nombre,
                'precio': str(pizza.precio),
                'estado': pizza.get_estado_display(),
            }
        }, status=201)

    return JsonResponse({'error': 'Método no soportado'}, status=405)
```
**Explicación Clave:**
- `request.POST`: Es un diccionario que contiene los datos enviados en el cuerpo de una petición POST con formato `form-urlencoded`.
- `Pizza.objects.create()`: Un atajo del ORM para crear y guardar un nuevo objeto en un solo paso.
- `request.POST.getlist('toppings')`: `getlist` es crucial para campos que pueden tener múltiples valores, como es nuestro caso al seleccionar varios toppings.
- `pizza.toppings.set(topping_ids)`: Esta es la forma de establecer las relaciones muchos a muchos. Le pasamos una lista de IDs de `Topping` y Django crea las relaciones en la tabla intermedia.

### 2.2. Probar la Creación con `cURL`

Para esto, primero necesitamos crear algunos toppings. Lo haremos desde el "shell" de Django, una herramienta muy útil.

1.  **Crear Toppings:**
    Entra al contenedor (`docker-compose exec servidor bash`) y ejecuta `python manage.py shell`. Una vez dentro del shell de Django:
    ```python
    from app.models import Topping
    Topping.objects.create(nombre='Queso', es_vegetariano=True)
    Topping.objects.create(nombre='Tomate', es_vegetariano=True)
    Topping.objects.create(nombre='Jamon', es_vegetariano=False)
    exit()
    ```
    Y sal del contenedor (`exit`). Ahora tenemos toppings con IDs 1, 2 y 3.

2.  **Lanzar la petición `POST`:**
    Ahora sí, desde una terminal normal, creamos nuestra primera pizza.
    ```bash
    curl -X POST -d "nombre=Margarita&precio=9.99&toppings=1&toppings=2" http://localhost:8000/pizzas/
    ```
    **Desglose:**
    - `-X POST`: Especifica que el método es POST.
    - `-d "..."`: Define los datos que se envían en el cuerpo de la petición. El formato es el mismo que el de un formulario HTML.

### 2.3. Verificación Final

Si la petición anterior tuvo éxito, ¡ahora puedes volver a comprobar la lista de pizzas!
```bash
curl http://localhost:8000/pizzas/
```
**Resultado esperado:** Ahora la lista ya no estará vacía. Deberías ver tu pizza Margarita recién creada.
```json
{"pizzas": [{"id": 1, "nombre": "Margarita", "precio": "9.99", "estado": "Disponible"}]}
```
¡Felicidades! Has completado el ciclo de Creación y Lectura (CR de CRUD) para una API.
