--PARTE 2
--1. Crear el modelo en una base de datos llamada biblioteca, considerando las tablas definidas y sus atributos.

CREATE TABLE autores(
    codigo INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    fecha_muerte DATE
);

CREATE TABLE libros(
    isbn VARCHAR(50) PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    num_pag INT NOT NULL
);

CREATE TABLE autores_libros(
    libro_isbn VARCHAR(50) NOT NULL REFERENCES libros(isbn),
    autor_codigo INT NOT NULL REFERENCES autores(codigo),
    tipo_autor VARCHAR(50) CHECK (tipo_autor = 'PRINCIPAL' OR tipo_autor = 'COAUTOR'),
    PRIMARY KEY (libro_isbn,autor_codigo)
);

CREATE TABLE comunas(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE direcciones(
    id INT PRIMARY KEY,
    numero INT NOT NULL,
    calle VARCHAR(50) NOT NULL,
    comuna_id INT NOT NULL REFERENCES comunas(id)
);

CREATE TABLE socios(
    rut VARCHAR(12) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    telefono VARCHAR(12) NOT NULL,
    direccion_id INT NOT NULL REFERENCES direcciones(id)
);

CREATE TABLE prestamos(
    id SERIAL PRIMARY KEY,
    libro_isbn VARCHAR(50) NOT NULL REFERENCES libros(isbn),
    socio_rut VARCHAR(50) NOT NULL REFERENCES socios(rut),
    fecha_inicio DATE NOT NULL,
    fecha_devolucion DATE NOT NULL,
    fecha_real_devolucion DATE
);


-- 2. Se deben insertar los registros en las tablas correspondientes
INSERT INTO autores(codigo,nombre,apellido,fecha_nacimiento,fecha_muerte) VALUES (3,'JOSE','SALGADO','1968-01-01','2020-01-01');
INSERT INTO autores(codigo,nombre,apellido,fecha_nacimiento,fecha_muerte) VALUES (4,'ANA','SALGADO','1972-01-01',NULL);
INSERT INTO autores(codigo,nombre,apellido,fecha_nacimiento,fecha_muerte) VALUES (1,'ANDRES','ULLOA','1982-01-01',NULL);
INSERT INTO autores(codigo,nombre,apellido,fecha_nacimiento,fecha_muerte) VALUES (2,'SERGIO','MARDONES','1950-01-01','2012-01-01');
INSERT INTO autores(codigo,nombre,apellido,fecha_nacimiento,fecha_muerte) VALUES (5,'MARTIN','PORTA','1976-01-01',NULL);

INSERT INTO libros(isbn,titulo,num_pag) VALUES ('111-1111111-111','CUENTOS DE TERROR',344);
INSERT INTO libros(isbn,titulo,num_pag) VALUES ('222-2222222-222','POESIAS CONTEMPORANEAS',167);
INSERT INTO libros(isbn,titulo,num_pag) VALUES ('444-4444444-444','MANUAL DE MECANICA',298);
INSERT INTO libros(isbn,titulo,num_pag) VALUES ('333-3333333-333','HISTORIA DE ASIA',511);

INSERT INTO autores_libros(libro_isbn,autor_codigo,tipo_autor) VALUES ('111-1111111-111',3,'PRINCIPAL');
INSERT INTO autores_libros(libro_isbn,autor_codigo,tipo_autor) VALUES ('111-1111111-111',4,'COAUTOR');
INSERT INTO autores_libros(libro_isbn,autor_codigo,tipo_autor) VALUES ('222-2222222-222',1,'PRINCIPAL');
INSERT INTO autores_libros(libro_isbn,autor_codigo,tipo_autor) VALUES ('444-4444444-444',5,'PRINCIPAL');
INSERT INTO autores_libros(libro_isbn,autor_codigo,tipo_autor) VALUES ('333-3333333-333',2,'PRINCIPAL');

INSERT INTO comunas(id,nombre) VALUES (1,'SANTIAGO');
INSERT INTO comunas(id,nombre) VALUES (2,'TEMUCO');
INSERT INTO comunas(id,nombre) VALUES (3,'PUCON');

INSERT INTO direcciones(id,calle,numero,comuna_id) VALUES(1,'AVENIDA',1,1);
INSERT INTO direcciones(id,calle,numero,comuna_id) VALUES(2,'PASAJE',2,1);
INSERT INTO direcciones(id,calle,numero,comuna_id) VALUES(3,'AVENIDA',2,1);
INSERT INTO direcciones(id,calle,numero,comuna_id) VALUES(4,'AVENIDA',3,1);
INSERT INTO direcciones(id,calle,numero,comuna_id) VALUES(5,'PASAJE',3,1);

INSERT INTO socios(rut,nombre,apellido,telefono,direccion_id) VALUES ('1111111-1','JUAN','SOTO','911111111',1);
INSERT INTO socios(rut,nombre,apellido,telefono,direccion_id) VALUES ('2222222-2','ANA','PEREZ','922222222',2);
INSERT INTO socios(rut,nombre,apellido,telefono,direccion_id) VALUES ('3333333-3','SANDRA','AGUILAR','933333333',3);
INSERT INTO socios(rut,nombre,apellido,telefono,direccion_id) VALUES ('4444444-4','ESTEBAN','JEREZ','944444444',4);
INSERT INTO socios(rut,nombre,apellido,telefono,direccion_id) VALUES ('5555555-5','SILVANA','MUNOZ','955555555',5);

INSERT INTO prestamos(libro_isbn,socio_rut,fecha_inicio,fecha_devolucion) VALUES ('111-1111111-111','1111111-1','20-01-2020','27-01-2020');
INSERT INTO prestamos(libro_isbn,socio_rut,fecha_inicio,fecha_devolucion) VALUES ('222-2222222-222','5555555-5','20-01-2020','30-01-2020');
INSERT INTO prestamos(libro_isbn,socio_rut,fecha_inicio,fecha_devolucion) VALUES ('333-3333333-333','3333333-3','22-01-2020','30-01-2020');
INSERT INTO prestamos(libro_isbn,socio_rut,fecha_inicio,fecha_devolucion) VALUES ('444-4444444-444','4444444-4','23-01-2020','30-01-2020');
INSERT INTO prestamos(libro_isbn,socio_rut,fecha_inicio,fecha_devolucion) VALUES ('111-1111111-111','2222222-2','27-01-2020','04-02-2020');
INSERT INTO prestamos(libro_isbn,socio_rut,fecha_inicio,fecha_devolucion) VALUES ('222-2222222-222','1111111-1','31-01-2020','12-02-2020');
INSERT INTO prestamos(libro_isbn,socio_rut,fecha_inicio,fecha_devolucion) VALUES ('222-2222222-222','3333333-3','31-01-2020','12-02-2020');



--3. Realizar las siguientes consultas:
--a. Mostrar todos los libros que posean menos de 300 páginas. (0.5 puntos)
SELECT * FROM libros WHERE num_pag > 300;

--b. Mostrar todos los autores que hayan nacido después del 01-01-1970.
SELECT * FROM autores WHERE fecha_nacimiento > '1970-01-01';

--c. ¿Cuál es el libro más solicitado? (0.5 puntos).
SELECT libro_isbn as isbn_libro_mas_solicitado, count(libro_isbn) as solicitudes FROM prestamos group by libr
o_isbn ORDER BY solicitudes DESC LIMIT 1;

--d. Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto
-- debería pagar cada usuario que entregue el préstamo después de 7 días.
SELECT *,(fecha_devolucion-fecha_inicio) - 7 as dias_de_atraso, (fecha_devolucion-fecha_inicio)*100-700 as costo_atraso 
FROM prestamos WHERE Fecha_devolucion-fecha_inicio > 7;

SELECT socios.nombre, libros.titulo, (fecha_devolucion-fecha_inicio)-7 as dias_de_atraso, (fecha_devolucion-fecha_inicio)*100-700 as costo_atraso 
FROM prestamos join socios on socios.rut = prestamos.socio_rut join libros on libros.isbn = prestamos.libro_isbn;


