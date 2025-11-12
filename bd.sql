-- ════════════════════════════════════════════════════════════
-- SCRIPT DDL - MICROSERVICIOS TASKS & USERS
-- ════════════════════════════════════════════════════════════
-- Descripción: Creación de bases de datos y tablas (sin datos)
-- ════════════════════════════════════════════════════════════

-- ============================================
-- 1. ELIMINAR BASES DE DATOS SI EXISTEN
-- ============================================
DROP DATABASE IF EXISTS users_db;
DROP DATABASE IF EXISTS tasks_db;

-- ============================================
-- 2. CREAR BASES DE DATOS
-- ============================================
CREATE DATABASE users_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE tasks_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════
-- BASE DE DATOS: users_db
-- ════════════════════════════════════════════════════════════
USE users_db;

-- ============================================
-- TABLA: users
-- ============================================
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════
-- BASE DE DATOS: tasks_db
-- ════════════════════════════════════════════════════════════
USE tasks_db;

-- ============================================
-- TABLA: tasks
-- ============================================
CREATE TABLE tasks (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════
-- VERIFICACIÓN DE TABLAS CREADAS
-- ════════════════════════════════════════════════════════════

-- Ver tablas de users_db
USE users_db;
SHOW TABLES;
DESCRIBE users;

-- Ver tablas de tasks_db
USE tasks_db;
SHOW TABLES;
DESCRIBE tasks;

-- ════════════════════════════════════════════════════════════
-- FIN DEL SCRIPT DDL
-- ════════════════════════════════════════════════════════════