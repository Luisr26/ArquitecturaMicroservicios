#!/bin/bash

echo "════════════════════════════════════════════════════════════"
echo "🚀 CREANDO MICROSERVICIO DE USUARIOS COMPLETO (con POM)"
echo "════════════════════════════════════════════════════════════"
echo ""

# ============================================
# 0. CREAR pom.xml
# ============================================
cat > pom.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.3.0</version>
        <relativePath/>
    </parent>

    <groupId>com.exagonal</groupId>
    <artifactId>users-service</artifactId>
    <version>1.0.0</version>
    <name>Users Microservice</name>
    <description>Microservicio de gestión de usuarios</description>

    <properties>
        <java.version>21</java.version>
        <maven.compiler.source>21</maven.compiler.source>
        <maven.compiler.target>21</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>
        <!-- Spring Boot Web -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!-- Spring Data JPA -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>

        <!-- MySQL Driver -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <scope>runtime</scope>
        </dependency>

        <!-- Spring Security -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>

        <!-- Validation -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>

        <!-- Lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>

        <!-- Spring Boot DevTools -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
            <optional>true</optional>
        </dependency>

        <!-- Spring Boot Starter Test -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>

        <!-- Spring Security Test -->
        <dependency>
            <groupId>org.springframework.security</groupId>
            <artifactId>spring-security-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <excludes>
                        <exclude>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                        </exclude>
                    </excludes>
                    <mainClass>com.exagonal.users.UsersApplication</mainClass>
                </configuration>
            </plugin>

            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <source>21</source>
                    <target>21</target>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
EOF

echo "✅ pom.xml creado"

# ============================================
# 1. CREAR ESTRUCTURA DE CARPETAS
# ============================================
echo "📁 Creando estructura de carpetas..."

BASE_JAVA="src/main/java/com/exagonal/users"
BASE_TEST="src/test/java/com/exagonal/users"

mkdir -p $BASE_JAVA/{application/{services,usecases},domain/{model,ports/{in,out}},infrastructure/{adapters,config,controllers/{dto},entities,repositories,filters,services}}
mkdir -p src/main/resources/{static,templates}
mkdir -p $BASE_TEST/{unit,integration}
mkdir -p src/test/resources

echo "✅ Estructura de carpetas creada"

# ============================================
# 2. CREAR UsersApplication.java
# ============================================
cat > $BASE_JAVA/UsersApplication.java << 'EOF'
package com.exagonal.users;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class UsersApplication {
    public static void main(String[] args) {
        SpringApplication.run(UsersApplication.class, args);
    }
}
EOF

echo "✅ UsersApplication.java creado"

# ============================================
# 3. CREAR ENTIDADES
# ============================================
cat > $BASE_JAVA/infrastructure/entities/UserEntity.java << 'EOF'
package com.exagonal.users.infrastructure.entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(unique = true, nullable = false)
    private String email;

    @Column(nullable = false)
    private String password;

    private String role;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
EOF

echo "✅ UserEntity.java creado"

# ============================================
# 4. CREAR REPOSITORIO
# ============================================
cat > $BASE_JAVA/infrastructure/repositories/UserRepository.java << 'EOF'
package com.exagonal.users.infrastructure.repositories;

import com.exagonal.users.infrastructure.entities.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Long> {
    
    Optional<UserEntity> findByEmail(String email);
    
    boolean existsByEmail(String email);
}
EOF

echo "✅ UserRepository.java creado"

# ============================================
# 5. CREAR DTOs
# ============================================
cat > $BASE_JAVA/infrastructure/controllers/dto/UserDTO.java << 'EOF'
package com.exagonal.users.infrastructure.controllers.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserDTO {
    private Long id;
    private String name;
    private String email;
    private String role;
}
EOF

cat > $BASE_JAVA/infrastructure/controllers/dto/CreateUserRequest.java << 'EOF'
package com.exagonal.users.infrastructure.controllers.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class CreateUserRequest {
    
    @NotBlank(message = "Name is required")
    private String name;
    
    @Email(message = "Email must be valid")
    @NotBlank(message = "Email is required")
    private String email;
    
    @NotBlank(message = "Password is required")
    private String password;
    
    private String role;
}
EOF

cat > $BASE_JAVA/infrastructure/controllers/dto/UpdateUserRequest.java << 'EOF'
package com.exagonal.users.infrastructure.controllers.dto;

import jakarta.validation.constraints.Email;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UpdateUserRequest {
    
    private String name;
    
    @Email(message = "Email must be valid")
    private String email;
    
    private String role;
}
EOF

cat > $BASE_JAVA/infrastructure/controllers/dto/ErrorResponse.java << 'EOF'
package com.exagonal.users.infrastructure.controllers.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ErrorResponse {
    private String error;
    private int status;
    private LocalDateTime timestamp;
}
EOF

echo "✅ DTOs creados"

# ============================================
# 6. CREAR EXCEPCIONES
# ============================================
cat > $BASE_JAVA/application/services/ResourceNotFoundException.java << 'EOF'
package com.exagonal.users.application.services;

public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String message) {
        super(message);
    }
}
EOF

cat > $BASE_JAVA/application/services/DuplicateResourceException.java << 'EOF'
package com.exagonal.users.application.services;

public class DuplicateResourceException extends RuntimeException {
    public DuplicateResourceException(String message) {
        super(message);
    }
}
EOF

echo "✅ Excepciones creadas"

# ============================================
# 7. CREAR SERVICIO
# ============================================
cat > $BASE_JAVA/application/services/UserService.java << 'EOF'
package com.exagonal.users.application.services;

import com.exagonal.users.infrastructure.controllers.dto.CreateUserRequest;
import com.exagonal.users.infrastructure.controllers.dto.UpdateUserRequest;
import com.exagonal.users.infrastructure.controllers.dto.UserDTO;
import com.exagonal.users.infrastructure.entities.UserEntity;
import com.exagonal.users.infrastructure.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public List<UserDTO> getAllUsers() {
        return userRepository.findAll()
                .stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public UserDTO getUserById(Long id) {
        UserEntity user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));
        return mapToDTO(user);
    }

    @Transactional
    public UserDTO createUser(CreateUserRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new DuplicateResourceException("User already exists with email: " + request.getEmail());
        }

        UserEntity user = UserEntity.builder()
                .name(request.getName())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(request.getRole() != null ? request.getRole() : "user")
                .build();

        UserEntity savedUser = userRepository.save(user);
        return mapToDTO(savedUser);
    }

    @Transactional
    public UserDTO updateUser(Long id, UpdateUserRequest request) {
        UserEntity user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));

        if (request.getName() != null) {
            user.setName(request.getName());
        }
        if (request.getEmail() != null) {
            if (!user.getEmail().equals(request.getEmail()) && 
                userRepository.existsByEmail(request.getEmail())) {
                throw new DuplicateResourceException("Email already in use: " + request.getEmail());
            }
            user.setEmail(request.getEmail());
        }
        if (request.getRole() != null) {
            user.setRole(request.getRole());
        }

        UserEntity updatedUser = userRepository.save(user);
        return mapToDTO(updatedUser);
    }

    @Transactional
    public void deleteUser(Long id) {
        if (!userRepository.existsById(id)) {
            throw new ResourceNotFoundException("User not found with id: " + id);
        }
        userRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public boolean userExists(Long id) {
        return userRepository.existsById(id);
    }

    private UserDTO mapToDTO(UserEntity user) {
        return UserDTO.builder()
                .id(user.getId())
                .name(user.getName())
                .email(user.getEmail())
                .role(user.getRole())
                .build();
    }
}
EOF

echo "✅ UserService.java creado"

# ============================================
# 8. CREAR CONTROLADOR
# ============================================
cat > $BASE_JAVA/infrastructure/controllers/UserController.java << 'EOF'
package com.exagonal.users.infrastructure.controllers;

import com.exagonal.users.application.services.UserService;
import com.exagonal.users.infrastructure.controllers.dto.CreateUserRequest;
import com.exagonal.users.infrastructure.controllers.dto.UpdateUserRequest;
import com.exagonal.users.infrastructure.controllers.dto.UserDTO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/users")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping
    public ResponseEntity<List<UserDTO>> getAllUsers() {
        List<UserDTO> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserDTO> getUserById(@PathVariable Long id) {
        UserDTO user = userService.getUserById(id);
        return ResponseEntity.ok(user);
    }

    @GetMapping("/{id}/exists")
    public ResponseEntity<Map<String, Boolean>> userExists(@PathVariable Long id) {
        boolean exists = userService.userExists(id);
        return ResponseEntity.ok(Map.of("exists", exists));
    }

    @PostMapping
    public ResponseEntity<UserDTO> createUser(@Valid @RequestBody CreateUserRequest request) {
        UserDTO user = userService.createUser(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(user);
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserDTO> updateUser(
            @PathVariable Long id,
            @Valid @RequestBody UpdateUserRequest request) {
        UserDTO user = userService.updateUser(id, request);
        return ResponseEntity.ok(user);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return ResponseEntity.ok(Map.of("message", "User deleted successfully"));
    }
}
EOF

echo "✅ UserController.java creado"

# ============================================
# 9. CREAR MANEJADOR DE EXCEPCIONES
# ============================================
cat > $BASE_JAVA/infrastructure/config/GlobalExceptionHandler.java << 'EOF'
package com.exagonal.users.infrastructure.config;

import com.exagonal.users.application.services.DuplicateResourceException;
import com.exagonal.users.application.services.ResourceNotFoundException;
import com.exagonal.users.infrastructure.controllers.dto.ErrorResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleResourceNotFound(ResourceNotFoundException ex) {
        ErrorResponse error = ErrorResponse.builder()
                .error(ex.getMessage())
                .status(HttpStatus.NOT_FOUND.value())
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    @ExceptionHandler(DuplicateResourceException.class)
    public ResponseEntity<ErrorResponse> handleDuplicateResource(DuplicateResourceException ex) {
        ErrorResponse error = ErrorResponse.builder()
                .error(ex.getMessage())
                .status(HttpStatus.CONFLICT.value())
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.status(HttpStatus.CONFLICT).body(error);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidationExceptions(
            MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });

        Map<String, Object> response = new HashMap<>();
        response.put("error", "Validation failed");
        response.put("status", HttpStatus.BAD_REQUEST.value());
        response.put("timestamp", LocalDateTime.now());
        response.put("details", errors);

        return ResponseEntity.badRequest().body(response);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGenericException(Exception ex) {
        ErrorResponse error = ErrorResponse.builder()
                .error("Internal server error: " + ex.getMessage())
                .status(HttpStatus.INTERNAL_SERVER_ERROR.value())
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }
}
EOF

echo "✅ GlobalExceptionHandler.java creado"

# ============================================
# 10. CREAR CONFIGURACIÓN DE SEGURIDAD
# ============================================
cat > $BASE_JAVA/infrastructure/config/SecurityConfig.java << 'EOF'
package com.exagonal.users.infrastructure.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .anyRequest().permitAll()
            );
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
EOF

echo "✅ SecurityConfig.java creado"

# ============================================
# 11. CREAR application.yml
# ============================================
cat > src/main/resources/application.yml << 'EOF'
spring:
  application:
    name: users-service
  
  datasource:
    url: jdbc:mysql://localhost:3306/users_db?useSSL=false&serverTimezone=UTC
    username: root
    password: Qwe.123*
  
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQLDialect

server:
  port: 8081

logging:
  level:
    com.exagonal.users: DEBUG
EOF

echo "✅ application.yml creado"

# ============================================
# 12. CREAR TEST
# ============================================
cat > $BASE_TEST/UsersApplicationTests.java << 'EOF'
package com.exagonal.users;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class UsersApplicationTests {

    @Test
    void contextLoads() {
    }
}
EOF

echo "✅ Test creado"

# ============================================
# 13. CREAR .gitignore
# ============================================
cat > .gitignore << 'EOF'
# Compiled class file
*.class

# Log file
*.log

# Maven
target/
pom.xml.tag
pom.xml.releaseBackup
pom.xml.versionsBackup
.mvn/

# IntelliJ IDEA
.idea/
*.iws
*.iml
*.ipr

# Eclipse
.project
.classpath
.settings/

# VS Code
.vscode/

# macOS
.DS_Store

# Application properties with secrets
application-local.yml
EOF

echo "✅ .gitignore creado"

# ============================================
# 14. CREAR README.md
# ============================================
cat > README.md << 'EOF'
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
EOF

echo "✅ README.md creado"

# ============================================
# RESUMEN FINAL
# ============================================
echo ""
echo "════════════════════════════════════════════════════════════"
echo "✅ MICROSERVICIO DE USUARIOS CREADO EXITOSAMENTE"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "📦 Archivos creados:"
echo "   ✓ pom.xml"
echo "   ✓ UsersApplication.java"
echo "   ✓ UserEntity.java"
echo "   ✓ UserRepository.java"
echo "   ✓ UserService.java"
echo "   ✓ UserController.java"
echo "   ✓ DTOs completos"
echo "   ✓ GlobalExceptionHandler.java"
echo "   ✓ SecurityConfig.java"
echo "   ✓ application.yml"
echo "   ✓ .gitignore"
echo "   ✓ README.md"
echo ""
echo "📝 Siguientes pasos:"
echo "   1. CREATE DATABASE users_db;"
echo "   2. mvn clean install"
echo "   3. mvn spring-boot:run"
echo ""
echo "📍 Servicio: http://localhost:8081"
echo ""
echo "════════════════════════════════════════════════════════════"