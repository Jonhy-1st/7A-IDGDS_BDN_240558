# Práctica 04

Esta carpeta reúne la documentación del esquema `db_test` a partir del respaldo
`backups/Respaldo_240558_final.sql`. El respaldo se conserva en la computadora local
y no se incluye en Git porque contiene datos personales y hashes de contraseñas.

El análisis del archivo encontró 27 tablas, 234 campos, 34 claves foráneas,
43 vistas, 83 triggers, 21 procedimientos, 2 funciones y 123,820 filas en
sentencias `INSERT`. El conteo corresponde al respaldo y no a una consulta en vivo.

## Diccionario de datos

- [Diccionario interactivo](diccionario/diccionario.html): permite buscar tablas
  y campos, explorar relaciones y cargar otro respaldo SQL localmente.
- [CSV de campos](diccionario/campos.csv): descripción y propiedades de cada
  columna.
- [Documentación general y fichas por tabla](docs/DOCUMENTACION_DB_TEST.md).

Para regenerar el diccionario y las fichas desde el respaldo final, ejecuta:

```powershell
node Practica04/scripts/generar_diccionario_interactivo.js Practica04/backups/Respaldo_240558_final.sql
```

El candidato del diagrama se regenera con:

```powershell
node Practica04/scripts/generar_diagrama_esquema.js
```

Después, valida y publica el HTML interactivo desde la raíz del proyecto:

```powershell
node .agents/skills/archify/bin/archify.mjs finalize erd .archify/erd-respaldo-240558-final-20261121-1700/candidate.json docs/diagrama/index.html --quality standard --json
```

## Casos de compra

- [Guía sencilla de ejecución y comprobación](docs/GUIA_SENCILLA_CASOS_COMPRA.md).
- [Preparación y reglas de los casos](docs/PREPARACION_CASOS_COMPRA.md).
- [Scripts de preparación y operaciones](scripts/).
- [Consulta de verificación](queries/verificacion_casos_compra.sql).
- [Vistas de trazabilidad de los cinco casos](scripts/crear_vistas_trazabilidad_casos.sql):
  crea `vw_practica04_caso_1` a `vw_practica04_caso_5` y `vw_practica04_resumen`.
- [Consultas para ver las trazabilidades](queries/trazabilidad_casos_compra.sql).
