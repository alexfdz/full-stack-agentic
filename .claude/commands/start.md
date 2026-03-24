---
description: "PASO 1 — Inicia una nueva feature. Crea el PR draft y arranca el proceso de especificación."
---

## User Input

```text
$ARGUMENTS
```

Descripción de la feature en lenguaje natural. **Obligatoria.**
Si está vacía: ERROR "Describe la feature. Ejemplo: /start quiero que los usuarios puedan restablecer su contraseña"

---

## Ejecución

### 1. Verificar punto de partida limpio

```bash
git status --porcelain
git branch --show-current
```

- Si hay cambios sin commitear: ERROR "Hay cambios sin guardar. Guárdalos o descártalos antes de iniciar una feature nueva."
- Si la rama actual no es `main` o `master`: ERROR "Debes estar en la rama principal. Ejecuta /status para ver dónde estás."

### 2. Delegar en speckit.specify

Invocar `/speckit.specify` pasando `$ARGUMENTS` como descripción de la feature, aplicando las siguientes reglas de gestión de preguntas:

**Clasificación de preguntas** — cuando `speckit.specify` identifique marcadores `[NEEDS CLARIFICATION]`, clasificar cada uno antes de presentarlo:

- **No técnica** (hacerla al PM): intención de negocio, prioridades, alcance funcional, flujos de usuario, terminología.
- **Técnica** (resolver autónomamente): autenticación, autorización, seguridad, compliance, retención de datos, patrones de integración, restricciones de infraestructura.

**Para preguntas técnicas**, NO preguntar al PM. En su lugar:
1. Responderlas usando el contexto del proyecto: código existente, `.agents/rules/base.md`, stack del proyecto (Python/FastAPI + TypeScript/Node 22), estándares del sector.
2. Si hay información suficiente: tomar la decisión y registrarla internamente como **Decisión propuesta por IA**.
3. Si no hay información suficiente: registrarla internamente como **Pregunta sin resolver** y continuar.

Guardar internamente la lista de decisiones técnicas (respondidas y no respondidas) para el paso 6.

`speckit.specify` se encarga de:
- Generar el nombre corto y número de rama (`NNN-short-name`)
- Crear y hacer checkout de la rama
- Escribir `specs/NNN-short-name/spec.md`
- Generar el checklist de calidad
- Hacer preguntas de clarificación si las hay

**Esperar a que `speckit.specify` termine completamente antes de continuar.**
Si produce ERROR: propagar y parar.

### 3. Leer rama y spec creados

```bash
git branch --show-current
```

```bash
ls specs/ | sort | tail -1
```

`BRANCH_NAME` = rama activa
`SPEC_PATH` = `specs/<último-directorio>/spec.md`

### 4. Push de la rama

```bash
git push -u origin HEAD
```

### 5. Abrir PR draft

```bash
gh pr create \
  --title "$BRANCH_NAME" \
  --draft \
  --base main \
  --body "$(cat <<EOF
## Feature
Spec: $SPEC_PATH

## Estado
- [x] Spec creado
- [ ] Spec aprobado por el equipo de desarrollo
- [ ] Plan generado
- [ ] Plan aprobado por el equipo de desarrollo
- [ ] Tareas generadas
- [ ] Código generado
- [ ] En revisión de código
- [ ] Publicado

## Historial

| Estado | Fecha | Nota |
|--------|-------|------|
| Spec creado | $(date +%Y-%m-%d) | Feature iniciada |

## Notas
EOF
)"
```

### 6. Registrar decisiones técnicas en el PR

Si durante el paso 2 hubo preguntas técnicas, añadir **un comentario individual por cada pregunta** al PR recién creado.

Para cada pregunta que la IA pudo responder:

```bash
gh pr comment --body "**Pregunta técnica detectada:** \"[pregunta identificada]\"

**Respuestas propuestas:** A. \"[opción A]\" B. \"[opción B]\" C. \"[opción C]\"

**Respuesta elegida autónomamente:** Hemos elegido la \"[opción elegida]\" porque \"[razonamiento breve]\"

> 💬 Si quieres cambiar esta decisión, responde con: \`Corrección: [letra o respuesta]\`"
```

Para cada pregunta que la IA no pudo resolver:

```bash
gh pr comment --body "**Pregunta técnica detectada:** \"[pregunta identificada]\"

**Respuestas posibles:** A. \"[opción A]\" B. \"[opción B]\" C. \"[opción C]\"

⚠️ **Sin resolver — requiere input del equipo de desarrollo.**

> 💬 Para responder, comenta con: \`Respuesta: [letra o respuesta]\`"
```

Si no hubo preguntas técnicas en absoluto, omitir este paso por completo.

### 7. Retro de fase

Invocar `/speckit.retro` con contexto: "after specify phase".

**Esperar a que `speckit.retro` termine antes de continuar.**
Si devuelve estado **Blocked**: no mostrar el informe final hasta que el usuario resuelva los bloqueantes.

### 8. Informe final

```
✅ Feature iniciada

📋 Spec:  <SPEC_PATH>
🌿 Rama:  <BRANCH_NAME>
🔗 PR:    <PR_URL>

─────────────────────────────────────────
➡️  SIGUIENTE PASO
─────────────────────────────────────────
Comparte el PR con el equipo de desarrollo
para que revisen el spec.

Cuando hayan comentado, ejecuta:
/continue
─────────────────────────────────────────
```

### Cierre de sesión

Leer el contexto actual de la sesión (igual que `/context`).

- **🟢 / 🟡**: No mostrar nada.
- **🟠**: Mostrar al final del informe:
  ```
  🟠 El contexto está alto. Abre una sesión nueva antes del siguiente comando.
  ```
- **🔴**: Mostrar antes del informe final e interrumpir si el usuario intenta continuar:
  ```
  🔴 Contexto crítico. Abre una sesión nueva AHORA antes de continuar.
  ```
