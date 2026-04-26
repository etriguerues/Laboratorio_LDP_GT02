#!/bin/bash
export LANG=C.UTF-8

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0;0m' 

echo "--------------------------------------------------------"
echo "Validación Lab : Bonificaciones (Python)"
echo "--------------------------------------------------------"

FAILED=0
FILE_PY=$(find . -name "*.py" | head -n 1)
[ -z "$FILE_PY" ] && { echo -e "${RED}[ERROR] Sin archivo .py.${NC}"; exit 1; }
echo -e "Archivo detectado: ${YELLOW}$FILE_PY${NC}\n"

# --- PASO 1: VARIABLES GLOBALES Y SRP ---
echo -e "${YELLOW}PASO 1: Verificando variables globales y función SRP...${NC}"
if grep -qE "registro_bonos\s*=\s*\[\]" "$FILE_PY" && grep -qE "def\s+calcular_bono_base" "$FILE_PY"; then echo -e "${GREEN}[OK] Variables y función pura iniciales correctas.${NC}"; else echo -e "${RED}[ERROR] Falta 'registro_bonos = []' o la función 'calcular_bono_base'.${NC}"; FAILED=1; fi

# --- PASO 2: FUNCIONES ANIDADAS Y RECURSIVIDAD ---
echo -e "\n${YELLOW}PASO 2: Verificando Función Anidada, Caso Base y Recursividad...${NC}"
if grep -qE "def\s+procesar_semestre" "$FILE_PY" && grep -qE "def\s+asignar_recursivo" "$FILE_PY"; then echo -e "${GREEN}[OK] Encapsulamiento con función anidada detectado.${NC}"; else echo -e "${RED}[ERROR] Faltan 'procesar_semestre' o 'asignar_recursivo'.${NC}"; FAILED=1; fi

if grep -qE "if\s+.*==\s*0:" "$FILE_PY" && grep -qE "return" "$FILE_PY" && grep -qE "asignar_recursivo\(.*\)" "$FILE_PY"; then echo -e "${GREEN}[OK] Recursividad controlada por caso base (0).${NC}"; else echo -e "${RED}[ERROR] Problema con la condición de detención (caso base) o la recursión.${NC}"; FAILED=1; fi

# --- PASO 3: TRAMPA DE REASIGNACIÓN (VALOR VS REFERENCIA) ---
echo -e "\n${YELLOW}PASO 3: Verificando Paso por Referencia y Trampa de Reasignación...${NC}"
if grep -qE "\.append\(" "$FILE_PY"; then echo -e "${GREEN}[OK] Uso correcto del paso por referencia con listas.${NC}"; else echo -e "${RED}[ERROR] Faltó agregar los elementos a la lista con .append().${NC}"; FAILED=1; fi
if grep -qE "def\s+gastar_presupuesto" "$FILE_PY" && grep -qE "=\s*0" "$FILE_PY"; then echo -e "${GREEN}[OK] Reasignación trampa verificada.${NC}"; else echo -e "${RED}[ERROR] Error en la función 'gastar_presupuesto' o su reasignación a 0.${NC}"; FAILED=1; fi

# --- PASO 4: COMPILACIÓN ---
echo -e "\n${YELLOW}PASO 4: Verificando sintaxis...${NC}"
if python3 -m py_compile "$FILE_PY" 2>/dev/null; then echo -e "${GREEN}[OK] Sintaxis sin errores.${NC}"; else echo -e "${RED}[ERROR] Error de sintaxis en el archivo.${NC}"; FAILED=1; fi

[ $FAILED -eq 0 ] && { echo -e "\n${GREEN}✔ LABORATORIO 2 APROBADO${NC}"; exit 0; } || { echo -e "\n${RED}✘ LAB FALLIDO${NC}"; exit 1; }