# 👤 Users Microservice

Microservicio de gestión de usuarios con arquitectura hexagonal.

## 🚀 Ejecutar

```bash
# 1. Crear base de datos
mysql -u root -p
CREATE DATABASE users_db;
EXIT;

# 2. Compilar
mvn clean install

# 3. Ejecutar
mvn spring-boot:run
```

## 📡 Endpoints

- `GET /users` - Listar usuarios
- `GET /users/{id}` - Obtener usuario
- `GET /users/{id}/exists` - Verificar existencia
- `POST /users` - Crear usuario
- `PUT /users/{id}` - Actualizar usuario
- `DELETE /users/{id}` - Eliminar usuario

## 🔧 Tecnologías

- Java 21
- Spring Boot 3.3.0
- MySQL
- Lombok
- Spring Security
