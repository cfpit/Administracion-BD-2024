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


--update

update clientes2 
set categoria=7,dni=23456789
where codigo=1

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

use editoriales
go

 update libros set precio=precio*1.1
 from libros l
 inner join editoriales e
 on l.editorial_id=e.editorial_id
 and e.nombre='Algodata Infosystems';

select * from libros where editorial_id=1389

select * from editoriales



-- vistas: tabla virtual sobre las que se pueden realizar consultas

CREATE VIEW librosautores
AS
SELECT	a.autor_id,
		a.nombre,
		a.apellido,
		a.provincia,
		l.libro_id,
		l.categoria,
		l.precio,
		l.editorial_id

FROM	autores a
INNER JOIN libroautor la
ON		a.autor_id=la.autor_id
INNER JOIN libros l
ON		la.libro_id=l.libro_id

select * from librosautores

ALTER VIEW librosautores
AS
SELECT	a.autor_id,
		a.nombre,
		a.apellido,
		
		l.libro_id,
		l.categoria,
		l.precio
		

FROM	autores a
INNER JOIN libroautor la
ON		a.autor_id=la.autor_id
INNER JOIN libros l
ON		la.libro_id=l.libro_id



select * from librosautores

drop view librosautores


