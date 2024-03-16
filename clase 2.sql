-- queries simples y condicionadas
use AdventureWorks

SELECT Name as Biciparte
	  ,Color 
	  ,ListPrice as [Precio de Lista]
      ,Size as Tamaño
	  ,Weight as Peso
      ,DaysToManufacture 'Dias de Fabricacion'
      
FROM  Production.Product

SELECT Name as Biciparte
	  ,Color 
	  ,ListPrice as [Precio de Lista]
	  ,ListPrice * 1.21 as 'Precio de Lista con IVA'
	  ,'Esto es un comentario' as Comentario
	  , 2 * 3 as Cuenta
      ,Size as Tamaño
	  ,Weight as Peso
      ,DaysToManufacture 'Dias de Fabricacion'
      
FROM  Production.Product

-- Filtros. Uso de Clausula WHERE
SELECT	*
FROM	Production.Product
-- WHERE	ListPrice >= 500 and ListPrice <= 1000
-- WHERE	ListPrice between 500 and 1000
-- WHERE	not ListPrice between 500 and 1000
-- WHERE	ListPrice >= 500 and Color in ('Red','Silver','Green')
WHERE	ListPrice >= 500 
AND		Color in ('Red','Silver','Green')
AND		Name not like '%Frame%'

-- Listar los empleados que ingresaron a trabajar en el año 2002
SELECT	*
FROM	HumanResources.Employee
-- WHERE	HireDate like '%2002%'
-- WHERE	HireDate like '%200[2-4]%' -- 2002 al 2004
-- WHERE	HireDate like '%200[2,7]%' -- 2002 o 2007
-- WHERE	HireDate like '%200[^2]%' -- que NO sea 2002 
-- WHERE	HireDate like '%200[^2-4]%' -- que NO sea del 2002 al 2004
-- WHERE	HireDate like '%200[^2,7]%' -- que NO sea ni 2002 ni 2007
WHERE	year(HireDate) = 2002 -- solo año 2002

-- Listar las personas cuyo nombre empiece con m
-- el 2do caracter sea cualquiera, el 3er caracter
-- sea r y no importe como sigue
SELECT	* 
FROM	Person.Person
WHERE	FirstName like 'm_r%'

-- Ordenamiento
-- Ordenar los productos por precio descendente. 
-- En caso de empate en precio, que desempate el nombre
-- en orden alfabetico
SELECT		* 
FROM		Production.Product
-- ORDER BY	ListPrice DESC, Name
ORDER BY	10 DESC, 2


SELECT		Name Biciparte
		   ,ListPrice 'Precio de Lista'
		   ,Color 
FROM		Production.Product
ORDER BY	2 DESC, 1


-- clausula TOP
-- De la ultima query, traer los 50 primeros registros
SELECT		TOP 50	Name Biciparte
					,ListPrice 'Precio de Lista'
					,Color 
FROM				Production.Product
ORDER BY			2 DESC, 1


-- Listar la mitad de los empleados
SELECT	TOP 50 PERCENT	*
FROM					HumanResources.Employee

-- operador is null 
--Listar los productos que no esten pintados
SELECT	* 
FROM	Production.Product
-- WHERE	Color is null
WHERE	Color is not null

-- funcion isnull
SELECT	Name Biciparte
		,isnull(ListPrice , 0) 'Precio de Lista'
		,isnull(Color, 'Sin Pintar') 
		
FROM	Production.Product

-- clausula distinct
SELECT	JobTitle 'Puesto de Trabajo'
FROM	HumanResources.Employee -- se repiten los valores

SELECT	distinct (JobTitle) 'Puesto de Trabajo'
FROM	HumanResources.Employee -- NO se repiten los valores











