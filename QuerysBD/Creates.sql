/*DROP TABLE C_P;
DROP TABLE E_P;
DROP TABLE T_P;
DROP TABLE Telefono;
DROP TABLE Concurso;
DROP TABLE Estado;
DROP TABLE Participante;
DROP TABLE Exposicion;
DROP TABLE Taller;*/


CREATE EXTENSION IF NOT EXISTS unaccent;

CREATE TABLE IF NOT EXISTS Concurso (
    ID_Concurso SERIAL PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    Fecha DATE NOT NULL,
    Categoria VARCHAR(255),
    Tema VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS obra (
  id_obra SERIAL PRIMARY KEY,
  numero_obra VARCHAR(50),
  titulo VARCHAR(255) NOT NULL,
  tecnica VARCHAR(255),
  ancho NUMERIC(10,2),
  alto  NUMERIC(10,2),
  anio  INTEGER,
  tema  VARCHAR(255),
  estilo VARCHAR(255),
  ubicacion VARCHAR(255),
  observacion TEXT,
  participante_id INT,  -- FK a Participante, se define despues
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS Exposicion (
    ID_Expo SERIAL PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    fecha DATE NOT NULL,
    Tipo VARCHAR(255) NOT NULL,
    Lugar VARCHAR(255),
    Tema VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Taller (
    ID_Taller SERIAL PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    fecha DATE NOT null,
    Lugar VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Estado (
    Id_Estado SERIAL PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS Participante (
    ID_Participante SERIAL PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    Cedula VARCHAR(255),
    fecha_Nacimiento DATE NOT NULL,
    Correo VARCHAR(255) NOT NULL,
    Ciudad VARCHAR(255) NOT NULL,
    Instagram VARCHAR(255),
    Estado_ID INT REFERENCES Estado(Id_Estado)
);


CREATE TABLE IF NOT EXISTS C_P (
    ID SERIAL PRIMARY KEY,
    Mencion VARCHAR(255),
    Posicion INT,
    Concurso_ID INT REFERENCES Concurso(ID_Concurso) ON DELETE CASCADE,
    Participante_ID INT REFERENCES Participante(ID_Participante) ON DELETE CASCADE -- o la política que decidas
);

CREATE TABLE IF NOT EXISTS E_P (
    ID SERIAL PRIMARY KEY,
    Exposicion_ID INT REFERENCES Exposicion(ID_Expo) ON DELETE CASCADE,
    Participante_ID INT REFERENCES Participante(ID_Participante) ON DELETE CASCADE,
    obra_id INT REFERENCES obra(id_obra) ON DELETE SET NULL,
    numero_obra INT
);


CREATE TABLE IF NOT EXISTS T_P (
    ID SERIAL PRIMARY KEY,
    Taller_ID INT REFERENCES Taller(ID_Taller) ON DELETE CASCADE,
    Participante_ID INT REFERENCES Participante(ID_Participante) ON DELETE CASCADE -- o la política que decidas
);

CREATE TABLE IF NOT EXISTS Telefono (
    id_telefono SERIAL PRIMARY KEY,
    numero_telefonico VARCHAR(255) NOT NULL,
    Participante_ID INT REFERENCES Participante(ID_Participante) ON DELETE CASCADE -- o la política que decidas
);



CREATE TABLE IF NOT EXISTS Encuentro (
    id_encuentro SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    fecha DATE NOT NULL,
    lugar VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS EN_P (
    id SERIAL PRIMARY KEY,
    Encuentro_ID INT REFERENCES Encuentro(id_encuentro) ON DELETE CASCADE,
    Participante_ID INT REFERENCES Participante(ID_Participante) ON DELETE CASCADE
);

-- FK diferida: obra.participante_id -> Participante
-- (se define aqui porque obra se crea antes que Participante en el esquema)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_name = 'obra_participante_id_fkey'
      AND table_name = 'obra'
  ) THEN
    ALTER TABLE obra
      ADD CONSTRAINT obra_participante_id_fkey
      FOREIGN KEY (participante_id) REFERENCES Participante(ID_Participante) ON DELETE SET NULL;
  END IF;
END $$;

