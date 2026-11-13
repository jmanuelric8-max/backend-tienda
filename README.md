# Backend de MiTienda

API REST de Node.js y Express conectada a MySQL. Expone el catálogo y las
operaciones de carrito que consume `carrito-compras`.

## Configuración

1. Configura las variables `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`,
   `DB_NAME` y opcionalmente `PORT` en `.env`.
2. Selecciona la base de datos indicada por `DB_NAME` en MySQL y ejecuta
   `database/schema.sql` para crear las tablas e insertar el catálogo inicial.
   Los productos guardan `categoria_id`; la API obtiene el nombre mediante la
   relación con la tabla `categorias`.
3. En esta carpeta, ejecuta:

   ```bash
   npm install
   npm run dev
   ```

El servidor usa el puerto `3001` si no se configura `PORT`.
Las imágenes se guardan en `uploads/` y se sirven desde `/uploads/:archivo`.

## Despliegue en Render con MySQL en Railway

Configura en el servicio de Render las variables `DB_HOST`, `DB_PORT`,
`DB_USER`, `DB_PASSWORD` y `DB_NAME` con los datos de conexión de Railway.
Render no importa automáticamente las variables de Railway. Como la API se
ejecuta fuera de Railway, `DB_HOST` y `DB_PORT` deben ser los de la conexión
pública TCP/proxy de Railway; el host privado de Railway solo funciona dentro
de su red. Ejecuta `database/schema.sql` en esa misma base de datos.

El backend también reconoce `MYSQLHOST`, `MYSQLPORT`, `MYSQLUSER`,
`MYSQLPASSWORD` y `MYSQLDATABASE` si el entorno las proporciona. Si falla la
consulta, el detalle queda registrado en los logs del servicio de Render.

## Rutas usadas por el frontend

| Método | Ruta | Función |
|---|---|---|
| `GET` | `/api/productos` | Lista productos activos |
| `POST` | `/api/productos` | Crea producto con `nombre`, `precio`, `categoria_id` y archivo `imagen` |
| `POST` | `/api/carritos` | Crea un carrito |
| `GET` | `/api/carritos/:id` | Consulta sus productos y total |
| `POST` | `/api/carritos/:id/productos` | Agrega un producto |
| `PUT` | `/api/carritos/:id/productos/:detalle_id` | Actualiza una cantidad |
| `DELETE` | `/api/carritos/:id/productos/:detalle_id` | Quita un producto |
| `DELETE` | `/api/carritos/:id` | Vacía el carrito |
| `POST` | `/api/carritos/:id/compras` | Registra la compra y crea un carrito nuevo |

Las compras se guardan en las tablas `compras` y `detalle_compra`, con el total
y una copia del nombre, cantidad y precio de cada producto. Al confirmar una
compra, el carrito queda marcado como comprado y la API devuelve un carrito
nuevo para seguir comprando. Esta aplicación no procesa pagos.

Para crear un producto, envía `multipart/form-data` a `POST /api/productos`.
El archivo debe estar en el campo `imagen` y ser JPG, PNG o WebP de hasta 5 MB.
El nombre del archivo se guarda en la columna `productos.imagen`.
