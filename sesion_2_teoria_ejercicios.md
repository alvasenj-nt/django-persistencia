# Sesión 2: Modelos, Migraciones y Acceso a la Base de Datos

Vamos a crear la estructura de datos para nuestra pizzería directamente en Python, y veremos cómo Django, cual ingeniero experto, traduce nuestros "planos" (modelos) en tablas de una base de datos real.

**Objetivos de hoy:**
1.  Crear y relacionar modelos de datos con varios tipos de campo.
2.  Entender el ciclo de vida de una migración para crear tablas.
3.  Modificar un modelo existente y entender el ciclo de migración para alterar tablas.
4.  Inspeccionar los cambios en la base de datos a bajo nivel.

---

## 0. Ejercicio Inicial: Construcción y Arranque del Entorno
*(Este ejercicio asume que ya se ha ejecutado `docker-compose up --build -d` y los contenedores están corriendo).*

---

## 1. Ejercicio: Explorando la Base de Datos Vacía
*(Este ejercicio asume que ya hemos entrado a la BD y comprobado que no existen las tablas de nuestra app).*

---

## 2. Ejercicio: Creación de Modelos con Varios Tipos de Datos

Ahora, vamos a definir nuestros modelos en `app/models.py` con la estructura final.

**Acción:** Reemplaza el contenido de `app/models.py` con el siguiente código.

```python
from django.db import models

class Topping(models.Model):
    nombre = models.CharField(max_length=100, unique=True)
    es_vegetariano = models.BooleanField(default=True)

    def __str__(self):
        return self.nombre

# Constante para los estados de la Pizza
ESTADOS_PIZZA = [
    ('DIS', 'Disponible'),
    ('PRO', 'Promoción'),
    ('PRG', 'Programada'),
    ('CAN', 'Cancelada'),
]

class Pizza(models.Model):
    nombre = models.CharField(max_length=100)
    precio = models.DecimalField(max_digits=5, decimal_places=2)
    fecha_fabricacion = models.DateField(auto_now_add=True)
    estado = models.CharField(
        max_length=3,
        choices=ESTADOS_PIZZA,
        default='DIS',
    )
    toppings = models.ManyToManyField(Topping)

    def __str__(self):
        return self.nombre
```

**Explicación de los campos:**
*   `DecimalField`: Ideal para precios.
*   `DateField`: Guarda una fecha (`auto_now_add=True` la fija en la creación).
*   `BooleanField`: Un simple campo de verdadero/falso.
*   `choices`: En `Pizza`, hemos definido una constante `ESTADOS_PIZZA` (una lista de tuplas) y se la hemos pasado al campo `estado`. Django usará esto para mostrar un desplegable en su panel de administrador.

> **Nota del profesor: ¿Qué es una relación `ManyToManyField`?**
>
> Hemos usado `toppings = models.ManyToManyField(Topping)` en nuestro modelo `Pizza`. Este tipo de campo se usa cuando un registro de una tabla puede estar relacionado con muchos registros de otra, y viceversa.
>
> - Una `Pizza` puede tener muchos `Topping`s.
> - Un `Topping` (ej: queso) puede estar en muchas `Pizza`s.
>
> Una base de datos relacional no puede guardar esta "lista" en una sola columna. Por ello, la única forma de representar esta relación es con una **tabla intermedia** (o tabla de unión).
>
> La magia de Django es que, al usar `ManyToManyField`, él crea y gestiona esta tabla por nosotros. Contendrá, como mínimo, una clave foránea al `id` de la pizza y otra al `id` del topping. Por eso, cuando hagamos la migración, veremos aparecer una tabla extra que no hemos definido como modelo: `app_pizza_toppings`.

---

## 3. Ejercicio: La Primera Migración (CREATE TABLE)

Con los modelos definidos, vamos a crear las tablas.

### 3.1. Crear el fichero de migración

Entra al contenedor de la aplicación (`docker-compose exec servidor bash`) y ejecuta:
```bash
# Dentro del contenedor 'servidor':
python manage.py makemigrations app
```
Django creará el fichero `app/migrations/0001_initial.py`. Sal del contenedor.

### 3.2. Revisar el SQL generado

Entra de nuevo al contenedor y ejecuta:
```bash
# Dentro del contenedor 'servidor':
python manage.py sqlmigrate app 0001
```
Verás las sentencias `CREATE TABLE` que se van a ejecutar. Sal del contenedor.

### 3.3. Aplicar la migración

Entra al contenedor por última vez en este ejercicio y ejecuta:
```bash
# Dentro del contenedor 'servidor':
python manage.py migrate
```
Sal del contenedor.

### 3.4. Verificar en la Base de Datos

Accede al cliente de MySQL como en el Ejercicio 1 y usa `SHOW TABLES;`. Verás las nuevas tablas. Luego, usa `DESCRIBE app_pizza;` para ver que todas las columnas se han creado como esperábamos.

---

## 4. Ejercicio: Modificando un Modelo Existente

El software evoluciona. Supongamos que nuestras pizzas pueden llegar a ser muy caras y necesitamos más dígitos para el precio.

### 4.1. Modificar el campo `precio`

**Acción:** Modifica `app/models.py` para que la línea del campo `precio` en el modelo `Pizza` quede así:

```python
# ... (dentro de la clase Pizza)
    precio = models.DecimalField(max_digits=10, decimal_places=2) # Cambiamos max_digits de 5 a 10
# ...
```

---

## 5. Ejercicio: La Segunda Migración (ALTER TABLE)

Ahora, aplicaremos el cambio realizado en el modelo.

### 5.1. Crear la migración de modificación

Entra al contenedor (`docker-compose exec servidor bash`) y ejecuta:
```bash
# Dentro del contenedor 'servidor':
python manage.py makemigrations app
```
Django detectará el cambio en el campo `precio` y creará un nuevo fichero, ej: `0002_alter_pizza_precio.py`. Sal del contenedor.

### 5.2. Revisar el SQL de la modificación

Entra de nuevo al contenedor y revisa el SQL para la nueva migración:
```bash
# Dentro del contenedor 'servidor':
python manage.py sqlmigrate app 0002
```
Esta vez, el resultado debería ser una sentencia `ALTER TABLE ... MODIFY COLUMN ...` para el campo `precio`. Sal del contenedor.

### 5.3. Aplicar la nueva migración

Entra por última vez al contenedor y aplica la migración:
```bash
# Dentro del contenedor 'servidor':
python manage.py migrate
```
Sal del contenedor.

### 5.4. Verificación Final

Accede a MySQL y ejecuta `DESCRIBE app_pizza;`. Comprueba que el tipo de la columna `precio` ha cambiado para reflejar los nuevos `max_digits` (ej. `decimal(10,2)`).

---