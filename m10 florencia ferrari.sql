create database empresa2;

use empresa2;
----Crear tabla---
CREATE TABLE ventas_semana (
    sucursal VARCHAR(100),
    venta DECIMAL(10, 2)
);

select * from ventas_semana

INSERT INTO ventas_semana (sucursal, venta) VALUES 
('Sucursal Norte', 500),
('Sucursal Norte', 510),
('Sucursal Norte', 490),
('Sucursal Norte', 505),
('Sucursal Norte', 495),
('Sucursal Sur', 100),
('Sucursal Sur', 900),
('Sucursal Sur', 50),
('Sucursal Sur', 1200),
('Sucursal Sur', 250);


---media y rango--
select
sucursal,
avg(venta) as media,
max(venta) - min(venta) as rango
from dbo.ventas_semana
group by sucursal;

---desvio--
select
sucursal,
STDEV(venta) AS desvio_muestral 
from ventas_semana
GROUP BY sucursal;

--mediana media (retail pro)--
use RetailPro;

SELECT DISTINCT
    AVG(MontoTotal) OVER() AS media,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY MontoTotal) OVER() AS mediana
FROM ventas;

--Q1, Q3 E IQR--
WITH q AS (
  SELECT distinct
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MontoTotal) over() AS q1,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MontoTotal) over() AS q3
  FROM ventas
)
SELECT
  q1, q3,
  (q3 - q1)          AS iqr,
  q1 - 1.5*(q3 - q1) AS limite_inferior,
  q3 + 1.5*(q3 - q1) AS limite_superior
FROM q;
--IQR
WITH q AS (
  SELECT distinct
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MontoTotal) over() AS q1,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MontoTotal) over() AS q3
  FROM ventas 
  )
  select
  q3-q1 as IQR
  from q;

--OUTLINERS
WITH q AS (
  SELECT distinct
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MontoTotal) over() AS q1,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MontoTotal) over() AS q3
  FROM ventas 
)
SELECT v.*
FROM ventas v, q
WHERE v.MontoTotal < q.q1 - 1.5*(q.q3 - q.q1)
   OR v.MontoTotal > q.q3 + 1.5*(q.q3 - q.q1);


   select * from dbo.Ventas