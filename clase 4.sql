create database empresa
go
use empresa

create table sucursales(suc_id int, suc_nombre varchar(20))
create table empleados(emp_id int, emp_nombre varchar(20),suc_id int)
go

insert into sucursales values(1,'Centro'),(2,'Congreso'),
(3,'Caballito'),(4,'Palermo')

insert into empleados values(1,'Juan',1),(2,'Jose',2),
(3,'Carlos',2),(4,'Maria',null)
go

select * from sucursales
select * from empleados

-- inner join
-- listar las sucursales y los empleados que en ellas trabajan
select		s.suc_nombre as sucursal,
			e.emp_nombre as empleado
from		empleados e
inner join	sucursales s
on			e.suc_id = s.suc_id

-- variante
select		s.suc_nombre as sucursal,
			e.emp_nombre as empleado
from		empleados e
join		sucursales s
on			e.suc_id = s.suc_id

-- variante no ANSI
select		s.suc_nombre as sucursal,
			e.emp_nombre as empleado
from		empleados e, sucursales s
where		e.suc_id = s.suc_id

-- producto cartesiano
select		s.suc_nombre as sucursal,
			e.emp_nombre as empleado
from		empleados e, sucursales s

-- variante ANSI
select		s.suc_nombre as sucursal,
			e.emp_nombre as empleado
from		empleados e
cross join	sucursales s

-- outer join
-- listar los empleados q no trabajan en ninguna sucursal
-- tabla ppal: empleados
select	e.emp_nombre as empleado
		--,s.*
from	empleados e left outer join sucursales s
on		s.suc_id = e.suc_id
where	s.suc_id is null

-- listar las sucursales q no tienen empleados
select	s.suc_nombre as sucursal
		--,e.*
-- from	empleados e right outer join sucursales s
from	sucursales s left join empleados e
on		s.suc_id = e.suc_id
where	e.emp_id is null

-- full join = left + right
select		* 
from		empleados e 
full join	sucursales s
on			s.suc_id = e.suc_id

-- multiples joins
use pubs

-- listar el nombre y apellido de los autores que escribieron libros de cocina. Informar cuando se publicaron y que editorial lo hizo.
select		a.au_fname + ' ' + a.au_lname as autor,
			t.pubdate as [fecha de publicacion],
			p.pub_name as editorial
from		authors a
inner join	titleauthor ta on a.au_id = ta.au_id
inner join	titles t on ta.title_id = t.title_id
inner join	publishers p on p.pub_id = t.pub_id

where		t.type like '%cook%'







