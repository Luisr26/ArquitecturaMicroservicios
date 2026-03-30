# Arquitectura Microservicios

[![Java](https://img.shields.io/badge/Java_21-ED8B00?style=flat-square&logo=openjdk&logoColor=white)]()
[![Spring Boot](https://img.shields.io/badge/Spring_Boot_3.3-6DB33F?style=flat-square&logo=springboot&logoColor=white)]()
[![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white)]()
[![Spring Security](https://img.shields.io/badge/Spring_Security-6DB33F?style=flat-square&logo=springsecurity&logoColor=white)]()

Distributed microservices architecture project built with Java 21 and Spring Boot 3.3. Implements hexagonal architecture, inter-service communication, and user management with Spring Security.

---

## Architecture overview

```
                    ┌──────────────┐
                    │  API Gateway │
                    └──────┬───────┘
                           │
            ┌──────────────┼──────────────┐
            │              │              │
     ┌──────▼──────┐ ┌────▼───────┐ ┌────▼───────┐
     │    Users     │ │  Service B │ │  Service C │
     │ Microservice │ │            │ │            │
     │  (Hexagonal) │ │            │ │            │
     └──────┬───────┘ └────┬───────┘ └────┬───────┘
            │              │              │
     ┌──────▼──────────────▼──────────────▼──────┐
     │               MySQL Database              │
     └───────────────────────────────────────────┘
```

## Users microservice endpoints

| Method | Endpoint | Description |
|:---|:---|:---|
| `GET` | `/users` | List all users |
| `GET` | `/users/{id}` | Get user by ID |
| `GET` | `/users/{id}/exists` | Check if user exists |
| `POST` | `/users` | Create user |
| `PUT` | `/users/{id}` | Update user |
| `DELETE` | `/users/{id}` | Delete user |

## Tech stack

| Component | Technology |
|:---|:---|
| Language | Java 21 |
| Framework | Spring Boot 3.3.0 |
| Security | Spring Security |
| Database | MySQL |
| ORM | Spring Data JPA |
| Utilities | Lombok |
| Architecture | Hexagonal (Ports & Adapters) |
| Build | Maven |

## Getting started

```bash
# 1. Create database
mysql -u root -p
CREATE DATABASE users_db;
EXIT;

# 2. Build
mvn clean install

# 3. Run
mvn spring-boot:run
```

## Author

**Luis Alfredo Orozco Sanchez** — [GitHub](https://github.com/Luisr26)
