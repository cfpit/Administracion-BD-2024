create database dml
go
use dml


create table clientes(
						codigo int primary key identity(1,1),
						nombre varchar(40) not null,
						dni int not null unique,
						sexo char(1) not null default 'F',
						categoria int not null check (categoria between 1 and 10) 
  
						);
						

select * from clientes	

select *
into clientes2
from clientes

--generacion de la estructura de la tabla pero sin los datos

select *
into clientes3
from clientes
where 1=2  --false no carga los datos

select * from clientes
select * from clientes2
select * from clientes3		

--drop table clientes2

--insert

--simple

--variante 1
insert into clientes (nombre,dni,sexo,categoria)
values	('carlos',25765981,'M',6)

insert into clientes (nombre,dni,sexo,categoria)
values	('jose',24578965,'M',3)

insert into clientes (nombre,dni,categoria)
values	('maria',19653827,8)

insert into clientes (nombre,dni,categoria)
values	('mariana',20123456,5)

--variante 2 (todos los registros deben tener la misma cantidad de columnas)
insert into clientes (nombre,dni,sexo,categoria)
values	('carlos',25765981,'M',6),
		('jose',24578965,'M',3),
		('maria',19653827,'F',8),
		('mariana',20123456,'F',5);

-- no cumple restriccion(constraint) check	

--insert into clientes (nombre,dni,categoria)
--values ('maria',9653827,18)

--no cumple restriccion unique

--insert into clientes (nombre,dni,categoria)
--values ('jorge',24578965,9)



--multiple
insert into clientes3(nombre,dni,sexo,categoria)
select nombre,convert(varchar(8),dni),sexo,categoria -- cast(dni as varchar(8))
from clientes
where codigo>2

--clonacion de tablas

--full
select *
into clientes4
from clientes

--partial

select codigo,nombre
into clientes5
from clientes


select * from clientes5


--update

update clientes2 
set categoria=7,dni=23456789
where codigo=1

select * from clientes2

update clientes2
set categoria=categoria+1
where nombre='carlos'

--delete

delete from clientes2
where codigo=2

delete from clientes2 --delete masivo no borra la tabla solo todos los registros

truncate table clientes2 --no trabaja con transacciones es mas rapido que delete

drop table clientes4 --borra la tabla

--combinaciones con update 

use pubs
go

 update titles set price = price * 1.1
 from titles t
 inner join publishers p
 on t.pub_id=p.pub_id
 and p.pub_name = 'Algodata Infosystems';

select * from titles where pub_id = 1389

select * from publishers



-- vistas: tabla virtual sobre las que se pueden realizar consultas

CREATE VIEW librosautores
AS
SELECT		a.au_id,
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
ON			t.title_id=ta.title_id

select * from librosautores

ALTER VIEW librosautores
AS
SELECT		a.au_id,
			a.au_fname,
			a.au_lname,
			t.title_id,
			t.type,
			t.price
FROM		authors a
INNER JOIN	titleauthor ta
ON			a.au_id=ta.au_id
INNER JOIN	titles t
ON			t.title_id=ta.title_id

select * from librosautores

drop view librosautores

-- Expresion CASE
--67.listar el nombre de los productos, el nombre de la subcategoria a la que pertenece junto a su categoría de precio. La categoría de precio se calcula de la siguiente manera.
--	-si el precio está entre 0 y 1000 la categoría es económica.
--	-si la categoría está entre 1000 y 2000, normal 
--	-y si su valor es mayor a 2000 la categoría es cara. 
use [AdventureWorks]

select		p.Name as Producto,
			ps.Name as Subcategoria,
			p.ListPrice as Precio,
			case 
				when ListPrice < 1000 then 'Economica'
				when ListPrice between 1000 and 2000 then 'Normal'
				when ListPrice > 2000 then 'Cara'
				else 'Sin Categorizar'
			end as Categoria
from		Production.Product p
inner join	Production.ProductSubcategory ps
on			ps.ProductSubcategoryID = p.ProductSubcategoryID

--68.tomando el ejercicio anterior, mostrar unicamente aquellos productos cuya categoria sea "economica"
SELECT		*
FROM		(
				select		p.Name as Producto,
							ps.Name as Subcategoria,
							p.ListPrice as Precio,
							case 
								when ListPrice < 1000 then 'Economica'
								when ListPrice between 1000 and 2000 then 'Normal'
								when ListPrice > 2000 then 'Cara'
								else 'Sin Categorizar'
							end as Categoria
				from		Production.Product p
				inner join	Production.ProductSubcategory ps
				on			ps.ProductSubcategoryID = p.ProductSubcategoryID
			) as miSubconsulta
WHERE		miSubconsulta.Categoria = 'Economica'



