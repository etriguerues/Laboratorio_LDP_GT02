#!/bin/bash
export LANG=C.UTF-8

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0;0m' 

echo "--------------------------------------------------------"
echo "Validación Lab 2: Procesador de Nómina (Python)"
echo "--------------------------------------------------------"

FAILED=0
FILE_PY=$(find . -name "*.py" | head -n 1)
[ -z "$FILE_PY" ] && { echo -e "${RED}[ERROR] Sin archivo .py.${NC}"; exit 1; }
echo -e "Archivo detectado: ${YELLOW}$FILE_PY${NC}\n"

# --- PASO 1: CONSTANTES Y DICCIONARIOS ---
echo -e "${YELLOW}PASO 1: Verificando Diccionario y Constantes...${NC}"
if grep -qE "TASA_IMPUESTO\s*=\s*0\.12" "$FILE_PY"; then echo -e "${GREEN}[OK] Constante de impuesto correcta.${NC}"; else echo -e "${RED}[ERROR] Falta TASA_IMPUESTO = 0.12.${NC}"; FAILED=1; fi
if grep -qE "empleado\s*=\s*\{" "$FILE_PY" && grep -q "salario_final"; then echo -e "${GREEN}[OK] Diccionario 'empleado' detectado.${NC}"; else echo -e "${RED}[ERROR] Falta el diccionario 'empleado' con 'salario_final'.${NC}"; FAILED=1; fi

# --- PASO 2: FUNCIONES Y CASTING ---
echo -e "\n${YELLOW}PASO 2: Verificando Funciones y Casting Fuerte...${NC}"
if grep -qE "def\s+calcular_pago" "$FILE_PY" && grep -qE "float\s*\(" "$FILE_PY"; then
    echo -e "${GREEN}[OK] Función y Casting a float correctos.${NC}"
else
    echo -e "${RED}[ERROR] Falla en def calcular_pago o falta el float().${NC}"; FAILED=1
fi

# --- PASO 3: MUTABILIDAD ---
echo -e "\n${YELLOW}PASO 3: Verificando Mutabilidad (Actualización Diccionario)...${NC}"
if grep -qE "empleado\[[\"']salario_final[\"']\]\s*=" "$FILE_PY"; then echo -e "${GREEN}[OK] Asignación directa al diccionario correcta.${NC}"; else echo -e "${RED}[ERROR] No se actualizó la clave 'salario_final'.${NC}"; FAILED=1; fi

# --- PASO 4: GARBAGE COLLECTOR ---
echo -e "\n${YELLOW}PASO 4: Verificando Garbage Collector...${NC}"
if grep -qE "empleado\s*=\s*None" "$FILE_PY"; then echo -e "${GREEN}[OK] Diccionario limpiado de la RAM.${NC}"; else echo -e "${RED}[ERROR] Falta empleado = None.${NC}"; FAILED=1; fi

# --- PASO 5: COMPILACIÓN Y SINTAXIS ---
echo -e "\n${YELLOW}PASO 5: Verificando sintaxis de Python...${NC}"
if python3 -m py_compile "$FILE_PY" 2>/dev/null; then 
    echo -e "${GREEN}[OK] Sintaxis correcta.${NC}"
else 
    echo -e "${RED}[ERROR] Error de sintaxis en Python.${NC}"
    python3 -m py_compile "$FILE_PY"
    FAILED=1
fi

[ $FAILED -eq 0 ] && { echo -e "\n${GREEN}✔ LABORATORIO 2 APROBADO${NC}"; exit 0; } || { echo -e "\n${RED}✘ LAB FALLIDO${NC}"; exit 1; }