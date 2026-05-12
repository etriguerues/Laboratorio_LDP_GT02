#!/bin/bash
export LANG=C.UTF-8
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0;0m' 

echo "--------------------------------------------------------"
echo "Validación Lab: Sistema de Hospital"
echo "--------------------------------------------------------"

FAILED=0
FILE_PY=$(find . -name "*.py" | head -n 1)
[ -z "$FILE_PY" ] && { echo -e "${RED}[ERROR] Sin archivo .py.${NC}"; exit 1; }

echo -e "${YELLOW}PASO 1: Verificando Arreglo, Matriz y LIFO...${NC}"
if grep -qE "array\.array\(\s*['\"]i['\"]" "$FILE_PY" && grep -qE "\[0\]\[1\]" "$FILE_PY" && grep -qE "\.pop\(\)" "$FILE_PY"; then echo -e "${GREEN}[OK] Array, coordenadas de matriz y .pop() verificados.${NC}"; else echo -e "${RED}[ERROR] Falla en arreglo, lectura de matriz o falta el .pop() LIFO.${NC}"; FAILED=1; fi

echo -e "\n${YELLOW}PASO 2: Verificando Árbol Genérico (Clase Nodo)...${NC}"
if grep -qE "class NodoHospital" "$FILE_PY" && grep -qE "sub_areas\.append\(" "$FILE_PY"; then echo -e "${GREEN}[OK] Árbol jerárquico creado y enlazado correctamente.${NC}"; else echo -e "${RED}[ERROR] Problema con la clase NodoHospital o el método .append en sub_areas.${NC}"; FAILED=1; fi

echo -e "\n${YELLOW}PASO 3: Verificando JSON...${NC}"
if grep -qE "json\.dumps\(" "$FILE_PY"; then echo -e "${GREEN}[OK] Serialización JSON presente.${NC}"; else echo -e "${RED}[ERROR] No se usó json.dumps().${NC}"; FAILED=1; fi

if python3 -m py_compile "$FILE_PY" 2>/dev/null; then echo -e "\n${GREEN}[OK] Sintaxis sin errores.${NC}"; else echo -e "\n${RED}[ERROR] Error de sintaxis.${NC}"; FAILED=1; fi

[ $FAILED -eq 0 ] && { echo -e "\n${GREEN}✔ LABORATORIO 2 APROBADO${NC}"; exit 0; } || { echo -e "\n${RED}✘ LAB FALLIDO${NC}"; exit 1; }
