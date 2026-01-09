# Sesión 4: Vistas de Edición y Borrado (API con Django Puro)

En la sesión anterior construimos los endpoints para leer la lista de pizzas y para crear nuevas. Hoy completaremos el ciclo CRUD (Create, Read, Update, Delete) aprendiendo a interactuar con un recurso específico a través de su ID.

**Objetivos de hoy:**
1.  Crear vistas que operen sobre un único objeto de la base de datos.
2.  Capturar parámetros desde la URL (ej: el `id` de una pizza).
3.  Manejar los métodos `GET` (detalle), `PUT` (actualización) y `DELETE` (borrado).
4.  Leer y procesar un cuerpo de petición en formato JSON.
5.  Usar `cURL` para probar estos nuevos endpoints.

---

## 1. Ejercicio: Endpoint de Detalle y Actualización (`/pizzas/<id>/`)

Crearemos una única vista que se comportará de forma diferente según el método HTTP que reciba.

### 1.1. Creando la Nueva URL y Vista

Primero, definimos la ruta. Django tiene una forma elegante de capturar partes de la URL como variables.

**Acción:** Añade la nueva ruta a `app/urls.py`.

```python
# en app/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('pizzas/', views.pizzas_view, name='pizzas_view'),
    path('pizzas/<int:pk>/', views.pizza_detail_view, name='pizza_detail_view'), # ¡Línea nueva!
]
```
**Explicación:** `<int:pk>` le dice a Django que espere un número entero en esta parte de la URL y que lo pase a la vista como un argumento llamado `pk` (abreviatura de *Primary Key*, una convención común).

Ahora, creemos el esqueleto de la vista en `app/views.py`.

**Acción:** Añade esta nueva función al final de `app/views.py`.

```python
# al final de app/views.py
from django.shortcuts import get_object_or_404 # ¡Nueva importación!

@csrf_exempt
def pizza_detail_view(request, pk):
    # Usaremos esta función para GET, PUT y DELETE
    # Primero, obtenemos la pizza o devolvemos un 404 si no existe
    pizza = get_object_or_404(Pizza, pk=pk)
    
    return JsonResponse({'error': 'Método no soportado aún'}, status=405)
```
**Explicación:**
- `get_object_or_404`: Es un atajo de Django que intenta obtener un objeto. Si no lo encuentra, automáticamente devuelve un error 404 (Not Found), ahorrándonos escribir un `try...except`.
- `pk`: Es el argumento que recibe el valor de la URL.

### 1.2. Implementando la Lectura de un solo objeto (`GET`)

**Acción:** Modifica `pizza_detail_view` para que maneje peticiones `GET`.

```python
# Reemplaza pizza_detail_view con esta versión
@csrf_exempt
def pizza_detail_view(request, pk):
    pizza = get_object_or_404(Pizza, pk=pk)
    
    if request.method == 'GET':
        data = {
            'id': pizza.id,
            'nombre': pizza.nombre,
            'precio': str(pizza.precio),
            'estado': pizza.get_estado_display(),
            'toppings': list(pizza.toppings.all().values('id', 'nombre')),
        }
        return JsonResponse(data)
    
    return JsonResponse({'error': 'Método no soportado aún'}, status=405)
```
**Explicación:**
- `pizza.toppings.all().values(...)`: Para el campo `ManyToManyField`, obtenemos todos los toppings relacionados y con `.values()` los convertimos en una lista de diccionarios, que es compatible con JSON.

### 1.3. Probar el Detalle con `cURL`

Suponiendo que la pizza "Margarita" que creaste tiene `id=1`:
```bash
curl http://localhost:8000/pizzas/1/
```
**Resultado esperado:** Deberías ver el JSON con los datos de esa única pizza, incluyendo sus toppings.

---

## 2. Ejercicio: Actualización (`PUT`) y Borrado (`DELETE`)

### 2.1. Implementando la Actualización (`PUT`)

Usaremos `PUT` para actualizar el objeto completo. Para ello, necesitamos leer el cuerpo de la petición, que esta vez enviaremos en formato JSON.

**Acción:** Añade el bloque para `PUT` a `pizza_detail_view`.

```python
# Reemplaza pizza_detail_view con esta versión final
@csrf_exempt
def pizza_detail_view(request, pk):
    pizza = get_object_or_404(Pizza, pk=pk)
    
    if request.method == 'GET':
        # ... (código del GET sin cambios)
        data = {
            'id': pizza.id,
            'nombre': pizza.nombre,
            'precio': str(pizza.precio),
            'estado': pizza.get_estado_display(),
            'toppings': list(pizza.toppings.all().values('id', 'nombre')),
        }
        return JsonResponse(data)

    if request.method == 'PUT':
        data = json.loads(request.body)
        pizza.nombre = data.get('nombre', pizza.nombre)
        pizza.precio = data.get('precio', pizza.precio)
        pizza.estado = data.get('estado', pizza.estado)
        
        # Para actualizar toppings, usamos .set()
        if 'toppings' in data:
            pizza.toppings.set(data['toppings'])

        pizza.save()
        
        # Devolvemos los datos actualizados
        # (reutilizamos el código de la lógica GET)
        data_response = {
            'id': pizza.id,
            'nombre': pizza.nombre,
            'precio': str(pizza.precio),
            'estado': pizza.get_estado_display(),
            'toppings': list(pizza.toppings.all().values('id', 'nombre')),
        }
        return JsonResponse(data_response)
    
    return JsonResponse({'error': 'Método no soportado aún'}, status=405)
```
**Explicación:**
- `json.loads(request.body)`: Así es como leemos un cuerpo de petición que viene en formato JSON.
- `data.get('nombre', pizza.nombre)`: Usamos `.get()` con un valor por defecto para permitir actualizaciones parciales (si un campo no viene en el JSON, mantenemos su valor actual).
- `pizza.save()`: El ORM es lo suficientemente inteligente como para saber que, si el objeto ya tiene un `pk`, debe hacer un `UPDATE` en lugar de un `INSERT`.

### 2.2. Probar la Actualización con `cURL`

Vamos a cambiar el nombre y el precio de nuestra pizza con `id=1`.
```bash
curl -X PUT -H "Content-Type: application/json" -d '{"nombre": "Margarita Especial", "precio": "10.50"}' http://localhost:8000/pizzas/1/
```
**Desglose:**
- `-X PUT`: Especifica el método PUT.
- `-H "Content-Type: application/json"`: ¡Muy importante! Le dice a Django que el cuerpo de la petición es JSON.
- `-d '{...}'`: El cuerpo de la petición, esta vez como un string JSON.

**Verificación:** Vuelve a hacer `curl http://localhost:8000/pizzas/1/` y verás los datos actualizados.

### 2.3. Implementando el Borrado (`DELETE`)

**Acción:** Completa la vista `pizza_detail_view` con la lógica de `DELETE`.

```python
# Esta es la versión final final de la vista
@csrf_exempt
def pizza_detail_view(request, pk):
    pizza = get_object_or_404(Pizza, pk=pk)
    
    if request.method == 'GET':
        # ... (sin cambios)
        # ...
        return JsonResponse(data)

    if request.method == 'PUT':
        # ... (sin cambios)
        # ...
        return JsonResponse(data_response)

    if request.method == 'DELETE':
        pizza.delete()
        return JsonResponse({}, status=204) # 204 = No Content

    return JsonResponse({'error': 'Método no soportado'}, status=405)
```
**Explicación:**
- `pizza.delete()`: El ORM se encarga de borrar el registro de la tabla.
- `status=204`: Es el código de estado estándar para una respuesta exitosa que no devuelve contenido en el cuerpo.

### 2.4. Probar el Borrado con `cURL`

```bash
curl -X DELETE http://localhost:8000/pizzas/1/
```
**Verificación Final:**
Haz una última petición `GET` a la lista completa:
```bash
curl http://localhost:8000/pizzas/
```
La lista de pizzas debería volver a estar vacía.

---
¡Felicidades! Has completado un ciclo CRUD completo para una API RESTful usando solo las herramientas principales de Django.
