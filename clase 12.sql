-- 69:aumentar un 20% el precio de lista de todos los productos  
UPDATE	Production.Product
SET		ListPrice = ListPrice * 1.2

					


-- 70:aumentar un 20% el precio de lista de los productos del proveedor 1540 
UPDATE	Production.Product 
SET		ListPrice = ListPrice * 1.2
FROM	Production.Product p
INNER JOIN Purchasing.ProductVendor v ON p.ProductID = v.ProductID 
WHERE	 v.BusinessEntityID = 1540

SELECT		ListPrice as Precio
FROM		Production.Product p
INNER JOIN	Purchasing.ProductVendor v ON p.ProductID = v.ProductID 
WHERE		v.BusinessEntityID = 1540



-- 71:agregar un dia de vacaciones a los 10 empleados con mayor antiguedad.
UPDATE HumanResources.Employee
SET VacationHours = VacationHours + 24
FROM (SELECT TOP 10 BusinessEntityID FROM HumanResources.Employee
     ORDER BY HireDate ASC) AS miSubconsulta
WHERE HumanResources.Employee.BusinessEntityID = miSubconsulta.BusinessEntityID;

--verificacion
SELECT TOP 10	VacationHours,*
FROM			HumanResources.Employee e
ORDER BY		HireDate asc




-- 72: eliminar los detalles de compra (purchaseorderdetail) cuyas fechas de 
VENCIMIENTO PERTENEZCAN AL TERCER TRIMESTRE DEL AÑO 2006 
DELETE  
FROM Purchasing.PurchaseOrderDetail
WHERE MONTH(DueDate) between 7 and 9 and YEAR(DueDate)=2006; 



-- 73:quitar registros de la tabla salespersonquotahistory cuando las ventas del año hasta la fecha 
--almacenadas en la tabla salesperson supere el valor de 2500000

DELETE FROM Sales.SalesPersonQuotaHistory 
FROM		Sales.SalesPersonQuotaHistory AS spqh
INNER JOIN	Sales.SalesPerson AS sp
ON			spqh.BusinessEntityID = sp.BusinessEntityID
WHERE		sp.SalesYTD > 2500000.00;




-- bulk copy

-- 74: clonar estructura y datos de los campos nombre ,color y precio de lista de la tabla production.product en una tabla llamada productos 

SELECT	Color,Name,ListPrice
INTO	productos
FROM	Production.Product

SELECT * from productos




-- 75: clonar solo estructura de los campos identificador ,nombre y apellido de la tabla person.person en una tabla llamada personas 

SELECT	BusinessEntityID,FirstName,LastName
INTO	personas
FROM	Person.Person
WHERE	1=2

--drop table dbo.personas
--drop table dbo.productos



-- 76:insertar un producto dentro de la tabla productos.tener en cuenta los siguientes 
--datos: el color de producto debe ser rojo, el nombre debe ser "bicicleta mountain bike" y el precio de lista debe ser de 4000 pesos.

INSERT INTO		productos(Color,Name,ListPrice)
VALUES			('Rojo','Bicicleta Mountain Bike',4000)

select * from productos



-- 77: copiar los registros de la tabla person.person a la tabla personas cuyo identificador este entre 100 y 200 

INSERT INTO	personas
SELECT		BusinessEntityID,FirstName,LastName
FROM		Person.Person
WHERE		BusinessEntityID BETWEEN 100 AND 200

select * from personas




-- 78: aumentar en un 15% el precio de los pedales de bicicleta 

 UPDATE productos 
 SET ListPrice=ListPrice*1.15
 WHERE name like'%pedal%'
 
 -- verificacion  
 SELECT	* 
 FROM	productos 
 WHERE	name like'%pedal%'
 
 


-- 79: eliminar de las personas cuyo nombre empiecen con la letra m

DELETE	FROM personas 
WHERE	firstname like 'm%'

--verificacion
select	*
FROM	personas 
WHERE	FirstName like 'm%'




-- 80: borrar todo el contenido de la tabla productos 

DELETE	
FROM	productos

--verificacion
SELECT	*
FROM	productos



-- 81: borrar todo el contenido de la tabla personas sin utilizar la instrucción delete.

TRUNCATE TABLE personas

drop table productos



-- Variables

/* declaracion, inicializacion e impresion */
declare @nombre as nvarchar(20)
set @nombre = 'Carla'
--select @nombre /*muestra como resultado de query*/
print @nombre/*muestra como mensaje*/

/* condicional if */
declare @nombre as nvarchar(20)
set @nombre = 'Maria'
if (@nombre = 'Juan')
	begin
		print 'Es Juan'
	end
else
	begin
		print 'no es juan'
	end 
 
 /* bucle while */
declare @valor as int
set @valor = 1
while(@valor<=10) 
	begin
		print @valor
		set @valor=@valor+1
	 end
 
/* variable que almacena query */
use pubs
go

declare @maximo as int
declare @minimo as int

select @maximo = max(price),/* por ser mezcla entre query y variable debe ir select NO set*/
       @minimo = min (price)
from titles

select @maximo
select @minimo

/* variables y funciones del sistema */
select @@servername /*variables del sistema*/

select @@max_connections

select getdate()/*funciones del sistema*/


/*
Ejecución de sentencias SQL:
•	Dinámicos
•	Batch
•	Transacción
•	Scripts
*/

--Dinámicos: son generadas durante la ejecución de un script. 
--por ejemplo se puede generar un store procedure con variables para construir una sentencia SELECT que incorpore esas variables

DECLARE @tabla varchar(20), @bd varchar(20)
SET @tabla = 'authors'
SET @bd = 'pubs'
EXECUTE ('USE '+ @bd + ' SELECT * FROM ' + @tabla )

--Ejemplo:

DECLARE @tabla varchar(20), @bd varchar(20),@campo varchar(20),@funcion varchar (20)
set @funcion='avg(price)'
set @campo='type'
SET @tabla = 'sales'
SET @bd = 'pubs'

if(@tabla = 'titles')
	begin
		EXECUTE ('USE '+ @bd + ' SELECT '+ @campo + @funcion +'promedio '  +' FROM ' + @tabla+' GROUP BY '+@campo )
	end
	
else
	begin
		set @funcion='sum(qty)'
		set @campo='stor_id'
		SET @tabla = 'sales'
		EXECUTE ('USE '+ @bd + ' SELECT '+ @campo+' tienda, '+@funcion +'ventas '  +' FROM ' + @tabla+' GROUP BY '+@campo )
	end



--Batch: ejecución de varias sentencias juntas.
--mejoran el performance de SQL Server debido a que compila y ejecuta todo junto


SELECT MAX(price) AS 'Máximo precio'
FROM titles
PRINT ''
SELECT MIN(price) AS 'Menor precio' 
FROM titles
PRINT ''
SELECT AVG(price) AS 'Precio promedio'
FROM titles
GO

--Transacciones: se ejecutan como un bloque
--si alguna sentencia falla, no se ejecuta nada del bloque

BEGIN TRAN
			update clientes
			set categoria=categoria+1
			where nombre='carlos'
COMMIT TRANSACTION --rollback transacction deshace la operacion


--Clausulas try catch:permite manejar de modo seguro transacciones

BEGIN TRY
			PRINT 'Continuo OK';
END TRY
BEGIN CATCH
			RAISERROR('mensaje de error',16,1)
			--Eleva un error a la aplicación o batch que lo llamo 
			--RAISERROR ( { msg_id | msg_str } { , severidad , estado }  ] 
			--msg_id: Número de error en la tabla sysmessages
			PRINT 'fallo el proceso'
END CATCH


--try catch con transacciones

create database dml
go
use dml


create table clientes(
						codigo int identity(1,1),
						nombre varchar(40) not null,
						dni int not null unique,
						sexo char(1) not null default 'F',
						categoria int not null check (categoria between 1 and 10) 
  
						);
						

select * from clientes

insert into clientes (nombre,dni,sexo,categoria)
values	('carlos',25765981,'M',6)

insert into clientes (nombre,dni,sexo,categoria)
values	('jose',24578965,'M',3)

insert into clientes (nombre,dni,categoria)
values	('maria',19653827,8)

insert into clientes (nombre,dni,categoria)
values	('mariana',20123456,5)


BEGIN TRY
		BEGIN TRAN
			update clientes
			set categoria=categoria+1
			where nombre='carlos'
		COMMIT TRAN
END TRY
BEGIN CATCH
		ROLLBACK TRAN
		PRINT 'fallo el proceso'
END CATCH

select * from clientes

--Funciones
--funciones escalares

-- devolver todos los libros cuyo precio sea mayor al promedio

use pubs
go

SELECT *
FROM titles
WHERE price > (SELECT avg(price) FROM titles)

CREATE FUNCTION promedio()
returns money
as
BEGIN
		declare @promedio money
		select @promedio=avg(price) from titles
		return @promedio
END

select * from titles where price >dbo.promedio()

drop function promedio

--funcion escalar con pasaje por parametros

CREATE FUNCTION promedio_2(@categoria varchar(30))
returns money
as
BEGIN

		declare @promedio money
		select @promedio=avg(price) from titles where type=@categoria
		return @promedio
END

select * from titles where price > dbo.promedio_2(type)

drop function promedio_2


-- funciones de tabla en linea

alter FUNCTION autoresLibros(@cat varchar(30))
returns table
as
	return (SELECT		a.au_id,
						a.au_fname,
						a.au_lname,
						a.state,
						t.title_id,
						t.type,
						t.price,
						t.pub_id

			FROM		authors a
			INNER JOIN	titleauthor ta
			ON			a.au_id=ta.au_id
			INNER JOIN	titles t
			ON			ta.title_id=t.title_id
			WHERE		t.type = @cat)


SELECT * FROM autoresLibros('business')

drop function autoresLibros

--variables de tipo tabla

declare @t table(codigo int,nombre varchar(200))

insert into @t
select 1,'juan'

insert into @t
select 2,'pepe'

select * from @t


--funciones de multisentencia

CREATE FUNCTION fnMultisentencia()
returns @t table(codigo int,nombre varchar(200))
as
BEGIN

		insert into @t
		select 1,'juan'

		insert into @t
		select 2,'pepe'

		insert into @t
		select 3,'martin'

		return
END

select * from dbo.fnMultisentencia()

drop function fnMultisentencia

--otro ejemplo: totaliza y promedia el precio de una determinada categoria

 CREATE FUNCTION fnMultisentencia2(@cat varchar (30))
 returns @t table(titulo varchar(200), precio money)
  
    BEGIN 
		   insert into @t
		   select title, price
		   from titles 
		   where type = @cat
		   
		   insert into @t
		   select 'Promedio', avg(precio) from @t
		   		   
		   insert into @t 
           select 'Total', sum(precio) from @t
           return		   
    END 

select * from dbo.fnMultisentencia2('business')

drop function fnMultisentencia2


--Procedimientos Almacenados

CREATE PROCEDURE listarLibros
as
BEGIN
	select *
	from titles
END

exec listarLibros

drop procedure listarLibros

--otro
use AdventureWorks2008R2
go

--El siguiente ejemplo muestra como se puede crear un procedimiento que devuelve un
--conjunto de registros de todos los productos que llevan más de un día de fabricación.
CREATE PROC Production.LongLeadProducts
AS
  SELECT Name, ProductNumber, DaysToManufacture
  FROM Production.Product
  WHERE DaysToManufacture >= 1
  ORDER BY DaysToManufacture DESC, Name
GO


--procedimiento con parametros

--El siguiente código agrega un parametro @MinimumLength al procedimiento
--LongLeadProducts Esto permite que la cáusula WHERE sea más flexible, permitiendo a la
--aplicación llamante, definir el tiempo mínimo de fabricación apropiado.

ALTER PROC Production.LongLeadProducts
@MinimumLength int = 1 -- valor por defecto
AS
  IF (@MinimumLength < 0) -- validación
    BEGIN
         RAISERROR('Invalid lead time.', 14, 1)
         RETURN
    END

  SELECT Name, ProductNumber, DaysToManufacture
  FROM Production.Product
  WHERE DaysToManufacture >= @MinimumLength
  ORDER BY DaysToManufacture DESC, Name


/*Metadatos*/

/*para ver el diccionario de datos de la base*/
select *
from sys.tables

/*muestra todos los procedimientos generados en la BD*/
select *
from sys.procedures

/*muestra las bases*/
select *
from sys.databases

/*muestra todos los mensajes de la base*/
select *
from sys.messages

/*muestra todos los objetos de la base*/
select *
from sys.objects