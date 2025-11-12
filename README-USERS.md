# 👤 Users Microservice

Microservicio de gestión de usuarios.

## 🚀 Ejecutar

```bash
# Crear base de datos
CREATE DATABASE users_db;

# Ejecutar el servicio
mvn spring-boot:run -Dspring-boot.run.main-class=com.exagonal.users.UsersApplication
```

## 📡 Endpoints

- `GET /users` - Listar usuarios
- `GET /users/{id}` - Obtener usuario
- `GET /users/{id}/exists` - Verificar si existe
- `POST /users` - Crear usuario
- `PUT /users/{id}` - Actualizar usuario
- `DELETE /users/{id}` - Eliminar usuario

## Ejemplo de request:

```json
POST /users
{
  "name": "Javier Ariza",
  "email": "javier@example.com",
  "password": "password123",
  "role": "developer"
}
```
