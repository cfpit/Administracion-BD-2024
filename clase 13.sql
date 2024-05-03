-- PROCEDIMIENTOS ALMACENADOS

/*QUERY 82: CREAR UN PROCEDIMIENTO ALMACENADO QUE DADA UNA DETERMINADA INICIAL ,DEVUELVA CODIGO, NOMBRE,APELLIDO Y DIRECCION DE
 CORREO DE LOS EMPLEADOS CUYO NOMBRE COINCIDA CON LA INICIAL INGRESADA*/

CREATE PROCEDURE InformarEmpleadosPorInicial(@inicial char(1))
AS
	BEGIN
		SELECT		BusinessEntityID, FirstName, LastName, EmailAddress
		FROM		HumanResources.vEmployee
		WHERE		FirstName LIKE @inicial + '%'
		ORDER BY	FirstName
	END

GO
EXECUTE InformarEmpleadosPorInicial @inicial='j'


/*QUERY 83: CREAR UN PROCEDIMIENTO ALMACENADO QUE DEVUELVA LOS PRODUCTOS QUE LLEVEN DE FABRICADO LA CANTIDAD DE DIAS QUE LE 
PASEMOS COMO PARAMETRO*/

CREATE PROC TiempoDeFabricacion(@dias int = 1)
AS
  SELECT	Name, ProductNumber, DaysToManufacture
  FROM		Production.Product
  WHERE		DaysToManufacture = @dias
  ORDER BY	DaysToManufacture DESC, Name
  
GO
EXECUTE TiempoDeFabricacion @dias=2

/*QUERY 84: CREAR UN PROCEDIMIENTO ALMACENADO QUE PERMITA ACTUALIZAR Y VER LOS PRECIOS DE UN DETERMINADO 
PRODUCTO QUE RECIBA COMO PARAMETRO*/

CREATE PROCEDURE ActualizarPrecios
(@cantidad as float,@codigo as int)
AS
	BEGIN
		UPDATE Production.Product
		SET price = price*@cantidad
		WHERE ProductID=@codigo

		SELECT Name,ListPrice
		FROM Production.Product
		WHERE ProductID=@codigo
	END

GO
EXECUTE ActualizarPrecios 1.1, 886


/*QUERY 85: ARMAR UN PROCEDIMINETO ALMACENADO QUE DEVUELVA LOS PROVEEDORES QUE PROPORCIONAN EL PRODUCTO 
ESPECIFICADO POR PARAMETRO. */

CREATE PROCEDURE Proveedores(@producto varchar(30)='%')
AS
    
    SELECT		v.Name proveedor,
				p.Name producto 
    
    FROM		Purchasing.Vendor AS v 
    INNER JOIN	Purchasing.ProductVendor AS pv
    ON			v.BusinessEntityID = pv.BusinessEntityID 
    INNER JOIN	Production.Product AS p 
    ON			pv.ProductID = p.ProductID 
    WHERE		p.Name LIKE @producto
    ORDER BY	v.Name 
GO    

EXECUTE Proveedores 'r%'
GO
EXECUTE Proveedores 'reflector'


/*QUERY 86: CREAR UN PROCEDIMIENTO ALMACENADO QUE DEVUELVA NOMBRE,APELLIDO Y SECTOR DEL EMPLEADO QUE LE 
PASEMOS COMO ARGUMENTO.NO ES NECESARIO PASAR EL NOMBRE Y APELLIDO EXACTOS AL PROCEDIMIENTO.*/
 
CREATE PROCEDURE empleados
    @apellido nvarchar(50)='%', 
    @nombre nvarchar(50)='%' 
AS 
	SELECT FirstName, LastName,Department
    FROM HumanResources.vEmployeeDepartmentHistory
    WHERE FirstName LIKE @nombre AND LastName LIKE @apellido
GO

EXECUTE empleados  'eric%' 




--FUNCIONES ESCALARES

/*QUERY 87:ARMAR UNA FUNCION QUE DEVUELVA LOS PRODUCTOS QUE ESTAN POR ENCIMA DEL PROMEDIO DE PRECIOS GENERAL*/

CREATE FUNCTION promedio()
RETURNS MONEY
AS
BEGIN
		DECLARE @promedio MONEY
		SELECT @promedio=AVG(ListPrice) FROM Production.Product
		RETURN @promedio
END


--uso de la funcion
SELECT	* 
FROM	Production.Product 
WHERE	ListPrice >dbo.promedio()

SELECT AVG(ListPrice) FROM Production.Product --438.6662


/*QUERY 88:ARMAR UNA FUNCIÓN QUE DADO UN CÓDIGO DE PRODUCTO DEVUELVA EL TOTAL DE VENTAS PARA DICHO PRODUCTO.
LUEGO, MEDIANTE UNA CONSULTA, TRAER CODIGO, NOMBRE Y TOTAL DE VENTAS ORDENADOS POR ESTA ULTIMA COLUMNA*/

CREATE FUNCTION VentasProductos(@codigoProducto int) 
RETURNS int
AS
 BEGIN
   DECLARE @total int
   SELECT @total = SUM(OrderQty)
   FROM Sales.SalesOrderDetail WHERE ProductID = @codigoProducto
   IF (@total IS NULL)
      SET @total = 0
   RETURN @total
 END
 
--uso de la funcion
SELECT		ProductID "codigo producto",
			Name nombre,
			dbo.VentasProductos(ProductID) AS "total de ventas"
FROM		Production.Product
ORDER BY	3 DESC




--FUNCIONES DE TABLA EN LINEA


/*QUERY 89:ARMAR UNA FUNCIÓN QUE DADO UN AÑO , DEVUELVA NOMBRE Y  APELLIDO DE LOS EMPLEADOS 
QUE INGRESARON ESE AÑO */

CREATE FUNCTION AñoIngresoEmpleados (@año int)
RETURNS TABLE
AS
	RETURN
	(
		SELECT FirstName, LastName,HireDate
		FROM Person.Person p
		INNER JOIN HumanResources.Employee e
		ON e.BusinessEntityID= p.BusinessEntityID
		WHERE year(HireDate)=@año
	)
	
--uso de la funcion
SELECT * FROM dbo.AñoIngresoEmpleados(2004)

/*QUERY 90:ARMAR UNA FUNCIÓN QUE DADO EL CODIGO DE NEGOCIO CLIENTE DE LA FABRICA, DEVUELVA EL CODIGO, NOMBRE Y LAS VENTAS DEL 
AÑO HASTA LA FECHA PARA CADA PRODUCTO VENDIDO EN EL NEGOCIO ORDENADAS POR ESTA ULTIMA COLUMNA. */

CREATE FUNCTION VentasNegocio (@codNegocio int)
RETURNS TABLE
AS
RETURN 
(
    SELECT P.ProductID, P.Name, SUM(SD.LineTotal) AS 'Total'
    FROM Production.Product AS P 
    JOIN Sales.SalesOrderDetail AS SD ON SD.ProductID = P.ProductID
    JOIN Sales.SalesOrderHeader AS SH ON SH.SalesOrderID = SD.SalesOrderID
    JOIN Sales.Customer AS C ON SH.CustomerID = C.CustomerID
    WHERE C.StoreID = @codNegocio
    GROUP BY P.ProductID, P.Name
    
)

--uso de la funcion
SELECT		* 
FROM		dbo.VentasNegocio (1340)
ORDER BY	3 DESC;



--FUNCIONES DE MULTI SENTENCIA
	
/*QUERY 91: CREAR UNA  FUNCIÓN LLMADA "OFERTAS" QUE RECIBA UN PARÁMETRO CORRESPONDIENTE A UN PRECIO Y NOS RETORNE UNA 
TABLA CON CÓDIGO,NOMBRE, COLOR Y PRECIO DE TODOS LOS PRODUCTOS CUYO PRECIO SEA INFERIOR AL PARÁMETRO INGRESADO*/


 CREATE FUNCTION ofertas(@minimo decimal(6,2))
 RETURNS @oferta table
 (codigo int,
  nombre varchar(40),
  color varchar(30),
  precio decimal(6,2)
 )
 AS
	 BEGIN
	    INSERT @oferta
		SELECT	ProductID,Name,Color,ListPrice
		FROM	Production.Product
		WHERE	ListPrice<@minimo
	    RETURN
	 END

--uso de la funcion

 SELECT *
 FROM	dbo.ofertas(5000)
 
 
 -- DATETIME


/*QUERY 92: MOSTRAR LA CANTIDAD DE HORAS QUE TRANSCURRIERON DESDE EL COMIENZO DEL AÑO*/

SELECT DATEDIFF(HOUR, '01-01-2024',GETDATE())


/*QUERY 93: MOSTRAR LA CANTIDAD DE DIAS TRANSCURRIDOS ENTRE LA PRIMER Y LA ULTIMA VENTA */

SELECT	DATEDIFF(DAY,(SELECT MIN(OrderDate)FROM Sales.SalesOrderHeader),
					 (SELECT MAX(OrderDate) FROM Sales.SalesOrderHeader))
 
 
 
 
 
 
 
 
 
 
 
 