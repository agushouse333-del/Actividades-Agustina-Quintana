# RetailPro | Análisis comercial con SQL Server

Proyecto académico de **Data Analytics** sobre una distribuidora de tecnología. El objetivo definido en el brief inicial es investigar por qué algunas regiones podrían presentar menor **ticket promedio** y qué categorías de producto explicarían las diferencias. El trabajo se desarrolla de manera acumulativa: diseño relacional, consultas SQL, modelado y visualización.

> **Alcance actual:** los scripts SQL disponibles implementan la base de referencia `Ventas_Tech_DB` con **4 tablas**, no la dimensión geográfica del modelo conceptual. Por eso, **no es posible atribuir resultados a regiones o demostrar tendencias trimestrales** a partir de esta versión de los datos.

## Herramientas

- **Microsoft SQL Server**: motor de base de datos relacional (T-SQL).
- **SQL Server Management Studio (SSMS)**: ejecución y validación de scripts.
- **Power BI**: herramienta prevista para integrar y visualizar los resultados analíticos. Este repositorio documenta los scripts disponibles; no presupone que se haya publicado un dashboard final.
- **ChatGPT**: asistencia para revisar SQL y redactar documentación; las afirmaciones numéricas fueron contrastadas con el script de carga.

## Tablas implementadas

| Tabla | Función | Claves relevantes |
|---|---|---|
| `dbo.categorias` | Clasificación de artículos | `id_categoria` (PK) |
| `dbo.productos` | Catálogo, precio y stock | `id_producto` (PK), `id_categoria` (FK) |
| `dbo.clientes` | Clientes y ciudad | `id_cliente` (PK) |
| `dbo.ventas` | Transacciones, cantidad y precio histórico | `id_venta` (PK), `id_cliente` y `id_producto` (FK) |

**Relaciones:** `categorias` 1:N `productos`; `clientes` 1:N `ventas`; `productos` 1:N `ventas`. El diseño conceptual anterior contemplaba `territorios`, pero el script de creación de esta base no incluye esa tabla ni la FK territorial en `ventas`.

## Archivos SQL y orden de ejecución

1. **`ventas_tech_db.sql` — creación y carga**: crea `Ventas_Tech_DB` si no existe, recrea las cuatro tablas, inserta 4 categorías, 5 clientes, 6 productos y 10 ventas, y ejecuta `SELECT` de control.
2. **`m4_consultas_negocio.sql` — análisis comercial**: resumen mensual, Top 5 de productos, clientes recurrentes y comparación de facturación por producto frente al promedio.
3. **`m5_consultas_joins.sql` — relaciones y auditoría**: vista base con `INNER JOIN`, clientes sin ventas, productos sin ventas y consolidado de dos períodos mediante `UNION ALL`.

### Cómo ejecutarlo

1. Tener instalado SQL Server y abrir una conexión al servidor desde SSMS.
2. Abrir **`ventas_tech_db.sql`** y ejecutar el script completo. Verificar que las cuatro consultas de validación devuelvan **4, 5, 6 y 10 filas**, respectivamente.
3. Abrir y ejecutar **`m4_consultas_negocio.sql`**.
4. Abrir y ejecutar **`m5_consultas_joins.sql`**.

**Precaución:** `ventas_tech_db.sql` contiene `DROP TABLE IF EXISTS`. Volver a ejecutarlo **borra y recrea las tablas** y, por tanto, cualquier modificación posterior de sus datos. Se debe usar únicamente en el entorno de práctica o sobre una copia controlada.

## Resultados comprobables del dataset de referencia

- **Período disponible:** 5 al 15 de marzo de 2024; no hay meses adicionales en el archivo de carga.
- **Facturación:** 6.444,00 unidades monetarias, provenientes de **10 registros de venta**.
- **Ticket promedio por registro de venta:** 644,40 (`SUM(cantidad * precio_unitario) / COUNT(*)`). En este dataset hay un registro por `id_venta`.
- **Concentración:** Laptop Pro 15 (`id_producto=1`) y Monitor 4K 27 (`id_producto=3`) generan conjuntamente 4.950,00, equivalentes al **76,82 %** de la facturación.
- **Volumen versus importe:** Mouse Inalámbrico (`id_producto=2`) registra **13 unidades** pero **364,00** de facturación, por debajo de los dos productos líderes en importe.

Las cifras anteriores se contrastaron con los **10 registros `INSERT`** de `ventas_tech_db.sql`. Para validar contra una instalación real, ejecutar los scripts en SSMS y comprobar sus salidas.

## Alcances y limitaciones

- Los datos de ejemplo abarcan **un solo mes**, por lo que no permiten calcular crecimiento mensual, estacionalidad ni comparativas contra el año anterior.
- La base implementada **no incluye `territorios` ni región de la venta**; `clientes.ciudad` no debe confundirse automáticamente con región comercial.
- No existe un campo de **costo/margen** en `ventas`, por lo que mayor facturación **no implica** mayor rentabilidad.
- La cuarta consulta del módulo 5 utiliza las etiquetas `Periodo 1` y `Periodo 2` en una columna llamada `canal`; **son períodos temporales, no canales de venta reales**.
- El dataset de práctica es pequeño; cambios de rendimiento SQL requieren prueba con plan de ejecución y mayor volumen antes de recomendar índices adicionales.

## Uso responsable de IA

Se utilizó ChatGPT para proponer simplificaciones de SQL y redactar un borrador de esta documentación. Se verificaron importes, tablas y límites del modelo mediante los scripts originales. Ninguna cifra se atribuye a otras fechas o regiones sin evidencia.
