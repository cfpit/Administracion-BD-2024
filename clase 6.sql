-- self join: es un inner join de una tabla consigo misma. Permite relacionar datos de una misma tabla
use pubs
go

-- Listar los libros que tengan el mismo precio. Informar ambos titulos y el precio.
select		title, price 
from		titles 
order by	price desc

-- alternativa usando self join
select		t1.title as [titulo 1]
			,t2.title as [titulo 2]
			,t1.price as precio
from		titles t1
inner join	titles t2
on			t1.price = t2.price
where		t1.title_id < t2.title_id
order by	t1.price desc

-- Ejercitacion Writing Queries
--22. mostrar las personas cuyo  nombre tenga una c o C como primer caracter, cualquier otro como segundo caracter, ni d ni D ni f ni g como tercer caracter, cualquiera entre j y r o entre s y w como cuarto caracter y el resto sin restricciones 
use [AdventureWorks]
go

select	distinct FirstName as Persona
from	Person.Person
where	FirstName like '[c,C]_[^dDfg][j-r,s-w]%'

-- 24. Mostrar los cinco productos mas caros y su nombre ordenado en forma alfabetica
select		top 5 *
from		Production.Product
order by	listPrice desc, Name

--25. Mostrar la fecha mas reciente de venta 
select	max(orderDate) [fecha mas reciente]
from	Sales.SalesOrderHeader

select	*
from	Sales.SalesOrderHeader
where	OrderDate = (select MAX(OrderDate) from Sales.SalesOrderHeader)

-- 26. Mostrar el precio mas barato de todas las bicicletas
select	min(ListPrice) 
from	Production.Product
where	ProductNumber like 'bk%'

--28. Mostrar los representantes de ventas (vendedores) que no tienen definido el numero de territorio
select	*
from	Sales.SalesPerson
where	TerritoryID is null

--29. Mostrar el peso promedio de todos los articulos. si el peso no estuviese definido, reemplazar por cero
select		avg(isnull(Weight,0))
from		Production.Product

--31. Mostrar los productos y la cantidad total vendida de cada uno de ellos
select		ProductID as producto,
			sum(OrderQty) as [cantidad vendida]
from		Sales.SalesOrderDetail
group by	ProductID
order by	2 desc










