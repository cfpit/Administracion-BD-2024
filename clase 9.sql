-- Test de Existencia. Clausula EXISTS
use pubs

-- listar las editoriales que no publicaron libros
-- tabla ppal: publishers
select	p.pub_name editorial
		--, t.*
from	titles t right join publishers p
on		t.pub_id = p.pub_id
where	t.title_id is null

-- por subconsulta 
select	*
from	publishers p
where	not exists  (
						select  1
						from	titles t
						where	t.pub_id = p.pub_id
					)

-- listar los autores que no escribieron libros de negocio
-- por subconsulta
select		*
from		authors a
inner join	titleauthor ta 
on			a.au_id = ta.au_id
where		not exists	(
							select	1
							from	titles t
							where	t.title_id = ta.title_id
							and		t.type like '%busi%'
						)

-- por join
select		a.au_fname+' '+a.au_lname autor
from		authors a
inner join	titleauthor ta 
on			a.au_id = ta.au_id
inner join	titles t 
on			t.title_id = ta.title_id
where		t.type <> 'business'

-- listar los libros que nunca se vendieron
select	*
from	titles t
where	not exists  (
						select  1
						from	sales s
						where	t.title_id = s.title_id
					)

--Expresion case
--67.listar el nombre de los productos, el nombre de la subcategoria a la que pertenece junto a su categoría de precio. La categoría de precio se calcula de la siguiente manera.
	--si el precio está entre 0 y 1000 la categoría es económica.
	--si la categoría está entre 1000 y 2000, normal 
	--y si su valor es mayor a 2000 la categoría es cara. 
use [AdventureWorks]

select		p.Name as Producto,
			psc.Name as Subcategoria,
			p.ListPrice as Precio,
			(case 
				when ListPrice < 1000 then 'economica'
				when ListPrice between 1000 and 2000 then 'normal'
				when ListPrice > 2000 then 'cara'
				else 'Sin categorizar'
			end) as categoria
from		Production.Product p
inner join	Production.ProductSubcategory psc
on			p.ProductSubcategoryID = psc.ProductSubcategoryID


--68.tomando el ejercicio anterior, mostrar unicamente aquellos productos cuya categoria sea "economica"
SELECT		*
FROM		(	select		p.Name as Producto,
							psc.Name as Subcategoria,
							p.ListPrice as Precio,
							(case 
								when ListPrice < 1000 then 'economica'
								when ListPrice between 1000 and 2000 then 'normal'
								when ListPrice > 2000 then 'cara'
								else 'Sin categorizar'
							end) as categoria
				from		Production.Product p
				inner join	Production.ProductSubcategory psc
				on			p.ProductSubcategoryID = psc.ProductSubcategoryID
			) as misubconsulta
WHERE		misubconsulta.categoria = 'economica'
ORDER BY	misubconsulta.Precio desc