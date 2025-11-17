# Karate API Testing Framework - ParaBank

Proyecto  para el sistema bancario ParaBank.
Proyecto de automatización de pruebas de API REST utilizando Karate Framework para la aplicación ParaBank. Este repositorio contiene pruebas diseñadas para validar algunos requisitos funcionales.

## Descripción

Este proyecto implementa un conjunto de pruebas automatizadas para validar la API REST de ParaBank, un sistema bancario de demostración. Las pruebas cubren funcionalidades críticas como autenticación, consulta de cuentas, transferencias, pagos de facturas y solicitudes de préstamos.

## 🛠 Tecnologías

- **Java**: 8
- **Karate**: 1.3.1
- **Maven**: 3.x
- **JUnit**: 5
- **Cucumber Reporting**: 5.7.4
- **JavaFaker**: 1.0.2 (generación de datos de prueba)

## Requisitos Previos

- Java JDK 8 o superior
- Maven 3.x

## Instalación
```bash
# Clonar el repositorio
git clone <url-del-repositorio>

# Navegar al directorio del proyecto
cd karate-api-framework

# Instalar dependencias
mvn clean install
```

## Estructura del Proyecto
```
karate-api-framework/
├── .github/
│   └── workflows/
│       └── Karate.yml          # Pipeline de CI/CD
├── src/
│   └── test/
│       └── java/
│           ├── karate-config.js         # Configuración global
│           ├── logback-test.xml         # Configuración de logs
│           └── org/udea/parabank/
│               ├── TestRunner.java      # Ejecutor secuencial
│               ├── TestRunnerParallel.java  # Ejecutor paralelo
│               ├── login.feature        # Pruebas de autenticación
│               ├── accounts.feature     # Pruebas de consulta de cuentas
│               ├── TransferFunds.feature    # Pruebas de transferencias
│               ├── BillPay.feature      # Pruebas de pago de facturas
│               ├── Loans.feature        # Pruebas de préstamos
│               └── verifyDebit.feature  # Verificación de transacciones
└── pom.xml
```

## Historias de Usuario

### 1. Login Válido

**Como** tester de backend,  
**quiero** validar que el servicio de login devuelve un token/autenticación válida,  
**para** permitir acceso a usuarios correctos.

**Criterios de aceptación:**
- Petición GET con credenciales válidas
- Respuesta 200 OK
- Presencia de token de sesión o redirección válida

**implementación:** `login.feature`

### 2. Consulta de Cuentas

**Como** tester de backend,  
**quiero** obtener los datos de las cuentas del usuario,  
**para** verificar que el API devuelve información precisa.

**Criterios de aceptación:**
- GET a `/services/bank/customers/{id}/accounts`
- Respuesta incluye cuentas con balance, tipo y número
- Status 200 y contenido JSON estructurado

**implementación:** `accounts.feature`

### 3. Transferencia entre Cuentas

**Como** tester de backend,  
**quiero** enviar una solicitud de transferencia,  
**para** comprobar que el backend procesa y registra la operación.

**Criterios de aceptación:**
- POST a `/services/bank/transfer`
- Cuerpo con cuenta origen, destino y monto
- Validación de saldo
- Respuesta 200 con mensaje de éxito

**implementación:** `TransferFunds.feature`

### 4. Pago Fallido por Saldo Insuficiente

**Como** tester de backend,  
**quiero** simular un pago con saldo insuficiente,  
**para** verificar la lógica de validación.

**Criterios de aceptación:**
- POST a `/services/bank/billpay`
- Monto mayor al saldo disponible
- Respuesta 400 o 422 con error descriptivo

**implementación:** `BillPay.feature`

### 5. Simulación de Préstamo

**Como** tester de backend,  
**quiero** enviar una solicitud de préstamo,  
**para** evaluar si el sistema responde correctamente.

**Criterios de aceptación:**
- POST con monto, cuenta y duración
- Respuesta 200 con detalles de aprobación o rechazo
- Campos de validación como historial, ingresos, etc.

**implementación:** `Loans.feature`

## Ejecución de Pruebas

### Ejecutar todas las pruebas
```bash
mvn clean test
```

### Ejecución Individual
```bash
#1. Login
mvn test -Dtest=TestRunner#test01_ParabankLogin

#2. Transfer Funds (Transferencias)
mvn test -Dtest=TestRunner#test02_ParabankTransferFunds

#3. Accounts (Cuentas)
mvn test -Dtest=TestRunner#test03_ParabankAccounts

#4. Bill Pay (Pago de Facturas)
mvn test -Dtest=TestRunner#test04_ParabankBillPay

#5. Loans (Préstamos)
mvn test -Dtest=TestRunner#test05_ParabankLoans
```

### Ejecución Paralela
```bash
mvn test -Dtest=TestRunnerParallel
```

## Reportes

Después de ejecutar las pruebas, los reportes se generan en:

- **Karate JSON**: `target/karate-reports/`

## Configuración

### Entornos

El archivo `karate-config.js` permite configurar diferentes entornos:
```javascript
// Desarrollo local
var protocol = 'http';
var server = '192.168.0.182:8080';

// Producción
if (karate.env == 'prod') {
    protocol = 'https';
    server = 'parabank.parasoft.com';
}
```

### Timeouts

Los timeouts están configurados en `karate-config.js`:
```javascript
karate.configure('connectTimeout', 5000);
karate.configure('readTimeout', 5000);
```

## CI/CD

El proyecto incluye un workflow de GitHub Actions (`.github/workflows/Karate.yml`) que:

1. Se ejecuta automáticamente en push a `main` o ramas `feature/**`
2. Configura JDK 8
3. Ejecuta todas las pruebas
4. Genera reportes JUnit
5. Publica resultados de pruebas

**Nota**: Este proyecto es con fines educativos y utiliza la aplicación de demostración ParaBank de Parasoft.
