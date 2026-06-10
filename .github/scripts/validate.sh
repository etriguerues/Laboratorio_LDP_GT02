#!/bin/bash
export LANG=C.UTF-8
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0;0m' 
FAILED=0

echo "Validando Lab 2: Sistema Bancario"
if python3 -m py_compile "banco.py" 2>/dev/null; then echo -e "${GREEN}✔ Compilación OK${NC}"; else echo -e "${RED}✘ Error de sintaxis${NC}"; exit 1; fi

if [ -f "test_banco.py" ]; then
    echo -e "${GREEN}✔ Archivo test_banco.py encontrado. Ejecutando pytest...${NC}"
    pytest test_banco.py -q -s || FAILED=1
else
    echo -e "${RED}✘ Falta test_banco.py${NC}"; FAILED=1
fi
[ $FAILED -eq 0 ] && exit 0 || exit 1
