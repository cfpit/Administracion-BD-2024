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

-- Informar la ultima fecha de ingreso de un empleado
select max(HireDate) as 'ultima fecha de ingreso'
from	HumanResources.Employee

-- Informar la cantidad de horas promedio diponibles de vacaciones de todos los empleados
select avg(VacationHours) as 'horas diponibles'
from	HumanResources.Employee

-- Informar cuando nacio la empleada mas añosa
select min(BirthDate) as 'empleada mas añosa'
from	HumanResources.Employee
where	Gender = 'f'

-- Informar la cantidad de bicis de color blanco, rojo o plateado
select	count(ProductID) as cantidad 
from	Production.Product
where	Color in('white','red','silver')

-- informar la sumatoria de precio de todos los
-- productos plateados
select	sum(ListPrice) as total
from	Production.Product as p
where	p.Color = 'silver'

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


-- Agrupar por color la cantidad de productos que esten pintados. Ordenar de mayor a menor. En caso de empate de cantidad, que desempate el color en forma alfabetica. La cantidad debe ser mayor o igual a 20. De todo lo anterior, traer los 3 primeros registros.
select	top 3	Color,
				count(ProductID) cantidad
from			Production.Product
where			color is not null
group by		Color
having			count(ProductID) >= 20
order by		2 desc, 1


-- Listar la cantidad de empleados agrupados por año de nacimiento. 
-- Incluir solo a los nacidos en la decada del 80 y cuya cantidad
-- este entre 10 y 30. Ordenar por año.
select		top 50 percent
			-- top 3 
			year(BirthDate) as [Año de Nacimiento],
			COUNT(BusinessEntityID) cantidad
from		HumanResources.Employee
-- where		year(BirthDate) like '%198[0-9]%'
where		year(BirthDate) between 1980 and 1989
group by	year(BirthDate)
having		COUNT(BusinessEntityID) between 10 and 30
order by	1































