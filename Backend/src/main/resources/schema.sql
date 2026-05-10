-- =============================================================
-- ESQUEMA DE BASE DE DATOS — BACKEND (API REST)
-- Proyecto: Unidos por los Animales — CDY2203
-- Motor: MySQL 8.0
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
-- Tabla: user
-- Entidad: com.duoc.backend.user.User
-- Descripción: Usuarios del sistema con autenticación JWT
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user (
    id       INT          NOT NULL AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL UNIQUE,
    email    VARCHAR(255),
    password VARCHAR(255) NOT NULL,  -- Hash BCrypt
    enabled  TINYINT(1)   NOT NULL DEFAULT 1,
    PRIMARY KEY (id)
);

-- -------------------------------------------------------------
-- Tabla: patient
-- Entidad: com.duoc.backend.patient.Patient
-- Descripción: Pacientes veterinarios (animales atendidos)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS patient (
    id      BIGINT       NOT NULL AUTO_INCREMENT,
    name    VARCHAR(255) NOT NULL,
    species VARCHAR(255),
    breed   VARCHAR(255),
    age     INT          NOT NULL DEFAULT 0,
    owner   VARCHAR(255),
    PRIMARY KEY (id)
);

-- -------------------------------------------------------------
-- Tabla: appointment
-- Entidad: com.duoc.backend.appointment.Appointment
-- Descripción: Citas médicas con fecha, hora y veterinario
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS appointment (
    id           BIGINT  NOT NULL AUTO_INCREMENT,
    date         DATE,
    time         TIME,
    reason       VARCHAR(255),
    veterinarian VARCHAR(255),
    PRIMARY KEY (id)
);

-- -------------------------------------------------------------
-- Tabla: care
-- Entidad: com.duoc.backend.care.Care
-- Descripción: Servicios o atenciones clínicas disponibles
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS care (
    id   BIGINT         NOT NULL AUTO_INCREMENT,
    name VARCHAR(255)   NOT NULL,
    cost DOUBLE PRECISION,
    PRIMARY KEY (id)
);

-- -------------------------------------------------------------
-- Tabla: medication
-- Entidad: com.duoc.backend.medication.Medication
-- Descripción: Medicamentos disponibles en la clínica
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS medication (
    id   BIGINT         NOT NULL AUTO_INCREMENT,
    name VARCHAR(255)   NOT NULL,
    cost DOUBLE PRECISION,
    PRIMARY KEY (id)
);

-- -------------------------------------------------------------
-- Tabla: invoice
-- Entidad: com.duoc.backend.Invoice.Invoice
-- Descripción: Facturas de visitas veterinarias con costo total
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS invoice (
    id           BIGINT         NOT NULL AUTO_INCREMENT,
    patient_name VARCHAR(255),
    date         DATE,
    time         TIME,
    total_cost   DOUBLE PRECISION,
    PRIMARY KEY (id)
);

-- -------------------------------------------------------------
-- Tabla de unión: invoice_cares  (Invoice @ManyToMany Care)
-- Mapea los servicios prestados en cada factura
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS invoice_cares (
    invoice_id BIGINT NOT NULL,
    care_id    BIGINT NOT NULL,
    PRIMARY KEY (invoice_id, care_id),
    CONSTRAINT fk_inv_care_invoice    FOREIGN KEY (invoice_id) REFERENCES invoice(id)  ON DELETE CASCADE,
    CONSTRAINT fk_inv_care_care       FOREIGN KEY (care_id)    REFERENCES care(id)     ON DELETE CASCADE
);

-- -------------------------------------------------------------
-- Tabla de unión: invoice_medications  (Invoice @ManyToMany Medication)
-- Mapea los medicamentos administrados en cada factura
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS invoice_medications (
    invoice_id    BIGINT NOT NULL,
    medication_id BIGINT NOT NULL,
    PRIMARY KEY (invoice_id, medication_id),
    CONSTRAINT fk_inv_med_invoice    FOREIGN KEY (invoice_id)    REFERENCES invoice(id)    ON DELETE CASCADE,
    CONSTRAINT fk_inv_med_medication FOREIGN KEY (medication_id) REFERENCES medication(id) ON DELETE CASCADE
);