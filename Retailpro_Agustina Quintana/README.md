# RetailPro — Proyecto de Data Analytics

Proyecto académico de análisis de ventas de una distribuidora de productos tecnológicos. Su objetivo es organizar la información comercial y analizar las ventas, los clientes, los productos y las categorías mediante consultas SQL.

## Herramientas utilizadas

- SQL Server: creación y gestión de la base de datos.
- SQL Server Management Studio (SSMS): ejecución de consultas SQL.
- Power BI: herramienta prevista para visualizar los resultados del proyecto.

## Base de datos

La base de práctica se llama `Ventas_Tech_DB` y contiene cuatro tablas relacionadas:

- `clientes`: información de los compradores.
- `categorias`: clasificación de los productos.
- `productos`: catálogo de artículos.
- `ventas`: registro de las operaciones comerciales.

## Archivos del proyecto

- `ventas_tech_db.sql`: crea las tablas y carga los datos de ejemplo.
- `m4_consultas_negocio.sql`: contiene consultas de resumen mensual, ranking de productos y análisis de clientes.
- `m5_consultas_joins.sql`: relaciona las tablas mediante `INNER JOIN`, busca registros sin ventas mediante `LEFT JOIN` y utiliza `UNION ALL`.

## Cómo ejecutar los scripts

1. Abrir SQL Server Management Studio (SSMS) y conectarse a SQL Server.
2. Abrir y ejecutar `ventas_tech_db.sql` para crear la base de datos y cargar los registros.
3. Ejecutar `m4_consultas_negocio.sql` para consultar los resultados comerciales.
4. Ejecutar `m5_consultas_joins.sql` para revisar las relaciones entre tablas.

**Nota:** El script `ventas_tech_db.sql` elimina y vuelve a crear las tablas cuando se ejecuta nuevamente. Utilizarlo únicamente en la base de práctica.
