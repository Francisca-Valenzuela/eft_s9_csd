-- =============================================================
-- ESQUEMA DE BASE DE DATOS — FRONTEND (Aplicación Web)
-- Proyecto: Unidos por los Animales — CDY2203
-- Motor: MySQL 8.0 (Railway Cloud)
-- Nota: Este schema es generado automáticamente por Hibernate
--       (spring.jpa.hibernate.ddl-auto=update). Se incluye como
--       documentación de referencia del modelo de datos.
-- =============================================================

-- Crear y seleccionar la base de datos
CREATE DATABASE IF NOT EXISTS mydatabase
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE mydatabase;

-- -------------------------------------------------------------
-- Tabla: usuarios
-- Entidad: com.unidosporlosanimales.seguridad_vet.model.Usuario
-- Descripción: Usuarios del sistema con roles (ROLE_ADMIN, ROLE_VET, ROLE_USER)
--              Contraseñas almacenadas con hash BCrypt
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS usuarios (
    id       BIGINT       NOT NULL AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,  -- Hash BCrypt (no texto plano)
    rol      VARCHAR(50)  NOT NULL,  -- Ej: 'ROLE_ADMIN', 'ROLE_VET', 'ROLE_USER'
    PRIMARY KEY (id)
);

-- -------------------------------------------------------------
-- Tabla: duenos
-- Entidad: com.unidosporlosanimales.seguridad_vet.model.Dueno
-- Descripción: Dueños de mascotas registrados en la organización
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS duenos (
    id       BIGINT       NOT NULL AUTO_INCREMENT,
    nombre   VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    email    VARCHAR(255) NOT NULL UNIQUE,
    telefono VARCHAR(50)  NOT NULL,
    PRIMARY KEY (id)
);

-- -------------------------------------------------------------
-- Tabla: mascotas
-- Entidad: com.unidosporlosanimales.seguridad_vet.model.Mascota
-- Descripción: Mascotas registradas para adopción o seguimiento
--              Relación ManyToOne con duenos
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS mascotas (
    id       BIGINT       NOT NULL AUTO_INCREMENT,
    nombre   VARCHAR(255) NOT NULL,
    especie  VARCHAR(255) NOT NULL,  -- Ej: 'Perro', 'Gato', 'Conejo'
    raza     VARCHAR(255) NOT NULL,
    edad     INT          NOT NULL,  -- Edad en años
    dueno_id BIGINT       NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_mascota_dueno FOREIGN KEY (dueno_id)
        REFERENCES duenos(id) ON DELETE CASCADE
);

-- -------------------------------------------------------------
-- Tabla: citas
-- Entidad: com.unidosporlosanimales.seguridad_vet.model.Cita
-- Descripción: Citas veterinarias asociadas a una mascota
--              Estado: 'PENDIENTE', 'ATENDIDA', 'CANCELADA'
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS citas (
    id         BIGINT       NOT NULL AUTO_INCREMENT,
    fecha      DATE         NOT NULL,
    motivo     VARCHAR(255) NOT NULL,
    estado     VARCHAR(50)  NOT NULL DEFAULT 'PENDIENTE',
    mascota_id BIGINT       NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_cita_mascota FOREIGN KEY (mascota_id)
        REFERENCES mascotas(id) ON DELETE CASCADE
);
