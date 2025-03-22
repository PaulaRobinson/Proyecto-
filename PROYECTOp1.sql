--PROYECTO STAYSYNC =D

-- Eliminación de Tablas 
DROP TABLE Multa CASCADE CONSTRAINTS;
DROP TABLE Cancelacion CASCADE CONSTRAINTS;
DROP TABLE Pago CASCADE CONSTRAINTS;
DROP TABLE Opinion CASCADE CONSTRAINTS;
DROP TABLE Mensaje CASCADE CONSTRAINTS;
DROP TABLE Reserva CASCADE CONSTRAINTS;
DROP TABLE Propiedad CASCADE CONSTRAINTS;
DROP TABLE Huesped CASCADE CONSTRAINTS;
DROP TABLE Anfitrion CASCADE CONSTRAINTS;
DROP TABLE Usuario CASCADE CONSTRAINTS;

-- Creación de Tablas

CREATE TABLE Usuario (
    IDUsuario INT PRIMARY KEY,
    Nombre VARCHAR2(100) NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    Telefono VARCHAR2(20),
    TipoUsuario VARCHAR2(10) CHECK (TipoUsuario IN ('Anfitrion', 'Huesped')),
    Contrasena VARCHAR2(150) NOT NULL,
    FechaDeRegistro DATE NOT NULL
);

CREATE TABLE Anfitrion (
    IDAnfitrion INT PRIMARY KEY,
    IDUsuario INT UNIQUE,
    FOREIGN KEY (IDUsuario) REFERENCES Usuario(IDUsuario)
);

CREATE TABLE Huesped (
    IDHuesped INT PRIMARY KEY,
    IDUsuario INT UNIQUE,
    FOREIGN KEY (IDUsuario) REFERENCES Usuario(IDUsuario)
);

CREATE TABLE Propiedad (
    IDPropiedad INT PRIMARY KEY,
    IDAnfitrion INT,
    Nombre VARCHAR2(100) NOT NULL,
    Ubicacion VARCHAR2(150) NOT NULL,
    Descripcion CLOB,
    PrecioPorNoche NUMBER(10,2) NOT NULL,
    Estado VARCHAR2(15) CHECK (Estado IN ('Disponible', 'No Disponible')),
    FOREIGN KEY (IDAnfitrion) REFERENCES Anfitrion(IDAnfitrion)
);

CREATE TABLE Reserva (
    IDReserva INT PRIMARY KEY,
    IDHuesped INT,
    IDPropiedad INT,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    Estado VARCHAR2(15) CHECK (Estado IN ('Pendiente', 'Confirmada', 'Cancelada')),
    FOREIGN KEY (IDHuesped) REFERENCES Huesped(IDHuesped),
    FOREIGN KEY (IDPropiedad) REFERENCES Propiedad(IDPropiedad)
);

CREATE TABLE Mensaje (
    IDMensaje INT PRIMARY KEY,
    IDUsuarioEmisor INT,
    IDUsuarioReceptor INT,
    Mensaje CLOB NOT NULL,
    FechaEnvio DATE NOT NULL,
    FOREIGN KEY (IDUsuarioEmisor) REFERENCES Usuario(IDUsuario),
    FOREIGN KEY (IDUsuarioReceptor) REFERENCES Usuario(IDUsuario)
);

CREATE TABLE Opinion (
    IDOpinion INT PRIMARY KEY,
    IDHuesped INT,
    IDPropiedad INT,
    Calificacion INT CHECK (Calificacion BETWEEN 1 AND 5),
    Comentario CLOB,
    Fecha DATE NOT NULL,
    FOREIGN KEY (IDHuesped) REFERENCES Huesped(IDHuesped),
    FOREIGN KEY (IDPropiedad) REFERENCES Propiedad(IDPropiedad)
);

CREATE TABLE Pago (
    IDPago INT PRIMARY KEY,
    IDReserva INT,
    IDHuesped INT,
    Monto NUMBER(10,2) NOT NULL,
    MetodoPago VARCHAR2(20) CHECK (MetodoPago IN ('Tarjeta', 'Transferencia', 'Paypal')),
    Estado VARCHAR2(15) CHECK (Estado IN ('Completado', 'Pendiente', 'Fallido')),
    FechaPago DATE NOT NULL,
    FOREIGN KEY (IDReserva) REFERENCES Reserva(IDReserva),
    FOREIGN KEY (IDHuesped) REFERENCES Huesped(IDHuesped)
);

CREATE TABLE Cancelacion (
    IDCancelacion INT PRIMARY KEY,
    IDReserva INT,
    IDHuesped INT,
    Motivo CLOB NOT NULL,
    FechaCancelacion DATE NOT NULL,
    FOREIGN KEY (IDReserva) REFERENCES Reserva(IDReserva),
    FOREIGN KEY (IDHuesped) REFERENCES Huesped(IDHuesped)
);

CREATE TABLE Multa (
    IDMulta INT PRIMARY KEY,
    IDCancelacion INT,
    Monto NUMBER(10,2) NOT NULL,
    Estado VARCHAR2(15) CHECK (Estado IN ('Pendiente', 'Pagada')),
    FechaAplicacion DATE NOT NULL,
    FOREIGN KEY (IDCancelacion) REFERENCES Cancelacion(IDCancelacion)
);

-- PoblarOK, Poblar con datos correctos

INSERT INTO Usuario (IDUsuario, Nombre, Email, Telefono, TipoUsuario, Contrasena, FechaDeRegistro)
VALUES (1, 'Fabián Andrade', 'fabian.andrade@example.com', '3465892135', 'Anfitrion', 'tungodearroz3', SYSDATE);

INSERT INTO Usuario (IDUsuario, Nombre, Email, Telefono, TipoUsuario, Contrasena, FechaDeRegistro)
VALUES (2, 'Ana Jurado', 'ana.jurado@example.com', '3218958350', 'Huesped', 'ferrari2025', SYSDATE);

INSERT INTO Anfitrion (IDAnfitrion, IDUsuario) VALUES (1, 1);
INSERT INTO Huesped (IDHuesped, IDUsuario) VALUES (2, 2);

INSERT INTO Propiedad (IDPropiedad, IDAnfitrion, Nombre, Ubicacion, Descripcion, PrecioPorNoche, Estado)
VALUES (1, 1, 'Casa en la playa', 'Playa del carmen, 512', 'Hermosa casa con vista al mar.', 150.00, 'Disponible');

INSERT INTO Reserva (IDReserva, IDHuesped, IDPropiedad, FechaInicio, FechaFin, Estado)
VALUES (1, 2, 1, TO_DATE('2025-04-01', 'YYYY-MM-DD'), TO_DATE('2025-04-07', 'YYYY-MM-DD'), 'Pendiente');

INSERT INTO Mensaje (IDMensaje, IDUsuarioEmisor, IDUsuarioReceptor, Mensaje, FechaEnvio)
VALUES (1, 1, 2, 'Hola Paula, ¿cómo estas?', SYSDATE);

INSERT INTO Opinion (IDOpinion, IDHuesped, IDPropiedad, Calificacion, Comentario, Fecha)
VALUES (1, 2, 1, 5, 'Muy bonito lugar para estar de vacaciones :D', SYSDATE);

INSERT INTO Pago (IDPago, IDReserva, IDHuesped, Monto, MetodoPago, Estado, FechaPago)
VALUES (1, 1, 2, 1050, 'Tarjeta', 'Completado', SYSDATE);

INSERT INTO Cancelacion (IDCancelacion, IDReserva, IDHuesped, FechaCancelacion, Motivo)
VALUES (1, 1, 2, SYSDATE, 'Cambio de planes');

INSERT INTO Multa (IDMulta, IDCancelacion, Monto, Estado, FechaAplicacion)
VALUES (1, 1, 50, 'Pendiente', SYSDATE);


--PoblarNoOK, Errores
-- Error: Tipo de dato incorrecto
INSERT INTO Usuario (IDUsuario, Nombre, Email, Telefono, TipoUsuario, Contrasena, FechaDeRegistro)
VALUES ('Texto', 'Error Test', 'error.email@example.com', '123456', 'Anfitrion', 'Contraseña Incorrectaa', SYSDATE);

-- Error: IDUsuario duplicado
INSERT INTO Usuario (IDUsuario, Nombre, Email, Telefono, TipoUsuario, Contrasena, FechaDeRegistro)
VALUES (1, 'Duplicado', 'dup@example.com', '000000', 'Huesped', 'Contraseña Duplicada', SYSDATE);

-- Error: Email duplicado
INSERT INTO Usuario (IDUsuario, Nombre, Email, Telefono, TipoUsuario, Contrasena, FechaDeRegistro)
VALUES (3, 'Nuevo Usuario', 'fabian.andrade@example.com', '111111', 'Huesped', 'Nueva Contraseña', SYSDATE);

-- Error: Clave foránea inválida
INSERT INTO Propiedad (IDPropiedad, IDUsuario, Nombre, Ubicacion, Descripcion, PrecioPorNoche, Estado)
VALUES (2, 99, 'Casa Inexistente', 'Dirección Falsa', 'No existe.', 200.00, 'Disponible');

--Error: Calificación debe estar entre 1 y 5, en este caso se puso 6
INSERT INTO Opinion (IDOpinion, IDHuesped, IDPropiedad, Calificacion, Comentario, Fecha)
VALUES (2, 2, 1, 6, 'Excediendo el límite', SYSDATE);

--Error: Estado solo permite 'Pendiente' o 'Pagada' y esta como En proceso
INSERT INTO Multa (IDMulta, IDCancelacion, Monto, Estado, FechaAplicacion)
VALUES (2, 1, 50, 'En proceso', SYSDATE);


-- Consultas 

-- Obtener todos los usuarios con su ID
SELECT IDUsuario, Nombre, Email, Telefono, TipoUsuario FROM Usuario;

-- Obtener todas las propiedades con su ID y el anfitrión
SELECT IDPropiedad, Nombre, Ubicacion, PrecioPorNoche, Estado, IDAnfitrion
FROM Propiedad;

-- Obtener todas las reservas con su ID, huésped y propiedad
SELECT IDReserva, IDHuesped, IDPropiedad, FechaInicio, FechaFin, Estado 
FROM Reserva;

-- Obtener todos los mensajes con su ID y los usuariosen este
SELECT IDMensaje, IDUsuarioEmisor, IDUsuarioReceptor, FechaEnvio 
FROM Mensaje;

-- Obtener todas las opiniones con su ID, huésped y propiedad
SELECT IDOpinion, IDHuesped, IDPropiedad, Calificacion, Fecha 
FROM Opinion;

-- Obtener todos los pagos con su ID, reserva y usuario 
SELECT IDPago, IDReserva, IDHuesped, Monto, MetodoPago, Estado, FechaPago 
FROM Pago;

-- Obtener todas las cancelaciones con su ID, reserva y usuario 
SELECT IDCancelacion, IDReserva, IDHuesped, FechaCancelacion 
FROM Cancelacion;

-- Obtener todas las multas con su ID y la cancelación
SELECT IDMulta, IDCancelacion, Monto, Estado, FechaAplicacion 
FROM Multa;

-- Verificación de datos restantes
SELECT * FROM Usuario;
SELECT * FROM Anfitrion;
SELECT * FROM Huesped;
SELECT * FROM Propiedad;
SELECT * FROM Reserva;
SELECT * FROM Mensaje;
SELECT * FROM Opinion;
SELECT * FROM Pago;
SELECT * FROM Cancelacion;
SELECT * FROM Multa;

