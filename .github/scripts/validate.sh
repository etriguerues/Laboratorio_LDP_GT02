#!/bin/bash
export LANG=C.UTF-8

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0;0m' 

echo "--------------------------------------------------------"
echo "Validación Lab: Semáforo Inteligente (Python)"
echo "--------------------------------------------------------"

FAILED=0
FILE_PY=$(find . -name "*.py" | head -n 1)
[ -z "$FILE_PY" ] && { echo -e "${RED}[ERROR] Sin archivo .py.${NC}"; exit 1; }
echo -e "Archivo detectado: ${YELLOW}$FILE_PY${NC}\n"

# --- PASO 1: FUNCION Y GUARDA ---
echo -e "${YELLOW}PASO 1: Verificando Función y Cláusula de Guarda...${NC}"
if grep -qE "def\s+accion_luz" "$FILE_PY" && grep -qE "if\s+.*==\s*[\"']Parpadeo[\"']:" "$FILE_PY"; then echo -e "${GREEN}[OK] Función y cláusula de guarda correctas.${NC}"; else echo -e "${RED}[ERROR] Falta accion_luz o el if de guarda ('Parpadeo').${NC}"; FAILED=1; fi

# --- PASO 2: PATTERN MATCHING ---
echo -e "\n${YELLOW}PASO 2: Verificando Pattern Matching...${NC}"
if grep -qE "match\s+" "$FILE_PY" && grep -qE "case\s+[\"']Verde[\"']:" "$FILE_PY" && grep -qE "case\s+_:" "$FILE_PY"; then echo -e "${GREEN}[OK] Estructura match-case detectada.${NC}"; else echo -e "${RED}[ERROR] No se estructuró correctamente el match o los cases.${NC}"; FAILED=1; fi

# --- PASO 3: CICLOS FOR Y WHILE ---
echo -e "\n${YELLOW}PASO 3: Verificando Ciclos (for y while)...${NC}"
if grep -qE "for\s+.*\s+in\s+luces:" "$FILE_PY" && grep -qE "while\s+tiempo_cruce\s*>\s*0:" "$FILE_PY"; then echo -e "${GREEN}[OK] Ciclos for y while implementados.${NC}"; else echo -e "${RED}[ERROR] Error en el 'for' de luces o el 'while' de tiempo_cruce.${NC}"; FAILED=1; fi

# --- PASO 4: CORTOCIRCUITO Y TERNARIO ---
echo -e "\n${YELLOW}PASO 4: Verificando Cortocircuito y Operador Ternario...${NC}"
if grep -qE "if\s+.*\s+or\s+peatones_esperando:" "$FILE_PY"; then echo -e "${GREEN}[OK] Cortocircuito con 'or' detectado.${NC}"; else echo -e "${RED}[ERROR] Falta el 'if' usando el operador 'or'.${NC}"; FAILED=1; fi
if grep -qE "estado_calle\s*=\s*[\"'].*[\"']\s+if\s+.*\s+else\s+[\"'].*[\"']" "$FILE_PY"; then echo -e "${GREEN}[OK] Ternario asignado a estado_calle detectado.${NC}"; else echo -e "${RED}[ERROR] No se usó sintaxis ternaria para estado_calle.${NC}"; FAILED=1; fi

# --- PASO 5: COMPILACIÓN Y SINTAXIS ---
echo -e "\n${YELLOW}PASO 5: Verificando sintaxis de Python...${NC}"
if python3 -m py_compile "$FILE_PY" 2>/dev/null; then echo -e "${GREEN}[OK] Sintaxis correcta.${NC}"; else echo -e "${RED}[ERROR] Error de sintaxis.${NC}"; python3 -m py_compile "$FILE_PY"; FAILED=1; fi

[ $FAILED -eq 0 ] && { echo -e "\n${GREEN}✔ LABORATORIO 2 APROBADO${NC}"; exit 0; } || { echo -e "\n${RED}✘ LAB FALLIDO${NC}"; exit 1; }