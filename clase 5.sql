-- consultas relacionadas
create database comercio
go
use comercio
go

create table sucursales(suc_id int, suc_nombre varchar(20))
create table empleados(emp_id int, emp_nombre varchar(20),suc_id int)

go

insert into sucursales values(1,'Centro'),(2,'Congreso'),(3,'Caballito'),(4,'Palermo')

insert into empleados values(1,'Juan',1),(2,'Jose',2),(3,'Carlos',2),(4,'Maria',null)

go

select * from sucursales
select * from empleados

use master

-- inner join
-- listar el nombre de las sucursales y de los empleados 
select		s.suc_nombre as sucursal,
			e.emp_nombre empleado
from		sucursales s
-- inner join	empleados e
join		empleados e
on			s.suc_id = e.suc_id

-- no ANSI
select		s.suc_nombre as sucursal,
			e.emp_nombre empleado
from		sucursales s, empleados e
where		s.suc_id = e.suc_id

-- producto cartesiano
-- no ANSI
select		s.suc_nombre as sucursal,
			e.emp_nombre empleado
from		sucursales s, empleados e

-- ANSI
select		s.suc_nombre as sucursal,
			e.emp_nombre empleado
from		sucursales s
cross join	empleados e




-- outer join
-- listar los empleados que no trabajan en ninguna sucursal
-- tabla ppal: empleados
select	e.emp_nombre as empleado
		--, s.*
from	empleados e left join sucursales s
on		s.suc_id = e.suc_id
where	s.suc_id is null

-- listar las sucursales donde no trabajan empleados
-- tabla ppal: sucursales
select		suc_nombre as sucursal
			,e.*
from		empleados e 
right join	sucursales s
on			e.suc_id = s.suc_id
where		e.emp_id is null

-- full join = left + right
select		*
from		empleados e 
full join	sucursales s
on			e.suc_id = s.suc_id

-- multiples joins
use pubs

-- listar el nombre y apellido de los autores que escribieron libros de cocina. Indicar cuando se publicaron y que editoriales lo hicieron.
select		a.au_fname + ' ' + a.au_lname as autor,
			t.type categoria,
			t.pubdate [fecha de publicacion],
			p.pub_name editorial

from		authors a
inner join	titleauthor ta on ta.au_id = a.au_id
inner join	titles t on ta.title_id = t.title_id
inner join	publishers p on p.pub_id = t.pub_id

where		t.type like '%cook%'










