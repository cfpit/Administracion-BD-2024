use [AdventureWorks]

--16. Mostrar las bicicletas de montaña que  cuestan entre $1000 y $1200 
select	* 
from	Production.Product
where	ProductNumber like 'bk%' 
and		ListPrice between 1000 and 1200

--31. Mostrar los productos y la cantidad total vendida de cada uno de ellos
select		ProductID as Producto,
			sum(OrderQty) as 'Cantidad vendida'
from		Sales.SalesOrderDetail
group by	ProductID
order by	2 desc

-- variante con join
select		Name as Producto,
			sum(OrderQty) as 'Cantidad vendida'
from		Sales.SalesOrderDetail sod
inner join	Production.Product p
on			p.ProductID = sod.ProductID
group by	p.Name
order by	2 desc

--33. Mostrar todas las facturas realizadas y el total facturado de cada una de ellas ordenado por numero de factura.
select		ProductID as Producto,
			sum(unitPrice * OrderQty) as 'Total Facturado'
from		Sales.SalesOrderDetail
group by	ProductID
order by	2 desc


--34. Mostrar todas las facturas realizadas y el total facturado de cada una de ellas ordenado por nro de factura pero solo de aquellas ordenes superen un total de $10.000
select		SalesOrderDetailID as [Nro de Factura],
			sum(unitPrice * OrderQty) as 'Total Facturado'
from		Sales.SalesOrderDetail
group by	SalesOrderDetailID
having		sum(unitPrice * OrderQty) > 10000
order by	1

--34BIS. Mostrar todas las facturas realizadas y el total facturado de cada una de ellas ordenado por nro de factura pero solo de aquellas ordenes superen un total de $10.000 
select		p.Name as Producto,
			p.ProductID as Codigo,
			sum(UnitPrice *  OrderQty) 'Total Facturado',
			DATEDIFF(WEEK, p.SellStartDate, p.SellEndDate) as 'Tiempo de Venta en Semanas'
from		Sales.SalesOrderDetail sod
inner join	Production.Product p
on			p.ProductID = sod.ProductID
where		DATEDIFF(WEEK, p.SellStartDate, p.SellEndDate) is not null
group by	p.Name, p.ProductID,DATEDIFF(WEEK, p.SellStartDate, p.SellEndDate) 
having		sum(UnitPrice *  OrderQty) > 10000
order by	4 desc

--35. Mostrar la cantidad de facturas que vendieron mas de 20 unidades 
select		ProductID as Producto,
			sum(OrderQty) as 'Cantidad vendida'
from		Sales.SalesOrderDetail
group by	ProductID
having		sum(OrderQty) > 20
order by	2 desc

--37. Mostrar todos los codigos de categorias existentes junto con la cantidad de productos y el precio de lista promediopor cada uno de aquellos productos que cuestan mas de $70 y el precio promedio es mayor a $300 
select		ProductSubcategoryID [Categoria de Producto],
			count(ProductID) Cantidad,
			avg(ListPrice) Promedio
from		Production.Product
where		ListPrice > 70
group by	ProductSubcategoryID
having		avg(ListPrice) > 300
order by	1

-- JOINS
--39. Mostrar los empleados que también son vendedores 
select		e.*
from		HumanResources.Employee e
inner join	Sales.SalesPerson sp
on			e.BusinessEntityID = sp.BusinessEntityID

--40. Mostrar  los empleados ordenados alfabeticamente por apellido y por nombre 
select		p.FirstName + ' ' + p.LastName as Empleado    
			,e.*
from		HumanResources.Employee e
inner join	Person.Person p
on			e.BusinessEntityID = p.BusinessEntityID
order by	1

--42. Mostrar los productos que sean ruedas 
select		ps.Name as Producto
			,p.*
from		Production.Product p
inner join	Production.ProductSubcategory ps
on			ps.ProductSubcategoryID  = p.ProductSubcategoryID 
where		ps.Name = 'Wheels'
order by	1

--43. Mostrar los nombres de los productos que no son bicicletas 
select		ps.Name as Producto
			,p.*
from		Production.Product p
inner join	Production.ProductSubcategory ps
on			ps.ProductSubcategoryID  = p.ProductSubcategoryID 
where		ps.Name not like '%bike%'
order by	1

-- 44. Mostrar los precios de venta de aquellos  productos donde el precio de venta sea inferior al precio de lista recomendado para ese producto ordenados por nombre de producto
select		p.Name as Producto
			,p.ListPrice as [Precio de Lista]
			,sod.UnitPrice as [Precio Unitario]
from		Production.Product p
inner join	Sales.SalesOrderDetail sod
on			p.ProductID = sod.ProductID
where		sod.UnitPrice < p.ListPrice
order by	1

--49. Mostrar los vendedores (nombre y apellido) y el territorio asignado a c/u(identificador y nombre de territorio). En los casos en que un territorio no tiene vendedores mostrar igual los datos del territorio unicamente sin datos de vendedores
select		p.FirstName + ' ' + p.LastName as Vendedor
			,st.TerritoryID as identificador
			,st.Name as Territorio
from		Sales.SalesTerritory st
left join	Sales.SalesPerson sp
on			st.TerritoryID = sp.TerritoryID
inner join	Person.Person p
on			p.BusinessEntityID = sp.BusinessEntityID

--49 BIS. Mostrar los vendedores (nombre y apellido) y el territorio asignado a c/u(identificador y nombre de territorio). En los casos en que un vendedor no tenga territorio mostrar igual los datos del vendedor unicamente sin datos de territorios
-- tabla ppal: SalesPerson
-- tabla secundaria: SalesTerritory
select		st.TerritoryID 'Identificador de Territorio',
			st.Name as 'Territorio de Venta',
			p.FirstName + ' ' + p.LastName as Vendedor
from		Person.Person p
inner join	Sales.SalesPerson sp
on			p.BusinessEntityID = sp.BusinessEntityID
left join	Sales.SalesTerritory st
on			st.TerritoryID = sp.TerritoryID
where		st.TerritoryID is null

--50. Mostrar el producto cartesiano ente la tabla de vendedores cuyo numero de identificacion de negocio 
--sea 280 y el territorio de venta sea el de francia 
select		sp.BusinessEntityID as [numero de identificacion]
			,st.Name as 'Territorio de venta'
			,sp.*
from		Sales.SalesPerson sp
cross join	Sales.SalesTerritory st
where		st.Name = 'France' and sp.BusinessEntityID = 280


--50 BIS. Mostrar el producto cartesiano ente la tabla de vendedores cuyo numero de identificacion de negocio sea 280 y el territorio de venta sea el de francia 
select		sp.BusinessEntityID as 'Numero de Identificacion',
			st.Name as 'Territorio de Venta',
			p.FirstName + ' ' + p.LastName as Vendedor
from		Sales.SalesPerson sp
inner join	Person.Person p 
on			p.BusinessEntityID = sp.BusinessEntityID
cross join	Sales.SalesTerritory st
where		st.Name = 'France' and sp.BusinessEntityID = 280

use pubs
-- Listar los libros que nunca fueron vendidos
--tabla ppal: titles
--tabla secundaria: sales
select		t.title as libro
			--,s.*
from		titles t 
left join	sales s on t.title_id = s.title_id
where		s.stor_id is null

































