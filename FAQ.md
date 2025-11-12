# ❓ Preguntas Frecuentes (FAQ)

## Preguntas sobre la Estructura

### ¿Por qué se reorganizó el proyecto?
La reorganización a multi-módulo Maven permite:
- **Independencia**: Cada microservicio es independiente
- **Escalabilidad**: Fácil agregar nuevos servicios
- **Desarrollo paralelo**: Equipos pueden trabajar en diferentes servicios
- **Despliegue independiente**: Cada servicio se despliega por separado
- **Mantenibilidad**: Código más limpio y organizado

### ¿Cuál es la diferencia entre tasks-service y users-service?
- **tasks-service**: Gestiona tareas del sistema
  - Puerto: 8081
  - Arquitectura: Hexagonal con ports/adapters
  - Funcionalidades: CRUD de tareas, búsqueda, filtrado

- **users-service**: Gestiona usuarios y autenticación
  - Puerto: 8082
  - Arquitectura: Hexagonal con Spring Security
  - Funcionalidades: CRUD de usuarios, autenticación, roles

### ¿Cómo agregar un nuevo microservicio?
1. Copiar estructura de `tasks-service` o `users-service`
2. Cambiar `artifactId` en el nuevo `pom.xml`
3. Actualizar padre `pom.xml`:
   ```xml
   <modules>
       <module>tasks-service</module>
       <module>users-service</module>
       <module>nuevo-service</module>  <!-- Agregar aquí -->
   </modules>
   ```
4. Cambiar puerto en `application.properties`

---

## Preguntas sobre Java y Spring Boot

### ¿Por qué Java 21 LTS?
- **LTS (Long Term Support)**: Soporte extendido hasta 2031
- **Moderno**: Últimas features del lenguaje
- **Performance**: Mejoras significativas de rendimiento
- **Seguridad**: Parches de seguridad por más tiempo
- **Compatible**: Spring Boot 3.3.0 soporta Java 21

### ¿Por qué Spring Boot 3.3.0?
- **Última versión estable**: Más features y mejoras
- **Jakarta EE**: Compatible con Java 21
- **Spring Security 6.2**: Seguridad mejorada
- **Performance**: Optimizaciones de rendimiento
- **Features**: Nuevas capacidades para microservicios

### ¿Qué es jakarta.persistence?
Es el sucesor de `javax.persistence`. En Java 21:
- `javax.persistence` fue descontinuado
- `jakarta.persistence` es el estándar actual
- Cambio obligatorio para compatibilidad

### ¿Cómo cambio la versión de Java?
1. Editar `pom.xml` (padre):
   ```xml
   <properties>
       <java.version>17</java.version>  <!-- Cambiar versión -->
       <maven.compiler.source>17</maven.compiler.source>
       <maven.compiler.target>17</maven.compiler.target>
   </properties>
   ```
2. Instalar el JDK correspondiente
3. Recompilar: `./mvnw clean compile`

---

## Preguntas sobre Base de Datos

### ¿Por qué H2 para desarrollo?
- **Sin instalación**: No requiere MySQL/PostgreSQL instalado
- **En memoria**: Base de datos temporal, se reinicia
- **Rápido**: Perfecto para desarrollo y testing
- **Fácil cambio**: Simple migrar a MySQL después

### ¿Cómo cambio a MySQL?
1. Asegúrate que MySQL está instalado y corriendo
2. Crea la base de datos:
   ```sql
   CREATE DATABASE tasks_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   CREATE DATABASE users_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```

3. Edita `application.properties` en cada servicio:
   ```properties
   # De:
   spring.datasource.url=jdbc:h2:mem:testdb
   
   # A:
   spring.datasource.url=jdbc:mysql://localhost:3306/tasks_db
   spring.datasource.username=root
   spring.datasource.password=tu_contraseña
   spring.datasource.driverClassName=com.mysql.cj.jdbc.Driver
   spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
   spring.jpa.hibernate.ddl-auto=update
   ```

4. Acceso a H2 Console desaparece (MySQL no tiene console integrada)

### ¿Cómo acceso la base de datos H2?
1. Inicia el servicio
2. Abre http://localhost:8081/h2-console (o 8082 para users)
3. Verifica credenciales:
   - Driver: `org.h2.Driver`
   - URL: `jdbc:h2:mem:testdb`
   - Usuario: `sa`
   - Contraseña: (vacío)

### ¿Los datos en H2 se pierden?
Sí, H2 en memoria:
- Se reinicia cada vez que inicias el servicio
- Usa `spring.jpa.hibernate.ddl-auto=create-drop` (crea esquema al iniciar)
- Para persistencia, usa MySQL o PostgreSQL

---

## Preguntas sobre Compilación y Build

### ¿Cómo hago compile sin tests?
```bash
./mvnw clean compile -DskipTests
```

### ¿Cómo genero los JARs?
```bash
./mvnw clean package -DskipTests
```
Los JARs se crean en:
- `tasks-service/target/tasks-service-1.0.0.jar`
- `users-service/target/users-service-1.0.0.jar`

### ¿Qué significa BUILD SUCCESS?
Significa que:
- ✅ Compilación exitosa
- ✅ Sin errores de sintaxis
- ✅ Todas las dependencias resueltas
- ✅ Código empaquetado correctamente

### ¿Qué hago si BUILD FAILURE?
1. Lee el mensaje de error
2. Verifica las dependencias: `./mvnw dependency:tree`
3. Limpia y recompila: `./mvnw clean compile`
4. Limpia caché si es necesario: `rm -rf ~/.m2/repository`

---

## Preguntas sobre Ejecución

### ¿Cómo ejecuto los servicios?
**Opción 1 - Maven**:
```bash
# Terminal 1
./mvnw spring-boot:run -pl tasks-service

# Terminal 2
./mvnw spring-boot:run -pl users-service
```

**Opción 2 - JAR directo**:
```bash
java -jar tasks-service/target/tasks-service-1.0.0.jar
java -jar users-service/target/users-service-1.0.0.jar
```

### ¿Cómo verifico que el servicio está corriendo?
```bash
# En otra terminal:
curl http://localhost:8081/actuator/health
curl http://localhost:8082/actuator/health

# Respuesta esperada:
{"status":"UP"}
```

### ¿Error "Port already in use"?
Significa que el puerto está ocupado:
```bash
# Encontrar qué proceso usa el puerto
lsof -i :8081

# Matar el proceso
kill -9 <PID>

# O cambiar el puerto en application.properties
server.port=9081
```

### ¿El servicio no inicia?
1. Verifica que Java 21 está instalado: `java -version`
2. Revisa los logs de error
3. Asegúrate que los puertos 8081/8082 están libres
4. Verifica la configuración de base de datos

---

## Preguntas sobre Arquitectura Hexagonal

### ¿Qué es Hexagonal Architecture?
Un patrón que separa:
- **Domain**: Lógica de negocio (sin dependencias externas)
- **Application**: Casos de uso y servicios
- **Infrastructure**: Detalles técnicos (BD, REST, etc.)

Beneficios:
- Fácil de testear
- Independiente de frameworks
- Mantenible y escalable

### ¿Dónde pongo mi lógica de negocio?
En `domain/`:
- `domain/model/` - Entidades y objetos de valor
- `domain/ports/in/` - Contratos de entrada (use cases)
- `domain/ports/out/` - Contratos de salida (repositorios)

### ¿Dónde van los controladores REST?
En `infrastructure/controllers/`:
- Reciben requests HTTP
- Llaman a servicios de aplicación
- Retornan DTOs

### ¿Dónde va la conexión a BD?
En `infrastructure/repositories/`:
- Implementan los puertos de salida
- Usan JPA/Hibernate
- Retornan entidades del dominio

---

## Preguntas sobre Maven

### ¿Qué es Maven Wrapper?
- Script (`mvnw`/`mvnw.cmd`) que descarga Maven automáticamente
- No necesitas instalar Maven manualmente
- Asegura que todos usen la misma versión

### ¿Cómo actualizo las dependencias?
```bash
# Ver actualizaciones disponibles
./mvnw versions:display-dependency-updates

# Actualizar automáticamente
./mvnw versions:use-latest-versions
```

### ¿Cómo agrego una dependencia nueva?
1. Encuentra el artifactId en [Maven Central](https://mvnrepository.com/)
2. Agrega al `pom.xml`:
   ```xml
   <dependency>
       <groupId>org.example</groupId>
       <artifactId>library</artifactId>
       <version>1.0.0</version>
   </dependency>
   ```
3. Recompila: `./mvnw clean compile`

### ¿Cómo creo un módulo de bibliotecas comunes?
1. Crear directorio: `mkdir common-library`
2. Crear `common-library/pom.xml` como módulo hijo
3. Agregar a modules en pom.xml padre
4. Los otros módulos pueden depender de él

---

## Preguntas sobre Git

### ¿Cómo hago un commit?
```bash
git add -A
git commit -m "Descripción del cambio"
git push
```

### ¿Cuál fue el último cambio?
```bash
git log --oneline -5
```

### ¿Cómo veo los cambios sin hacer commit?
```bash
git diff
```

---

## Preguntas sobre Desarrollo

### ¿Cómo escribo tests?
1. Crea test en: `src/test/java/com/exagonal/tasks/...Test.java`
2. Usa JUnit 5 y Mockito:
   ```java
   @Test
   void testExample() {
       // Arrange
       // Act
       // Assert
   }
   ```
3. Ejecuta: `./mvnw test`

### ¿Cómo hago debugging?
```bash
# Ejecutar con debug
./mvnw spring-boot:run -pl tasks-service \
    -Dspring-boot.run.jvmArguments=-Xdebug
```

Luego conecta tu IDE en puerto 5005.

### ¿Cómo agrego logging?
```java
private static final Logger log = LoggerFactory.getLogger(MyClass.class);

log.info("Mensaje informativo");
log.warn("Advertencia");
log.error("Error");
```

---

## Preguntas sobre Seguridad (Users Service)

### ¿Cómo funciona Spring Security?
Users Service incluye Spring Security para:
- Autenticación de usuarios
- Autorización basada en roles
- Protección de endpoints

### ¿Cómo agrego autenticación a Tasks Service?
Similar a users-service:
1. Agregar dependencia en `pom.xml`:
   ```xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-security</artifactId>
   </dependency>
   ```
2. Crear `SecurityConfig.java`
3. Definir rutas protegidas

---

## Preguntas sobre Performance

### ¿Cómo mejoro la performance?
1. **Índices en BD**: Agregar índices en columnas frecuentes
2. **Caché**: Usar `@Cacheable` en servicios
3. **Lazy Loading**: Cuidado con relaciones en JPA
4. **Connection Pool**: Configurar en `application.properties`
5. **Logging**: Reducir nivel en producción

### ¿Cómo monitoreo performance?
```bash
# Ver uso de memoria
jcmd <PID> VM.native_memory summary

# Ver estadísticas de GC
jstat -gc <PID> 1000
```

---

## Preguntas sobre Despliegue

### ¿Cómo despliego a producción?
1. Cambiar a MySQL en `application.properties`
2. Generar JAR: `./mvnw clean package`
3. Copiar JAR a servidor
4. Ejecutar: `java -jar service-1.0.0.jar`

### ¿Cómo uso variables de entorno?
```properties
spring.datasource.url=${DB_URL:jdbc:h2:mem:testdb}
spring.datasource.username=${DB_USER:sa}
spring.datasource.password=${DB_PASSWORD:}
```

Ejecutar:
```bash
java -jar app.jar --DB_URL=jdbc:mysql://...
```

---

## Preguntas sobre Troubleshooting

### El proyecto no compila
1. `./mvnw clean`
2. `rm -rf ~/.m2/repository`
3. `./mvnw compile`

### El servicio no inicia
1. Ver logs completos: revisar consola
2. Verificar configuración de BD
3. Asegurar que puertos están libres

### Los tests fallan
1. Ejecutar en aislamiento: `./mvnw test -Dtest=NombreTest`
2. Aumentar timeout si es necesario
3. Verificar que H2 está configurado para tests

---

## Recursos Adicionales

- **Documentación**: Ver `SETUP.md` y `STATUS.md`
- **Spring Boot Docs**: https://spring.io/projects/spring-boot
- **Hexagonal Architecture**: https://www.alistair.cockburn.us/hexagonal-architecture/
- **Maven Guide**: https://maven.apache.org/guides/
- **Jakarta EE**: https://jakarta.ee/

---

**¿No encontraste tu pregunta?**

Abre una issue o contacta al equipo de desarrollo. 

¡Feliz coding! 🚀
