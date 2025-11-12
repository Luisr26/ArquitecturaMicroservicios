#!/bin/bash

# Comandos útiles para trabajar con el proyecto Arquitectura Hexagonal

echo "================================"
echo "Comandos útiles - Arquitectura Hexagonal Multi-Módulo"
echo "================================"
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funciones de ayuda
print_section() {
    echo -e "${BLUE}═══════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}═══════════════════════════════════${NC}"
}

print_command() {
    echo -e "${YELLOW}→${NC} $1"
    echo "  $2"
    echo ""
}

# 1. Compilación y Build
print_section "1. COMPILACIÓN Y BUILD"

print_command "Compilar todo el proyecto" \
    "./mvnw clean compile"

print_command "Compilar solo tasks-service" \
    "./mvnw clean compile -pl tasks-service"

print_command "Compilar solo users-service" \
    "./mvnw clean compile -pl users-service"

print_command "Empaquetar (generar JARs)" \
    "./mvnw clean package -DskipTests"

print_command "Limpiar todo" \
    "./mvnw clean"

# 2. Ejecución
print_section "2. EJECUCIÓN DE SERVICIOS"

print_command "Ejecutar Tasks Service (Maven)" \
    "./mvnw spring-boot:run -pl tasks-service"

print_command "Ejecutar Users Service (Maven)" \
    "./mvnw spring-boot:run -pl users-service"

print_command "Ejecutar Tasks Service (JAR directo)" \
    "java -jar tasks-service/target/tasks-service-1.0.0.jar"

print_command "Ejecutar Users Service (JAR directo)" \
    "java -jar users-service/target/users-service-1.0.0.jar"

print_command "Ejecutar ambos servicios (necesita 2 terminales)" \
    "Terminal 1: ./mvnw spring-boot:run -pl tasks-service && Terminal 2: ./mvnw spring-boot:run -pl users-service"

# 3. Tests
print_section "3. PRUEBAS"

print_command "Ejecutar todos los tests" \
    "./mvnw test"

print_command "Tests del tasks-service" \
    "./mvnw test -pl tasks-service"

print_command "Tests del users-service" \
    "./mvnw test -pl users-service"

print_command "Tests sin detener si hay fallos" \
    "./mvnw test -DfailIfNoTests=false"

# 4. Dependencias
print_section "4. DEPENDENCIAS"

print_command "Ver árbol de dependencias completo" \
    "./mvnw dependency:tree"

print_command "Ver árbol de dependencias de tasks-service" \
    "./mvnw dependency:tree -pl tasks-service"

print_command "Ver árbol de dependencias de users-service" \
    "./mvnw dependency:tree -pl users-service"

print_command "Buscar dependencias duplicadas" \
    "./mvnw dependency:analyze"

print_command "Actualizar dependencias (seco)" \
    "./mvnw versions:display-dependency-updates"

# 5. IDE y Desarrollo
print_section "5. IDE Y DESARROLLO"

print_command "Generar proyecto para Eclipse" \
    "./mvnw eclipse:eclipse"

print_command "Generar proyecto para IntelliJ IDEA" \
    "./mvnw idea:idea"

print_command "Formatter de código (si está configurado)" \
    "./mvnw spotless:apply"

print_command "Verificar estilo de código" \
    "./mvnw checkstyle:check"

# 6. Información del Proyecto
print_section "6. INFORMACIÓN DEL PROYECTO"

print_command "Ver propiedades del proyecto" \
    "./mvnw help:describe"

print_command "Ver versión de Maven" \
    "./mvnw --version"

print_command "Información de módulos" \
    "ls -la | grep -E 'service|pom.xml'"

print_command "Ver estructura del proyecto" \
    "find . -type f -name 'pom.xml'"

# 7. Debugging
print_section "7. DEBUGGING"

print_command "Ejecutar con debug en Tasks Service" \
    "./mvnw spring-boot:run -pl tasks-service -Dspring-boot.run.jvmArguments=-Xdebug"

print_command "Ejecutar con logging completo" \
    "./mvnw clean compile -X"

print_command "Ver errores de compilación detallados" \
    "./mvnw clean compile -e"

# 8. Git
print_section "8. CONTROL DE VERSIONES"

print_command "Estado de cambios" \
    "git status"

print_command "Ver últimos commits" \
    "git log --oneline -10"

print_command "Agregar todos los cambios" \
    "git add -A"

print_command "Hacer commit" \
    "git commit -m 'Mensaje descriptivo'"

print_command "Enviar cambios" \
    "git push"

# 9. Puertos y URLs
print_section "9. PUERTOS Y URLs"

echo -e "${GREEN}Tasks Service:${NC}"
echo "  URL: http://localhost:8081"
echo "  H2 Console: http://localhost:8081/h2-console"
echo ""

echo -e "${GREEN}Users Service:${NC}"
echo "  URL: http://localhost:8082"
echo "  H2 Console: http://localhost:8082/h2-console"
echo ""

# 10. Solución de Problemas
print_section "10. SOLUCIÓN DE PROBLEMAS"

print_command "Limpiar caché de Maven" \
    "rm -rf ~/.m2/repository"

print_command "Forzar descarga de dependencias" \
    "./mvnw clean dependency:resolve"

print_command "Matar procesos Java en puerto 8081" \
    "lsof -i :8081 | tail -1 | awk '{print \$2}' | xargs kill -9"

print_command "Matar procesos Java en puerto 8082" \
    "lsof -i :8082 | tail -1 | awk '{print \$2}' | xargs kill -9"

# 11. Docker (Opcional)
print_section "11. DOCKER (Opcional)"

print_command "Crear imagen Docker del tasks-service" \
    "docker build -f tasks-service/Dockerfile -t tasks-service:1.0.0 ."

print_command "Crear imagen Docker del users-service" \
    "docker build -f users-service/Dockerfile -t users-service:1.0.0 ."

print_command "Ejecutar en Docker Compose" \
    "docker-compose up -d"

# 12. Información Útil
print_section "12. INFORMACIÓN ÚTIL"

echo -e "${GREEN}Versiones utilizadas:${NC}"
echo "  Java: 21 LTS"
echo "  Spring Boot: 3.3.0"
echo "  Maven: 3.9.x"
echo ""

echo -e "${GREEN}Estructura de módulos:${NC}"
echo "  - tasks-service (Puerto 8081)"
echo "  - users-service (Puerto 8082)"
echo ""

echo -e "${GREEN}Arquitectura:${NC}"
echo "  - Hexagonal Pattern (Ports & Adapters)"
echo "  - Multi-módulo Maven"
echo "  - Separación: domain/application/infrastructure"
echo ""

echo -e "${GREEN}Base de Datos:${NC}"
echo "  - Desarrollo: H2 (en memoria)"
echo "  - Producción: MySQL (preparado)"
echo ""

print_section "FIN"
echo ""
echo "Para más información, ver:"
echo "  - SETUP.md (Guía completa de configuración)"
echo "  - STATUS.md (Estado detallado del proyecto)"
echo "  - RESUMEN_EJECUTIVO.md (Resumen de cambios)"
echo ""
