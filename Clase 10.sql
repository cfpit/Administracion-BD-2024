use AdventureWorks

-- subconsultas
-- 54. mostrar el producto mas barato de cada subcategoría. mostrar subcaterogia, codigo de producto y el precio de lista mas barato ordenado por subcategoria 
select	 p1.ProductID 'Codigo de Producto',
		 p1.ListPrice 'Precio de Lista',
		 p1.ProductSubcategoryID 'Codigo de Subcategoria'
from	 Production.Product p1
where	 p1.ListPrice = (
							select  MIN(p2.ListPrice)
							from	Production.Product p2
							where	p1.ProductSubcategoryID = p2.ProductSubcategoryID
						)
order by p1.ProductSubcategoryID

--verificacion
select * from Production.Product order by ProductSubcategoryID

--subconsultas con exists

--55.mostrar los nombres de todos los productos presentes en la subcategoría de ruedas
-- por join
select		p.Name Producto
from		Production.Product p
inner join  Production.ProductSubcategory psc
on			p.ProductSubcategoryID = psc.ProductSubcategoryID
where		psc.Name like '%wheel%'


-- por subconsulta
select		p.Name Producto
from		Production.Product p
where	exists				(
									select 1
									from Production.ProductSubcategory psc
									where psc.ProductSubcategoryID = p.ProductSubcategoryID 
									and	  psc.Name like '%wheel%'
								)

--56.mostrar todos los productos que no fueron vendidos
select		p.Name Producto
from		Production.Product p
where		not exists				(
										select 1
										from	Sales.SalesOrderDetail sod
										where	p.ProductID = sod.ProductID
									)

-- por join
select		p.Name Producto
			--, sod.*
from		Production.Product p
left join	Sales.SalesOrderDetail sod
on			p.ProductID = sod.ProductID
where		sod.SalesOrderID is null


--57. mostrar la cantidad de personas que no son vendedorres 
select		COUNT(*) 'Cantidad de personas que no son vendedoras'
from		Person.Person p
where		not exists				(
										select 1
										from	Sales.SalesPerson sp
										where	p.BusinessEntityID = sp.BusinessEntityID
									)

-- por join
select		COUNT(*) 'Cantidad de personas que no son vendedoras'
from		Person.Person p
left join	Sales.SalesPerson sp
on			p.BusinessEntityID = sp.BusinessEntityID
where		sp.BusinessEntityID is null

--58.mostrar todos los vendedores (nombre y apellido) que no tengan asignado un territorio de ventas 
select		p.FirstName+' '+p.LastName as Vendedor 
from		Person.Person p
inner join	Sales.SalesPerson sp
on			sp.BusinessEntityID = p.BusinessEntityID
where		not exists								(
														select 1
														from	Sales.SalesTerritory st
														where	st.TerritoryID = sp.TerritoryID
													)


-- por join
select		p.FirstName+' '+p.LastName as Vendedor 
from		Person.Person p
inner join	Sales.SalesPerson sp
on			sp.BusinessEntityID = p.BusinessEntityID
left join	Sales.SalesTerritory st
on			st.TerritoryID = sp.TerritoryID
where		st.TerritoryID is null

--subconsultas con in y not on

--59/60. mostrar las ordenes de venta que se hayan facturado en territorio de estado unidos unicamente 'us'.al ejercicio anterior agregar ordenes de francia e inglaterra 
--por subconsulta
select	*
from	Sales.SalesOrderHeader soh
where	soh.TerritoryID in (
								select  st.TerritoryID
								from	Sales.SalesTerritory st
								-- where	st.CountryRegionCode = 'US'
								where	st.CountryRegionCode in ('US','FR','GB')
							)

-- por join
select		*
from		Sales.SalesOrderHeader soh
inner join  Sales.SalesTerritory st
on			soh.TerritoryID = st.TerritoryID
--where		st.CountryRegionCode = 'US'
where	st.CountryRegionCode in ('US','FR','GB')


--61.mostrar los nombres de los diez productos mas caros 
select		p1.Name Producto,
			p1.ListPrice 'Precio de Lista'
from		Production.Product p1
where		p1.ProductID in (
								select		top 10	p2.ProductID
								from				Production.Product p2
								order by			p2.ListPrice desc
							)


-- 62.mostrar aquellos productos cuya cantidad de pedidos de venta sea igual o superior a 20 
select		p1.Name Producto,
			p1.ListPrice 'Precio de Lista'
from		Production.Product p1
where		p1.ProductID in (
								select				sod.ProductID
								from				Sales.SalesOrderDetail sod
								where				sod.OrderQty >= 20
							)

-- por join 
select		p.Name Producto,
			p.ListPrice 'Precio de Lista',
			sod.OrderQty cantidad
from		Production.Product p
inner join	Sales.SalesOrderDetail sod
on			p.ProductID = sod.ProductID
where		sod.OrderQty >= 20
order by	3 desc


-- 63. listar el nombre y apellido de los empleados que tienen un sueldo basico de 5000 pesos.no utilizar relaciones  para su resolucion 
select		p.FirstName+' '+p.LastName Empleado
from		Person.Person p
inner join	HumanResources.Employee e
on			e.BusinessEntityID = p.BusinessEntityID
where		e.BusinessEntityID in (
										select	sp.BusinessEntityID	
										from	Sales.SalesPerson sp
										where	sp.Bonus = 5000
								   )