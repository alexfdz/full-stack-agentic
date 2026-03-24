---
description: "PASO 3 — Genera el plan técnico. Ejecutar cuando el equipo haya aprobado el spec."
---

## Ejecución

### 1. Verificar rama y PR

```bash
git branch --show-current
gh pr view --json number,state,url,body
```

- Si la rama es `main` o `master`: ERROR "No estás en una rama de feature. Ejecuta /status."
- Si no hay PR: ERROR "No hay PR abierto. ¿Ejecutaste /start?"

### 2. Gate: spec aprobado y correcciones técnicas aplicadas

Verificar en el body del PR:
- `- [x] Spec creado` ✓
- `- [x] Spec aprobado por el equipo de desarrollo` ✓

Además, leer los comentarios del PR buscando correcciones o respuestas del equipo a decisiones técnicas previas (comentarios que empiecen con `Corrección:` o `Respuesta:`):

```bash
gh pr view --json comments -q '.comments[].body'
```

Si hay correcciones: aplicarlas en `spec.md` antes de delegar en `speckit.plan`. Si hay respuestas a preguntas sin resolver: incorporarlas como contexto adicional en la delegación.

Si la aprobación no está marcada:

```
🚫 BLOQUEADO

El spec no ha sido aprobado todavía.

El equipo de desarrollo debe aprobar el spec
en el PR antes de generar el plan.

Si ya comentaron pero no aprobaron:
  Ejecuta /consolidate-spec primero.
```

**PARAR.**

Verificar que no quedan decisiones técnicas sin respuesta: entre los comentarios del PR, identificar todos los que contengan "Sin resolver — requiere input del equipo de desarrollo" y comprobar que para cada uno existe un comentario posterior que empiece con `Respuesta:`.

Si alguna decisión técnica no tiene respuesta del equipo:

```
🚫 BLOQUEADO — Decisiones técnicas sin responder

Las siguientes preguntas técnicas deben ser respondidas antes de generar el plan:

[listar las preguntas sin respuesta]

El equipo debe responder en el PR con:
  Respuesta: [letra o respuesta]
```

**PARAR.**

### 3. Delegar en speckit.plan

Invocar `/speckit.plan`, aplicando las siguientes reglas de gestión de decisiones técnicas:

**Resolución autónoma de incógnitas** — durante la Phase 0 (research) y la Phase 1 (diseño), si surgen preguntas o decisiones que los research agents no pueden resolver completamente:

- **NO preguntar al PM.** Tomar la decisión más razonable basándose en: código existente, stack del proyecto (Python/FastAPI + TypeScript/Node 22), `.agents/rules/base.md`, estándares del sector.
- Registrar internamente cada decisión tomada por la IA como **Decisión propuesta por IA**.
- Si una incógnita no puede resolverse ni por research ni por mejores prácticas: registrarla internamente como **Pregunta sin resolver** y documentarla en `research.md` como decisión pendiente en lugar de bloquear.

Guardar la lista de decisiones técnicas (respondidas y no respondidas) para el paso 5.

`speckit.plan` se encarga de:
- Ejecutar los scripts de setup del plan
- Generar `research.md` resolviendo incógnitas técnicas
- Generar `data-model.md` con entidades y relaciones
- Generar `contracts/` con los contratos de interfaz
- Actualizar el contexto del agente

**Esperar a que `speckit.plan` termine completamente antes de continuar.**
Si produce ERROR: propagar y parar.

### 4. Verificar artefactos generados

```bash
ls specs/<directorio-rama>/
```

Confirmar que existen: `research.md`, `data-model.md`.
Si faltan: ERROR "speckit.plan no generó todos los artefactos. Revisa los errores anteriores."

### 5. Registrar decisiones técnicas en el PR

Si durante el paso 3 hubo decisiones técnicas, añadir **un comentario individual por cada decisión** al PR.

Para cada decisión que la IA pudo tomar:

```bash
gh pr comment --body "**Pregunta técnica detectada:** \"[pregunta identificada]\"

**Respuestas propuestas:** A. \"[opción A]\" B. \"[opción B]\" C. \"[opción C]\"

**Respuesta elegida autónomamente:** Hemos elegido la \"[opción elegida]\" porque \"[razonamiento breve]\"

> 💬 Si quieres cambiar esta decisión, responde con: \`Corrección: [letra o respuesta]\`"
```

Para cada decisión que la IA no pudo resolver (documentada también en `research.md`):

```bash
gh pr comment --body "**Pregunta técnica detectada:** \"[pregunta identificada]\"

**Respuestas posibles:** A. \"[opción A]\" B. \"[opción B]\" C. \"[opción C]\"

⚠️ **Sin resolver — requiere input del equipo de desarrollo.**

> 💬 Para responder, comenta con: \`Respuesta: [letra o respuesta]\`"
```

Si no hubo ninguna decisión técnica relevante, omitir este paso por completo.

### 6. Commit del plan

```bash
git add specs/
git commit -m "docs: añadir plan técnico"
git push origin HEAD
```

### 7. Actualizar estado del PR

Marcar: `- [x] Plan generado`

Añadir fila:
```
| Plan generado | YYYY-MM-DD | research.md + data-model.md |
```

```bash
gh pr edit --body "<body-actualizado>"
```

### 8. Retro de fase

Invocar `/speckit.retro` con contexto: "after plan phase".

**Esperar a que `speckit.retro` termine antes de continuar.**
Si devuelve estado **Blocked**: no mostrar el informe final hasta que el usuario resuelva los bloqueantes.

### 9. Informe final

```
✅ Plan técnico generado

📁 Artefactos:
   specs/<directorio>/research.md
   specs/<directorio>/data-model.md
   specs/<directorio>/contracts/  (si aplica)

─────────────────────────────────────────
➡️  SIGUIENTE PASO
─────────────────────────────────────────
Comparte el PR con el equipo para que
revisen el plan técnico.

Cuando el equipo apruebe el plan, ejecuta:
/tasks
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
