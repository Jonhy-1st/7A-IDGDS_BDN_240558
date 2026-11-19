# Categorización de productos

## Resultado preparado

La semilla `seeds/categorizacion_productos_completo.csv` conserva las 12,399 asignaciones originales y agrega 9,993 asignaciones para completar los 15,000 productos del respaldo de referencia. Las asignaciones nuevas usan la categoría raíz indicada explícitamente en la descripción de cada producto. Por ello, los productos 5,008–15,000 reciben una categoría primaria; no se infieren subcategorías que la fuente no especifica.

Los IDs 101 y 102 del CSV son marcadores internos, no IDs persistentes de la base:

| Marcador del CSV | Categoría raíz que crea/resuelve el cargador |
|---:|---|
| 101 | Alimentos y Bebidas |
| 102 | Herramientas y Ferretería |

Estas dos etiquetas no existían entre las 100 categorías del respaldo. El cargador las agrega como categorías raíz si aún no están en el catálogo y resuelve sus IDs reales por nombre.

## Carga

La carga se ejecuta con una cuenta a la que esté activo el rol `seller`. Ese rol necesita `SELECT, INSERT` sobre `tbd_products_categories`; la versión anterior del esquema no otorgaba esos permisos. Un administrador debe concederlos una vez:

```sql
GRANT SELECT, INSERT ON db_test.tbd_products_categories TO 'seller';
```

La modificación también quedó en los dos scripts de configuración de roles del repositorio. Importa primero el respaldo de referencia en una base de trabajo y ejecuta desde la raíz del repositorio como usuario seller:

```text
mysql -u <usuario_seller> -p db_test < "Practica 03/scripts/cargar_categorizacion_productos.sql"
```

Si ya estás dentro del cliente y ves el prompt `mysql>`, ejecuta el archivo con `source`:

```text
source "C:/Users/jonhy/7A-IDGDS_BDN_240558/Practica 03/scripts/cargar_categorizacion_productos.sql";
```

El script contiene las relaciones en bloques de `INSERT`, así seller no necesita `LOAD DATA LOCAL INFILE`, tablas temporales ni rutinas. Revisa el preflight: los IDs 101 y 102 deben corresponder a Alimentos y Bebidas y Herramientas y Ferretería. La carga ignora pares duplicados y no cambia ni reactiva vínculos existentes.

Verifica el resultado ejecutando `queries/consultas_verificacion_categorias.sql`. Debe reportar cero productos sin categoría activa y cero relaciones huérfanas.

## Límites de la inferencia

Las 12,399 asignaciones existentes para los primeros 5,007 productos se conservaron sin cambios. Para los restantes, la categoría raíz sale del texto del respaldo. Dos categorías raíz se incorporan porque no existían en el catálogo anterior. Revisa la distribución de la consulta de verificación antes de aplicar la carga en una base compartida.
