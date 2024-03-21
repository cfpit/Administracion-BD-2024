-- Funciones de Agrupacion
use AdventureWorks

-- Listar la primer fecha de ingreso de un empleado
select	MIN(HireDate) as [primer fecha de ingreso] 
from	HumanResources.Employee

-- Listar el maximo peso de todos los productos fabricados
select	MAX(Weight) as 'Maximo Peso'
from	Production.Product

-- Informar la cantidad de horas promedio de vacaciones 
-- de todos los hombres.
select	AVG(VacationHours) as 'Cantidad de horas promedio'
from	HumanResources.Employee
where	Gender = 'M'

-- Informar la cantidad de  productos de color amarillo
select	COUNT(ProductID) as cantidad
from	Production.Product
where	Color = 'yellow'

-- Informar la sumatoria de precios de todos los 
-- productos cuyo precio este entre 500 y 1000 U$s
select	SUM(ListPrice) sumatoria
from	Production.Product
where	ListPrice between 500 and 1000

-- Todas las funciones de agrupacion en una unica query
select	max(ListPrice)  maximo
		,min(ListPrice) minimo
		,round(avg(ListPrice),2) promedio
		,sum(ListPrice) total
		,count(ProductID) cantidad
from	Production.Product

-- Agrupaciones
-- Listar la cantidad de productos agrupados por color. No
-- incluir los que no tengan definido el color. Ordenar por
-- cantidad
select		Color,
			COUNT(ProductID) cantidad
from		Production.Product
where		Color is not null
group by	Color
order by	2 desc


-- Listar la cantidad de empleados agrupados por año de nacimiento. 
-- Incluir solo a los nacidos en la decada del 80. Ordenar por 
-- año.
select		year(BirthDate),
			COUNT(BusinessEntityID) cantidad
from		HumanResources.Employee
where		year(BirthDate) like '%198[0-9]%'
group by	year(BirthDate)
order by	1































