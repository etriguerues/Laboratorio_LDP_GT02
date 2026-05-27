#!/bin/bash
export LANG=C.UTF-8
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0;0m' 
FAILED=0

FILE_PY=$(find . -name "*.py" | head -n 1)
[ -z "$FILE_PY" ] && { echo -e "${RED}[ERROR] Sin archivo .py.${NC}"; exit 1; }

# Validar Búsqueda Lineal.
if grep -qE "def buscar_paciente_lineal" "$FILE_PY" && grep -qE "range\s*\(\s*len\s*\(" "$FILE_PY" && grep -qE "return\s+-1" "$FILE_PY"; then echo -e "${GREEN}✔ Búsqueda Lineal OK${NC}"; else echo -e "${RED}✘ Falla en buscar_paciente_lineal (Falta range(len()) o return -1)${NC}"; FAILED=1; fi

# Validar Búsqueda Binaria
if grep -qE "def buscar_paciente_binario" "$FILE_PY" && grep -qE "while.*:" "$FILE_PY" && grep -qE "//\s*2" "$FILE_PY"; then echo -e "${GREEN}✔ Búsqueda Binaria OK${NC}"; else echo -e "${RED}✘ Falla en buscar_paciente_binario (Falta ciclo while o división // 2)${NC}"; FAILED=1; fi

# Validar Bubble Sort
if grep -qE "def priorizar_edades_burbuja" "$FILE_PY" && grep -qE "for.*in range" "$FILE_PY" && grep -qE "\[\s*j\s*\+\s*1\s*\]" "$FILE_PY"; then echo -e "${GREEN}✔ Bubble Sort OK${NC}"; else echo -e "${RED}✘ Falla en priorizar_edades_burbuja (Problema con el for o el swap [j+1])${NC}"; FAILED=1; fi

# Validar Quick Sort
if grep -qE "def priorizar_edades_quick" "$FILE_PY" && grep -qE "pivote" "$FILE_PY" && grep -qE "\[.*for.*in.*\]" "$FILE_PY"; then echo -e "${GREEN}✔ Quick Sort OK${NC}"; else echo -e "${RED}✘ Falla en priorizar_edades_quick (Falta pivote o listas por comprensión)${NC}"; FAILED=1; fi

python3 -m py_compile "$FILE_PY" 2>/dev/null || { echo -e "${RED}✘ Error de sintaxis${NC}"; FAILED=1; }
[ $FAILED -eq 0 ] && exit 0 || exit 1
