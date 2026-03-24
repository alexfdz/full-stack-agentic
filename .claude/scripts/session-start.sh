#!/bin/bash
# Hook: SessionStart
# Siempre ejecuta /status al iniciar sesión para mostrar el estado del flujo.

if [ -f /tmp/claude-resume-flag ]; then
  rm /tmp/claude-resume-flag
fi

echo "INSTRUCCIÓN AUTOMÁTICA: Al inicio de esta sesión, ejecuta /status para mostrar al usuario en qué punto del flujo se encuentra y qué debe hacer a continuación."
