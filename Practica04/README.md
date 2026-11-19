# Práctica 04

Esta carpeta reúne la documentación del esquema `db_test` a partir del respaldo
`backups/Respaldo_Practica4.sql`. El respaldo se conserva en la computadora local
y no se incluye en Git porque contiene datos personales y hashes de contraseñas.

El análisis del archivo encontró 27 tablas, 234 campos, 34 claves foráneas y
123,820 filas en sentencias `INSERT`. El conteo corresponde a las filas
representadas en el respaldo y no a una consulta en vivo.

## Diccionario de datos

- [Diccionario interactivo](diccionario/diccionario.html): permite buscar tablas
  y campos, explorar relaciones y cargar otro respaldo SQL localmente.
- [CSV de campos](diccionario/campos.csv): descripción y propiedades de cada
  columna.
- [Documentación general y fichas por tabla](docs/DOCUMENTACION_DB_TEST.md).

Para regenerar los archivos, coloca una copia local del respaldo en `backups/` y
ejecuta:

```powershell
node scripts/generar_diccionario_interactivo.js backups/Respaldo_Practica4.sql
```

## Casos de compra

- [Guía sencilla de ejecución y comprobación](docs/GUIA_SENCILLA_CASOS_COMPRA.md).
- [Preparación y reglas de los casos](docs/PREPARACION_CASOS_COMPRA.md).
- [Scripts de preparación y operaciones](scripts/).
- [Consulta de verificación](queries/verificacion_casos_compra.sql).
