--MERGE(combinar)

--En SQL Server, se pueden realizar operaciones de inserción, actualización o eliminación en una sola instrucción utilizando 
--la instrucción MERGE. La instrucción MERGE le permite combinar un origen de datos con una tabla o vista de destino y, a continuación,
-- realizar varias acciones con el destino según los resultados de esa combinación. Por ejemplo, puede utilizar la instrucción MERGE 
-- para realizar las operaciones siguientes:

--Condicionalmente insertar o actualizar filas en una tabla de destino.

--•	Si la fila existe en la tabla de destino, actualizar una o varias columnas; de lo contrario, insertar los datos en una fila nueva.

--•	Sincronizar dos tablas.

--•	Insertar, actualizar o eliminar filas en una tabla de destino según las diferencias con los datos de origen.

--•	La sintaxis de MERGE está compuesta de cinco cláusulas principales:

--•	La cláusula MERGE especifica la tabla o vista que es el destino de las operaciones de inserción, actualización o eliminación.

--•	La cláusula USING especifica el origen de datos que va a combinarse con el destino.

--•	La cláusula ON especifica las condiciones de combinación que determinan las coincidencias entre el destino y el origen.

--•	Las cláusulas WHEN (WHEN MATCHED, WHEN NOT MATCHED BY TARGET y WHEN NOT MATCHED BY SOURCE) especifican las acciones que se van 
--a llevar a cabo según los resultados de la cláusula ON y cualquier criterio de búsqueda adicional especificado en las cláusulas WHEN.

--•	La cláusula OUTPUT devuelve una fila por cada fila del destino que se inserta, actualiza o elimina.

USE tempdb;
GO
CREATE TABLE dbo.Target(EmployeeID int, EmployeeName varchar(10), 
     CONSTRAINT Target_PK PRIMARY KEY(EmployeeID));
CREATE TABLE dbo.Source(EmployeeID int, EmployeeName varchar(10), 
     CONSTRAINT Source_PK PRIMARY KEY(EmployeeID));
GO
INSERT dbo.Target(EmployeeID, EmployeeName) VALUES(100, 'Mary');
INSERT dbo.Target(EmployeeID, EmployeeName) VALUES(101, 'Sara');
INSERT dbo.Target(EmployeeID, EmployeeName) VALUES(102, 'Stefano');

GO
INSERT dbo.Source(EmployeeID, EmployeeName) Values(103, 'Bob');
INSERT dbo.Source(EmployeeID, EmployeeName) Values(104, 'Steve');
GO


select * from source
select * from target

drop table Source
drop table Target

-- MERGE statement with the join conditions specified correctly.
USE tempdb;
go
MERGE Target AS T
USING Source AS S
ON (T.EmployeeID = S.EmployeeID) 
WHEN NOT MATCHED BY TARGET AND S.EmployeeName LIKE 'S%' 
    THEN INSERT(EmployeeID, EmployeeName) VALUES(S.EmployeeID, S.EmployeeName)
WHEN MATCHED 
    THEN UPDATE SET T.EmployeeName = S.EmployeeName
WHEN NOT MATCHED BY SOURCE AND T.EmployeeName LIKE 'S%'
    THEN DELETE 
OUTPUT $action, inserted.*, deleted.*;

GO 

select * from source
select * from target


--PIVOT UNPIVOT

--Puede usar los operadores relacionales PIVOT y UNPIVOT para modificar una expresión 
--con valores de tabla en otra tabla. PIVOT gira una expresión con valores de tabla 
--convirtiendo los valores únicos de una columna de la expresión en varias columnas 
--en la salida y realiza agregaciones donde son necesarias en cualquier valor de columna 
--restante que se desee en la salida final. UNPIVOT realiza la operación contraria a 
--PIVOT girando las columnas de una expresión con valores de tabla a valores de columna.



--Ejemplo PIVOT básico


USE AdventureWorks2008R2 ;
GO
SELECT DaysToManufacture, AVG(StandardCost) AS AverageCost 
FROM Production.Product
GROUP BY DaysToManufacture;

--No hay productos definidos con tres DaysToManufacture.

--En el código siguiente se muestra el mismo resultado, dinamizado para que los valores 
--de DaysToManufacture se conviertan en encabezados de columna. Se proporciona una columna 
--para tres [3] días, aunque los resultados son NULL.


-- Pivot table with one row and five columns
SELECT 'AverageCost' AS Cost_Sorted_By_Production_Days, 
[0], [1], [2], [3], [4]
FROM
(SELECT DaysToManufacture, StandardCost 
    FROM Production.Product) AS SourceTable
PIVOT
(
AVG(StandardCost)
FOR DaysToManufacture IN ([0], [1], [2], [3], [4])
) AS PivotTable;


--Un escenario habitual en el que PIVOT puede ser útil es cuando se desea generar 
--informes de tabla cruzada para resumir datos. Por ejemplo, suponga que desea consultar 
--la tabla PurchaseOrderHeader en la base de datos de ejemplo AdventureWorks para determinar 
--el número de pedidos de compra colocados por ciertos empleados. En la siguiente consulta 
--se proporciona este informe, ordenado por proveedor.

USE AdventureWorks2008R2;
GO
SELECT VendorID, [250] AS Emp1, [251] AS Emp2, [256] AS Emp3, [257] AS Emp4, [260] AS Emp5
FROM 
(SELECT PurchaseOrderID, EmployeeID, VendorID
FROM Purchasing.PurchaseOrderHeader) p
PIVOT
(
COUNT (PurchaseOrderID)
FOR EmployeeID IN
( [250], [251], [256], [257], [260] )
) AS pvt
ORDER BY pvt.VendorID;

--Los resultados devueltos por esta instrucción de subselección se dinamizan en la 
--columna EmployeeID.

SELECT PurchaseOrderID, EmployeeID, VendorID
FROM Purchasing.PurchaseOrderHeader
--Esto significa que los valores únicos devueltos por la columna EmployeeID se convierten 
--en campos del conjunto de resultados finales. Por lo tanto, hay una columna para cada 
--número de EmployeeID especificado en la cláusula dinámica: en este caso empleados 
--164, 198, 223, 231 y 233. La columna PurchaseOrderID se utiliza como columna de valores,
-- respecto a la que se ordenan las columnas del resultado final, denominadas columnas de
-- agrupamiento. En este caso, las columnas de agrupamiento se agregan mediante la función 
--COUNT. Tenga presente que aparece un mensaje de advertencia que indica que los valores 
--NULL que aparecen en la columna PurchaseOrderID no se tuvieron en cuenta cuando se 
--contabilizó COUNT para cada empleado.


--UNPIVOT

--UNPIVOT realiza casi la operación inversa de PIVOT, girando columnas a filas. Suponga 
--que la tabla producida en el ejemplo anterior se almacena en la base de datos como pvt 
--y que desea girar los identificadores de columna Emp1, Emp2, Emp3, Emp4 y Emp5 a valores 
--de fila que correspondan a un determinado proveedor. Esto significa que debe identificar 
--dos columnas adicionales. La columna que contendrá los valores de columna que se están 
--girando (Emp1, Emp2,...) se denominará Employee y la columna que contendrá los valores 
--que residen actualmente en las columnas que se giran se denominará Orders. Estas columnas 
--corresponden a pivot_column y value_column, respectivamente, en la definición de 
--Transact-SQL. Ésta es la consulta.

--Create the table and insert values as portrayed in the previous example.
CREATE TABLE pvt (VendorID int, Emp1 int, Emp2 int,
    Emp3 int, Emp4 int, Emp5 int);
GO
INSERT INTO pvt VALUES (1,4,3,5,4,4);
INSERT INTO pvt VALUES (2,4,1,5,5,5);
INSERT INTO pvt VALUES (3,4,3,5,4,4);
INSERT INTO pvt VALUES (4,4,2,5,5,4);
INSERT INTO pvt VALUES (5,5,1,5,5,5);
GO
--Unpivot the table.
SELECT VendorID, Employee, Orders
FROM 
   (SELECT VendorID, Emp1, Emp2, Emp3, Emp4, Emp5
   FROM pvt) p
UNPIVOT
   (Orders FOR Employee IN 
      (Emp1, Emp2, Emp3, Emp4, Emp5)
)AS unpvt;
GO


--Tenga en cuenta que UNPIVOT no es exactamente el operador inverso a PIVOT. PIVOT realiza
-- una agregación y, por tanto, combina posibles múltiples filas en una fila única en la 
--salida. UNPIVOT no reproduce el resultado de la expresión con valores de tabla original 
--porque las filas se han combinado. Además, los valores NULL de la entrada de UNPIVOT 
--desaparecen en la salida, mientras que pueden haber sido valores NULL en la entrada 
--antes de la operación PIVOT.
--La vista Sales.vSalesPersonSalesByFiscalYears de la base de datos de ejemplo 
--AdventureWorks utiliza PIVOT para devolver el total de ventas de cada vendedor, 
--para cada año fiscal. Para generar el script de la vista en SQL Server Management 
--Studio, en el Explorador de objetos, localícela en la carpeta Views de la base de 
--datos AdventureWorks. Haga clic con el botón secundario en el nombre de la vista 
--y seleccione Incluir vista como.


-- Modificador de Group By (WITH ROLLUP)

-- Podemos combinar "group by" con el operador "rollup" para generar valores de resumen a la salida.
create database agrupaciones
go 
use agrupaciones

create table personas(
  nombre varchar(30),
  edad tinyint,
  sexo char(1),
  domicilio varchar(30),
  ciudad varchar(20),
  telefono varchar(11),
  montocompra decimal(6,2) not null
);

go

insert into personas
  values ('Susana Molina',28,'f',null,'Buenos Aires',null,45.50); 
insert into personas
  values ('Marcela Mercado',36,'f','Avellaneda 345','Tandil','4545454',22.40);
insert into personas
  values ('Alberto Garcia',35,'m','Gral. Paz 123','Mar del Plata','03547123456',25); 
insert into personas
  values ('Teresa Garcia',33,'f',default,'Tandil','03547123456',120);
insert into personas
  values ('Roberto Perez',45,'m','Urquiza 335','Buenos Aires','4123456',33.20);
insert into personas
  values ('Marina Torres',22,'f','Colon 222','Mar del Plata','03544112233',95);
insert into personas
  values ('Julieta Gomez',24,'f','San Martin 333','Tandil',null,53.50);
insert into personas
  values ('Roxana Lopez',20,'f','null','Tandil',null,240);
insert into personas
  values ('Liliana Garcia',50,'f','Paso 999','Buenos Aires','4588778',48);
insert into personas
  values ('Juan Torres',43,'m','Sarmiento 876','Buenos Aires',null,15.30);

  select * from personas

-- Cantidad de personas por ciudad y el total de personas
select ciudad,
  count(*) as cantidad
  from personas
  group by ciudad with rollup;

  -- variante
  select case when ciudad is null then 'Total' else ciudad end as ciudad,
  count(*) as cantidad
  from personas
  group by ciudad with rollup;

-- Filas de resumen cuando agrupamos por 2 campos, "ciudad" y "sexo":
 select ciudad,sexo,
  count(*) as cantidad
  from personas
  group by ciudad,sexo
  with rollup;

-- Para conocer la cantidad de personas y la suma de sus compras agrupados
-- por ciudad y sexo,
 select ciudad,sexo,
  count(*) as cantidad,
  sum(montocompra) as total
  from personas
  group by ciudad,sexo
  with rollup;

-- El operador "rollup" resume valores de grupos. representan los valores de resumen de la precedente.

-- Tenemos la tabla "personas" con los siguientes campos: nombre, edad, sexo, domicilio, ciudad, telefono, montocompra.

-- Si necesitamos la cantidad de personas por ciudad empleamos la siguiente sentencia:

 select ciudad,count(*) as cantidad
  from personas
  group by ciudad;
  
-- Esta consulta muestra el total de personas agrupados por ciudad; pero si queremos además la cantidad total de personas, debemos realizar otra consulta:

  select count(*) as total
   from personas;

-- Para obtener ambos resultados en una sola consulta podemos usar "with rollup" que nos devolverá ambas salidas en una sola consulta:

 select ciudad,count(*) as cantidad
  from personas
  group by ciudad with rollup;
  
-- La consulta anterior retorna los registros agrupados por ciudad y una fila extra en la que la primera columna contiene "null" y la columna con la cantidad muestra la cantidad total.

-- La cláusula "group by" permite agregar el modificador "with rollup", el cual agrega registros extras al resultado de una consulta, que muestran operaciones de resumen.

-- Si agrupamos por 2 campos, "ciudad" y "sexo":

 select ciudad,sexo,count(*) as cantidad
  from personas
  group by ciudad,sexo
  with rollup;
  
-- La salida muestra los totales por ciudad y sexo y produce tantas filas extras como valores existen del primer campo por el que se agrupa ("ciudad" en este caso), mostrando los totales para cada valor, con la columna correspondiente al segundo campo por el que se agrupa ("sexo" en este ejemplo) conteniendo "null", y 1 fila extra mostrando el total de todos los visitantes (con las columnas correspondientes a ambos campos conteniendo "null"). Es decir, por cada agrupación, aparece una fila extra con el/ los campos que no se consideran, seteados a "null".

-- Con "rollup" se puede agrupar hasta por 10 campos.

-- Es posible incluir varias funciones de agrupamiento, por ejemplo, queremos la cantidad de visitantes y la suma de sus compras agrupados por ciudad y sexo:

 select ciudad,sexo,
  count(*) as cantidad,
  sum(montocompra) as total
  from personas
  group by ciudad,sexo
  with rollup;
  
-- Entonces, "rollup" es un modificador para "group by" que agrega filas extras mostrando resultados de resumen de los subgrupos. Si se agrupa por 2 campos SQL Server genera tantas filas extras como valores existen del primer campo (con el segundo campo seteado a "null") y una fila extra con ambos campos conteniendo "null".

-- Con "rollup" se puede emplear "where" y "having", pero no es compatible con "all".






--Tablas temporales en SQL Server



--1) Uso: Almacenar datos para usarlos posteriormente, guardar resultados parciales, analizar grandes cantidades de filas.
-- Hay muchos casos en los que podemos necesitar estas tablas temporales


--    Las tablas temporales se crean en tempdb, y al crearlas se producen varios bloqueos sobre esta base de datos como
--     por ejemplo en las tablas sysobjects y sysindex. Los bloqueos sobre tempdb afectan a todo el servidor.
     
--    Al crearlas es necesario que se realicen accesos de escritura al disco ( no siempre si las tablas son pequeñas)
--    Al introducir datos en las tablas temporales de nuevo se produce actividad en el disco, y ya sabemos que el acceso a disco suele ser el "cuello de botella" de nuestro sistema
--    Al leer datos de la tabla temporal hay que recurrir de nuevo al disco. Además estos datos leídos de la tabla suelen
--    combinarse con otros.
    
--    Al borrar la tabla de nuevo hay que adquirir bloqueos sobre la base de datos tempdb y realizar operaciones en disco.
--    Al usar tablas temporales dentro de un procedimiento almacenado perdemos la ventaja de tener compilado el plan de 
--    ejecución de dicho procedimiento almacenado y se producirán recompilaciones más a menudo. Lo mismo pasará cuando el 
--    SQL Server intenta reutilizar el plan de ejecución de una consulta parametrizada. Si en la consulta tenemos una 
--    tabla temporal difícilmente se reutilizará dicho plan de ejecución.



--En vez de tablas temporales podemos mejorar nuestro código para que no sean necesarias, podemos usar subconsultas 
--(normalmente usar una subconsulta mejora drásticamente el rendimiento respecto a usar tablas temporales)


--2) Tipos de tablas temporales

--Las tablas temporales son de dos tipos en cuanto al alcance la tabla. Tenemos tablas temporales locales y tablas 
--temporales globales.

--#locales: Las tablas temporales locales tienen una # como primer carácter en su nombre y sólo se pueden utilizar en 
--la conexión en la que el usuario las crea. Cuando la conexión termina la tabla temporal desaparece.

--##globales Las tablas temporales globales comienzan con ## y son visibles por cualquier usuario conectado al 
--SQL Server. Y una cosa más, estás tablas desaparecen cuando ningún usuario está haciendo referencias a ellas, 
--no cuado se desconecta el usuario que la creo.


--3) Funcionamiento de tablas temporales


--Crear una tabla temporal es igual que crear una tabla normal. 

use tempdb
go

CREATE TABLE #TablaTemporal (Campo1 int, Campo2 varchar(50))

--Y se usan de manera habitual.

INSERT INTO #TablaTemporal VALUES (1,'Primer campo')
INSERT INTO #TablaTemporal VALUES (2,'Segundo campo')

SELECT * FROM #TablaTemporal

--Una limitación es que no pueden tener restricciones FOREING KEY