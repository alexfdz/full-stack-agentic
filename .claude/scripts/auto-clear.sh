#!/bin/bash
# Marca que el próximo SessionStart debe inyectar instrucción de retomar flujo.
# Se ejecuta desde check-and-clear cuando el contexto supera el 90%.

touch /tmp/claude-resume-flag
echo "⚠️  Contexto alto. Abre una sesión nueva manualmente para continuar."
