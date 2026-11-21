-- Consultas que reproducen los resultados de Trazabilidades/image.png.
-- Ejecutar después de scripts/crear_vistas_trazabilidad_casos.sql.
USE `db_test`;

SELECT * FROM vw_practica04_caso_1 ORDER BY fecha_evento, tabla_modificada;
SELECT * FROM vw_practica04_caso_2 ORDER BY fecha_evento, tabla_modificada;
SELECT * FROM vw_practica04_caso_3 ORDER BY fecha_evento, tabla_modificada;
SELECT * FROM vw_practica04_caso_4 ORDER BY fecha_evento, tabla_modificada;
SELECT * FROM vw_practica04_caso_5 ORDER BY fecha_evento, tabla_modificada;
SELECT * FROM vw_practica04_resumen ORDER BY caso;
