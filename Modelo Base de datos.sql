USE BDCOLEGIO;
GO

-- Tabla Usuarios
CREATE TABLE Usuarios (
    ID_Usuario INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Usuario VARCHAR(50) UNIQUE NOT NULL,
    Contrasena VARCHAR(255) NOT NULL,
    Rol VARCHAR(20) CHECK (Rol IN ('director', 'subdirector', 'profesor', 'administrativo', 'superadmin')),
    Correo_Electronico VARCHAR(100),
    Ultimo_Acceso DATETIME,
    Estado_Activo BIT DEFAULT 1
);

-- Tabla Años
CREATE TABLE Anios (
    ID_Anio INT PRIMARY KEY,
    Fecha_Inicio DATE,
    Fecha_Fin DATE
);

-- Tabla Grados
CREATE TABLE Grados (
    ID_Grado INT PRIMARY KEY IDENTITY(1,1),
    Numero_Grado INT NOT NULL,
    Nivel VARCHAR(10) CHECK (Nivel IN ('Primaria', 'Secundaria'))
);

-- Tabla Estudiantes (simplificada)
CREATE TABLE Estudiantes (
    ID_Estudiante INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Grado_Actual INT, -- Almacena el grado actual en forma de ID
    FOREIGN KEY (Grado_Actual) REFERENCES Grados(ID_Grado)
);

-- Tabla Cursos
CREATE TABLE Cursos (
    ID_Curso INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Curso VARCHAR(100) NOT NULL,
    ID_Grado INT,
    FOREIGN KEY (ID_Grado) REFERENCES Grados(ID_Grado)
);

-- Tabla Secciones
CREATE TABLE Secciones (
    ID_Seccion INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Seccion VARCHAR(10) NOT NULL,
    ID_Grado INT,
    Vacantes_Disponibles INT,
    Vacantes_Ocupadas INT,
    FOREIGN KEY (ID_Grado) REFERENCES Grados(ID_Grado)
);

-- Tabla Matricula (simplificada)
CREATE TABLE Matricula (
    ID_Matricula INT PRIMARY KEY IDENTITY(1,1),
    ID_Estudiante INT,
    ID_Seccion INT,
    ID_Anio INT,
    Fecha_Matricula DATE,
    Estado_Matricula VARCHAR(10) CHECK (Estado_Matricula IN ('Activo', 'Retirado')),
    FOREIGN KEY (ID_Estudiante) REFERENCES Estudiantes(ID_Estudiante),
    FOREIGN KEY (ID_Seccion) REFERENCES Secciones(ID_Seccion),
    FOREIGN KEY (ID_Anio) REFERENCES Anios(ID_Anio)
);

-- Tabla Profesores
CREATE TABLE Profesores (
    ID_Profesor INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    DNI VARCHAR(15) NOT NULL,
    Correo_Electronico VARCHAR(100),
    Telefono VARCHAR(15),
    Direccion VARCHAR(100)
);

-- Tabla Asignacion_Profesor (optimizando relación con cursos y secciones)
CREATE TABLE Asignacion_Profesor (
    ID_Asignacion INT PRIMARY KEY IDENTITY(1,1),
    ID_Profesor INT,
    ID_Curso INT,
    ID_Seccion INT,
    ID_Anio INT,
    FOREIGN KEY (ID_Profesor) REFERENCES Profesores(ID_Profesor),
    FOREIGN KEY (ID_Curso) REFERENCES Cursos(ID_Curso),
    FOREIGN KEY (ID_Seccion) REFERENCES Secciones(ID_Seccion),
    FOREIGN KEY (ID_Anio) REFERENCES Anios(ID_Anio)
);

-- Tabla Horarios (relacionada con Asignacion_Profesor)
CREATE TABLE Horarios (
    ID_Horario INT PRIMARY KEY IDENTITY(1,1),
    ID_Asignacion INT,
    Dia VARCHAR(10) CHECK (Dia IN ('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes')),
    Hora_Inicio TIME,
    Hora_Fin TIME,
    FOREIGN KEY (ID_Asignacion) REFERENCES Asignacion_Profesor(ID_Asignacion)
);

-- Tabla Notas
CREATE TABLE Notas (
    ID_Nota INT PRIMARY KEY IDENTITY(1,1),
    ID_Estudiante INT,
    ID_Anio INT,
    ID_Curso INT,
    Bimestre1_Nota_Final DECIMAL(5,2),
    Bimestre2_Nota_Final DECIMAL(5,2),
    Bimestre3_Nota_Final DECIMAL(5,2),
    Bimestre4_Nota_Final DECIMAL(5,2),
    Promedio_Final DECIMAL(5,2),
    FOREIGN KEY (ID_Estudiante) REFERENCES Estudiantes(ID_Estudiante),
    FOREIGN KEY (ID_Anio) REFERENCES Anios(ID_Anio),
    FOREIGN KEY (ID_Curso) REFERENCES Cursos(ID_Curso)
);

-- Tabla Notas_Por_Periodo
CREATE TABLE Notas_Por_Periodo (
    ID_Nota_Periodo INT PRIMARY KEY IDENTITY(1,1),
    ID_Nota INT,
    ID_Bimestre INT CHECK (ID_Bimestre BETWEEN 1 AND 4),
    Examen_Mensual DECIMAL(5,2),
    Examen_Bimestral DECIMAL(5,2),
    Participacion DECIMAL(5,2),
    Revision_Cuaderno DECIMAL(5,2),
    PC1 DECIMAL(5,2),
    PC2 DECIMAL(5,2),
    PC3 DECIMAL(5,2),
    Promedio_PCs DECIMAL(5,2),
    Promedio_Final_Bimestre DECIMAL(5,2),
    FOREIGN KEY (ID_Nota) REFERENCES Notas(ID_Nota)
);