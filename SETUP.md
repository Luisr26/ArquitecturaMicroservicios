# 🏗️ Arquitectura Hexagonal - Multi-Módulo

Este proyecto implementa una arquitectura hexagonal (Ports & Adapters) con dos microservicios independientes utilizando **Java 21 LTS** y **Spring Boot 3.3.0**.

## 📋 Tabla de Contenidos

- [Estructura del Proyecto](#estructura-del-proyecto)
- [Requisitos](#requisitos)
- [Compilación](#compilación)
- [Ejecución](#ejecución)
- [Configuración](#configuración)
- [Arquitectura](#arquitectura)

## 📁 Estructura del Proyecto

```
Arquitectura_hexagonal/
├── pom.xml                              # POM padre (multi-módulo)
├── tasks-service/                       # Microservicio de tareas
│   ├── pom.xml
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/exagonal/tasks/
│   │   │   │   ├── TasksApplication.java
│   │   │   │   ├── domain/
│   │   │   │   │   ├── model/
│   │   │   │   │   └── ports/
│   │   │   │   │       ├── in/          # Puertos de entrada (use cases)
│   │   │   │   │       └── out/         # Puertos de salida (repositories)
│   │   │   │   ├── application/
│   │   │   │   │   ├── services/
│   │   │   │   │   └── usecases/
│   │   │   │   └── infrastructure/
│   │   │   │       ├── adapters/
│   │   │   │       ├── config/
│   │   │   │       ├── controllers/
│   │   │   │       ├── entities/
│   │   │   │       └── repositories/
│   │   │   └── resources/
│   │   │       ├── application.properties
│   │   │       └── application.yml
│   │   └── test/
│   └── target/
│       └── tasks-service-1.0.0.jar
│
├── users-service/                       # Microservicio de usuarios
│   ├── pom.xml
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/exagonal/users/
│   │   │   │   ├── UsersApplication.java
│   │   │   │   ├── domain/
│   │   │   │   │   ├── model/
│   │   │   │   │   └── ports/
│   │   │   │   ├── application/
│   │   │   │   │   └── services/
│   │   │   │   │       ├── UserService.java
│   │   │   │   │       ├── ResourceNotFoundException.java
│   │   │   │   │       └── DuplicateResourceException.java
│   │   │   │   └── infrastructure/
│   │   │   │       ├── controllers/
│   │   │   │       │   └── UserController.java
│   │   │   │       ├── entities/
│   │   │   │       │   └── UserEntity.java
│   │   │   │       ├── repositories/
│   │   │   │       ├── config/
│   │   │   │       │   ├── SecurityConfig.java
│   │   │   │       │   └── GlobalExceptionHandler.java
│   │   │   │       └── filters/
│   │   │   └── resources/
│   │   │       ├── application.properties
│   │   │       └── application.yml
│   │   └── test/
│   └── target/
│       └── users-service-1.0.0.jar
│
├── .mvn/
├── mvnw                                 # Maven Wrapper (Linux/Mac)
├── mvnw.cmd                             # Maven Wrapper (Windows)
└── README.md
```

## ⚙️ Requisitos

- **Java**: 21 LTS (OpenJDK)
- **Maven**: 3.9.x (incluido Maven Wrapper)
- **Git**: Para control de versiones

Verificar la instalación:

```bash
java -version
./mvnw --version
```

## 🔨 Compilación

### Compilar el proyecto completo

```bash
cd /home/Coder/Escritorio/Arquitectura_hexagonal
./mvnw clean compile
```

### Compilar solo un módulo

```bash
# Compilar tasks-service
./mvnw clean compile -pl tasks-service

# Compilar users-service
./mvnw clean compile -pl users-service
```

### Empaquetar (generar JARs)

```bash
./mvnw clean package -DskipTests
```

Los JAR se generarán en:
- `tasks-service/target/tasks-service-1.0.0.jar`
- `users-service/target/users-service-1.0.0.jar`

## 🚀 Ejecución

### Ejecutar Tasks Service

```bash
# Opción 1: Usando Maven
./mvnw spring-boot:run -pl tasks-service

# Opción 2: Usando Java directamente
java -jar tasks-service/target/tasks-service-1.0.0.jar
```

**URL de acceso**: http://localhost:8081

### Ejecutar Users Service

```bash
# Opción 1: Usando Maven
./mvnw spring-boot:run -pl users-service

# Opción 2: Usando Java directamente
java -jar users-service/target/users-service-1.0.0.jar
```

**URL de acceso**: http://localhost:8082

### Ejecutar ambos servicios simultáneamente

```bash
# Terminal 1
./mvnw spring-boot:run -pl tasks-service

# Terminal 2
./mvnw spring-boot:run -pl users-service
```

## ⚙️ Configuración

### Propiedades de Tasks Service

**Archivo**: `tasks-service/src/main/resources/application.properties`

```properties
# Puerto del servidor
server.port=8081

# Base de datos H2 (desarrollo)
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driverClassName=org.h2.Driver

# H2 Console
spring.h2.console.enabled=true
# Acceso en: http://localhost:8081/h2-console

# Hibernate
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.show-sql=true
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
```

### Propiedades de Users Service

**Archivo**: `users-service/src/main/resources/application.properties`

```properties
# Puerto del servidor
server.port=8082

# Base de datos H2 (desarrollo)
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driverClassName=org.h2.Driver

# H2 Console
spring.h2.console.enabled=true
# Acceso en: http://localhost:8082/h2-console

# Hibernate
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.show-sql=true
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
```

### Cambiar a MySQL (Producción)

Actualizar `spring.datasource.url` en el archivo de propiedades:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/tasks_db
spring.datasource.username=root
spring.datasource.password=tu_contraseña
spring.datasource.driverClassName=com.mysql.cj.jdbc.Driver
spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
```

## 🏗️ Arquitectura

### Patrones Implementados

La arquitectura sigue el patrón **Hexagonal (Ports & Adapters)**:

```
┌─────────────────────────────────────────┐
│   EXTERNAL SYSTEMS (Controllers/API)    │
└────────────────┬────────────────────────┘
                 │
        INPUT PORTS (Interfaces)
                 │
┌────────────────▼────────────────────────┐
│   APPLICATION LAYER                     │
│   ├── Services                          │
│   ├── Use Cases                         │
│   └── Business Logic                    │
└────────────────┬─────────────────────────┘
                 │
┌────────────────▼─────────────────────────┐
│   DOMAIN LAYER                          │
│   ├── Entities                          │
│   ├── Value Objects                     │
│   └── Business Rules                    │
└────────────────┬─────────────────────────┘
                 │
        OUTPUT PORTS (Interfaces)
                 │
┌────────────────▼─────────────────────────┐
│   INFRASTRUCTURE LAYER                  │
│   ├── Repositories (Adapters)           │
│   ├── Database                          │
│   ├── External Services                 │
│   └── Configuration                     │
└─────────────────────────────────────────┘
```

### Capas del Proyecto

#### 1. **Domain Layer** (Núcleo del negocio)

```
domain/
├── model/          # Entidades y objetos de valor
├── ports/
│   ├── in/         # Interfaces para use cases
│   └── out/        # Interfaces para repositorios
```

**Características**:
- Sin dependencias externas
- Lógica de negocio pura
- Interfaces que definen contratos

#### 2. **Application Layer** (Lógica de aplicación)

```
application/
├── services/       # Servicios de aplicación
├── usecases/       # Casos de uso
```

**Características**:
- Orquesta la lógica del dominio
- Maneja transacciones
- Coordina entre capas

#### 3. **Infrastructure Layer** (Detalles técnicos)

```
infrastructure/
├── adapters/       # Implementaciones de puertos de salida
├── config/         # Configuración de Spring
├── controllers/    # Endpoints REST
├── entities/       # Entidades JPA
└── repositories/   # Implementaciones de repositorios
```

**Características**:
- Detalles de implementación técnica
- Acceso a bases de datos
- Controladores REST
- Configuración de Spring Security

## 📦 Dependencias Principales

### Stack Tecnológico

| Componente | Versión | Propósito |
|-----------|---------|----------|
| **Java** | 21 LTS | Lenguaje de programación |
| **Spring Boot** | 3.3.0 | Framework web |
| **Spring Data JPA** | 3.3.0 | Acceso a datos |
| **Spring Security** | 6.2.0 | Autenticación (users) |
| **H2 Database** | Latest | Base de datos en memoria |
| **MySQL Connector** | 8.0.33 | Driver MySQL |
| **Lombok** | Latest | Generación de código |
| **Maven** | 3.9.x | Build tool |

## 🧪 Pruebas

```bash
# Ejecutar todas las pruebas
./mvnw test

# Ejecutar pruebas de un módulo específico
./mvnw test -pl users-service

# Ver cobertura de código
./mvnw clean test jacoco:report
```

## 🐛 Troubleshooting

### Error: "Port already in use"

```bash
# Cambiar el puerto en application.properties
server.port=9081  # o cualquier puerto libre
```

### Error: "Cannot resolve symbol" con Lombok

Asegúrate que Lombok está en el pom.xml:

```xml
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <optional>true</optional>
</dependency>
```

### H2 Console no funciona

Verificar que `spring.h2.console.enabled=true` en application.properties

Acceso: `http://localhost:8081/h2-console`

## 📚 Recursos Útiles

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Hexagonal Architecture](https://www.alistair.cockburn.us/hexagonal-architecture/)
- [Spring Data JPA](https://spring.io/projects/spring-data-jpa)
- [Jakarta EE (formerly Java EE)](https://jakarta.ee/)

## 🤝 Contribuciones

Para hacer cambios:

1. Crear una rama: `git checkout -b feature/nueva-funcionalidad`
2. Hacer commits: `git commit -m "Agregar nueva funcionalidad"`
3. Push: `git push origin feature/nueva-funcionalidad`
4. Crear un Pull Request

## 📝 Licencia

Este proyecto está bajo licencia MIT.

---

**Versión**: 1.0.0  
**Actualizado**: 2025-11-11  
**Java**: 21 LTS  
**Spring Boot**: 3.3.0
