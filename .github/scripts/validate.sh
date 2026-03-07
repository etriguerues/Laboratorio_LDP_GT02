#!/bin/bash
export LANG=C.UTF-8

# Colores para la salida en consola
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0;0m' # Sin color

echo "--------------------------------------------------------"
echo "Iniciando validación: Algoritmo Cajero Automático (PIN)"
echo "--------------------------------------------------------"

# Variable de control de errores
FAILED=0

# Buscar el archivo .psc
FILE_PSC=$(find . -name "*.psc" | head -n 1)

if [ -z "$FILE_PSC" ]; then
    echo -e "${RED}[ERROR] No se encontró ningún archivo .psc (PSeInt).${NC}"
    exit 1
fi

echo -e "Archivo detectado: ${YELLOW}$FILE_PSC${NC}"

# --- PASO 1: VERIFICAR FUNCIÓN OBLIGATORIA ---
echo -e "\n${YELLOW}PASO 1: Verificando Función VerificarPIN...${NC}"

# Validar definición de la función y parámetros
if grep -qi "Funcion.*VerificarPIN" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] Función 'VerificarPIN' detectada.${NC}"
else
    echo -e "${RED}[ERROR] No se encontró la función obligatoria 'VerificarPIN'.${NC}"
    FAILED=1
fi

# Validar que retorne un valor Lógico (Verdadero/Falso)
if grep -qi "Como Logico" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] Definición de retorno Lógico encontrada.${NC}"
else
    echo -e "${RED}[ERROR] No se detectó la definición de retorno 'Como Logico'.${NC}"
    FAILED=1
fi

# --- PASO 2: VERIFICAR VARIABLES Y VALORES INICIALES ---
echo -e "\n${YELLOW}PASO 2: Verificando Inicialización de Variables...${NC}"

# Verificar PIN_CORRECTO = 1234
if grep -q "1234" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] PIN inicializado correctamente (1234).${NC}"
else
    echo -e "${RED}[ERROR] No se encontró el PIN_CORRECTO con valor 1234.${NC}"
    FAILED=1
fi

# Verificar contador de intentos iniciando en 1
if grep -qE "intentos\s*<-\s*1" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] Contador 'intentos' inicia en 1.${NC}"
else
    echo -e "${RED}[ERROR] El contador 'intentos' debe iniciar en 1.${NC}"
    FAILED=1
fi

# --- PASO 3: LÓGICA DEL BUCLE MIENTRAS ---
echo -e "\n${YELLOW}PASO 3: Verificando Ciclo de Intentos...${NC}"

# Validar condición doble: intentos <= 3 Y login_exitoso = Falso
if grep -qiE "Mientras.*intentos.*<=.*3.*Y.*login_exitoso.*=.*Falso" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] Condición del ciclo Mientras correcta (Intentos + Bandera).${NC}"
else
    echo -e "${RED}[ERROR] El ciclo Mientras debe validar (intentos <= 3) Y (login_exitoso = Falso).${NC}"
    FAILED=1
fi

# Validar incremento del contador
if grep -qE "intentos\s*<-\s*intentos\s*\+\s*1" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] Incremento de intentos detectado.${NC}"
else
    echo -e "${RED}[ERROR] No se encontró el incremento del contador: intentos <- intentos + 1.${NC}"
    FAILED=1
fi

# --- PASO 4: MENSAJES FINALES ---
echo -e "\n${YELLOW}PASO 4: Verificando Mensajes de Salida...${NC}"

if grep -qi "Acceso Concedido" "$FILE_PSC" && grep -qi "Tarjeta Bloqueada" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] Mensajes de 'Acceso Concedido' y 'Tarjeta Bloqueada' configurados.${NC}"
else
    echo -e "${RED}[ERROR] Faltan los mensajes finales de diagnóstico (Acceso/Bloqueo).${NC}"
    FAILED=1
fi

# --- RESULTADO FINAL ---
echo -e "\n--------------------------------------------------------"
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✔ LABORATORIO: CAJERO APROBADO${NC}"
    exit 0
else
    echo -e "${RED}✘ SE ENCONTRARON DEFICIENCIAS EN LA LÓGICA${NC}"
    exit 1
fi
