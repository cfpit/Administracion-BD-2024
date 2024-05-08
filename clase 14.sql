--Cursores

--procedimiento que aumenta un 10% el precio de los libros con precio menor a 10$
--y baja un 10% el precio de los libros con precio igual o mayor a 10$

use editoriales
go

CREATE PROCEDURE aumentarPrecio
as
BEGIN
	declare @price as float,@id as int
	declare titulo cursor for
	
	select libro_id,precio
	from libros
	
	open titulo
	fetch next  from titulo into @id,@price

	while (@@fetch_status=0)
		begin
			if @price<10
				begin
					update libros
					set precio=precio*1.1
					where libro_id=@id
				end
			else
				begin
					update libros
					set precio=precio*0.9
					where libro_id=@id
				end			
		fetch next  from titulo into @id,@price
		end


	close titulo
	deallocate  titulo
	
END


EXEC aumentarPrecio 

select * from libros

drop proc aumentarPrecio





--Triggers
--procedimientos almacenados en el server, relacionados con las tablas
--se disparan cuando se produce algun evento en la tabla

create database disparadores
go
use disparadores


--trigger de insert

CREATE TABLE prueba(
					codigo int,
					nombre varchar(50)					
					)

drop table prueba

CREATE TRIGGER ti_prueba
ON prueba after INSERT
as
BEGIN
	print 'registro nuevo'
END


INSERT INTO prueba
SELECT 1,'juan'

INSERT INTO prueba
SELECT 2,'jose'

INSERT INTO prueba
SELECT 3,'carlos'


select * from prueba


--trigger de delete

CREATE TRIGGER td_prueba
ON prueba after DELETE
as
BEGIN
	print 'registro borrado'
END

delete from prueba where codigo=1

--trigger de update

CREATE TRIGGER tu_prueba
ON prueba after UPDATE
as
BEGIN
	print 'registro modificado'
END

update prueba set nombre='xx' where codigo=2

--modificacion de trigger de insert

ALTER TRIGGER ti_prueba
on prueba after insert
as
BEGIN
	select 	suser_sname() usuario,
			getdate() fecha,
			'DATOS INGRESADOS'informacion,
			codigo, nombre
		 from inserted
END

insert into prueba
select 4 , 'maria'


--modificacion de trigger de delete

ALTER TRIGGER td_prueba
on prueba after delete
as
BEGIN
	select 	suser_sname() usuario,
			getdate() fecha,
			'DATOS BORRADOS'informacion,
			codigo, nombre
		 from deleted
END

delete from prueba where codigo = 2


--modificacion de trigger de update

ALTER TRIGGER tu_prueba
on prueba after update
as
BEGIN
	select 	suser_sname() usuario,
			getdate() fecha,
			'DATOS INGRESADOS'informacion,
			codigo, nombre
		 from inserted
	union
	select 	suser_sname() usuario,
			getdate() fecha,
			'DATOS BORRADOS' informacion,
			codigo, nombre
		 from deleted
END

update prueba set nombre = 'yy' where codigo = 3



/*Ejercicio de trigger completo con las 3 operaciones de DML*/

CREATE TABLE usuarios ( nro int, 
					    nombre varchar(30), 
					    sexo varchar(1)
					  )



CREATE TABLE usuarios_audit(
							nro_op int,
							nro int,
							nombre varchar(50),
							sexo varchar(1),
							operacion varchar(1),
							fecha datetime,
							usuario_sql varchar(50)
							)


CREATE TRIGGER usuarios_dml
on usuarios
after insert, update, delete
as
    --insert/deleted
	if exists (select * from inserted) and exists (select * from deleted)
	   begin
			insert into usuarios_audit(nro_op,nro,nombre,sexo,operacion,fecha,usuario_sql)
            select 1,nro,nombre,sexo,'U',getdate(),user_name()
            from inserted
       end
    else 
       begin 
			if exists (select * from inserted)
				begin	
					insert into usuarios_audit(nro_op,nro,nombre,sexo,operacion,fecha,usuario_sql)
					select 1,nro,nombre,sexo,'I',getdate(),user_name()
					from inserted
				end 
			else
				begin
					insert into usuarios_audit(nro_op,nro,nombre,sexo,operacion,fecha,usuario_sql)
					select 1,nro,nombre,sexo,'D',getdate(),user_name()
					from deleted
				end
		end  

 
/*con esto lo pruebo*/

--sp_help usuarios

insert into usuarios (nro, nombre, sexo) values (10, 'juan', 'm')

select * from usuarios_audit

insert into usuarios (nro, nombre, sexo) values (12,'Maria','f')

select * from usuarios_audit

delete from usuarios  where nombre='Maria'

select * from usuarios_audit