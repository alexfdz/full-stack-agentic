---
description: "PASO 4 — Descompone el plan en tareas y crea los issues en GitHub. Ejecutar cuando el equipo haya aprobado el plan."
---

## Ejecución

### 1. Verificar rama y PR

```bash
git branch --show-current
gh pr view --json number,state,url,body
```

- Si la rama es `main` o `master`: ERROR "No estás en una rama de feature. Ejecuta /status."
- Si no hay PR: ERROR "No hay PR abierto. ¿Ejecutaste /start?"

### 2. Gate: plan aprobado y correcciones técnicas aplicadas

Verificar en el body del PR:
- `- [x] Spec creado` ✓
- `- [x] Spec aprobado por el equipo de desarrollo` ✓
- `- [x] Plan generado` ✓
- `- [x] Plan aprobado por el equipo de desarrollo` ✓

Además, leer los comentarios del PR buscando correcciones o respuestas del equipo a decisiones técnicas previas (comentarios que empiecen con `Corrección:` o `Respuesta:`):

```bash
gh pr view --json comments -q '.comments[].body'
```

Si hay correcciones: aplicarlas en `research.md` o `plan.md` antes de delegar en `speckit.tasks`. Si hay respuestas a preguntas sin resolver: incorporarlas como contexto adicional en la delegación.

Si la aprobación del plan no está marcada:

```
🚫 BLOQUEADO

El plan no ha sido aprobado todavía.

El equipo de desarrollo debe aprobar el plan
en el PR antes de generar las tareas.
```

**PARAR.**

Verificar que no quedan decisiones técnicas sin respuesta: entre los comentarios del PR, identificar todos los que contengan "Sin resolver — requiere input del equipo de desarrollo" y comprobar que para cada uno existe un comentario posterior que empiece con `Respuesta:`.

Si alguna decisión técnica no tiene respuesta del equipo:

```
🚫 BLOQUEADO — Decisiones técnicas sin responder

Las siguientes preguntas técnicas deben ser respondidas antes de generar las tareas:

[listar las preguntas sin respuesta]

El equipo debe responder en el PR con:
  Respuesta: [letra o respuesta]
```

**PARAR.**

### 3. Delegar en speckit.tasks

Invocar `/speckit.tasks`, aplicando las siguientes reglas de gestión de decisiones técnicas:

**Resolución autónoma de ambigüedades** — si durante la generación de tasks surgen preguntas sobre priorización técnica, estructura de fases, dependencias entre tareas, o gaps en los artefactos disponibles:

- **NO preguntar al PM.** Tomar la decisión más razonable basándose en los artefactos existentes, el stack del proyecto (Python/FastAPI + TypeScript/Node 22) y mejores prácticas de organización de tareas.
- Registrar internamente cada decisión tomada por la IA como **Decisión propuesta por IA**.
- Si una ambigüedad no puede resolverse: documentarla en `tasks.md` como nota y registrarla internamente como **Pregunta sin resolver**.

`speckit.tasks` se encarga de:
- Leer `spec.md`, `plan.md`, `data-model.md`, `contracts/`
- Generar `tasks.md` con tareas ordenadas por dependencias
- Organizar por fases y user stories
- Marcar paralelizables con `[P]`

**Esperar a que `speckit.tasks` termine completamente antes de continuar.**
Si produce ERROR: propagar y parar.

### 4. Delegar en speckit.taskstoissues

Invocar `/speckit.taskstoissues`.

`speckit.taskstoissues` se encarga de:
- Leer `tasks.md`
- Crear un issue en GitHub por cada tarea
- Enlazar los issues al PR

**Esperar a que `speckit.taskstoissues` termine completamente antes de continuar.**
Si produce ERROR: propagar y parar.

### 5. Registrar decisiones técnicas en el PR

Si durante los pasos 3 o 4 hubo decisiones técnicas, añadir **un comentario individual por cada decisión** al PR.

Para cada decisión que la IA pudo tomar:

```bash
gh pr comment --body "**Pregunta técnica detectada:** \"[pregunta identificada]\"

**Respuestas propuestas:** A. \"[opción A]\" B. \"[opción B]\" C. \"[opción C]\"

**Respuesta elegida autónomamente:** Hemos elegido la \"[opción elegida]\" porque \"[razonamiento breve]\"

> 💬 Si quieres cambiar esta decisión, responde con: \`Corrección: [letra o respuesta]\`"
```

Para cada decisión que la IA no pudo resolver (documentada también en `tasks.md`):

```bash
gh pr comment --body "**Pregunta técnica detectada:** \"[pregunta identificada]\"

**Respuestas posibles:** A. \"[opción A]\" B. \"[opción B]\" C. \"[opción C]\"

⚠️ **Sin resolver — requiere input del equipo de desarrollo.**

> 💬 Para responder, comenta con: \`Respuesta: [letra o respuesta]\`"
```

Si no hubo ninguna decisión técnica relevante, omitir este paso por completo.

### 6. Commit de las tareas

```bash
git add specs/
git commit -m "docs: añadir tasks.md"
git push origin HEAD
```

### 7. Actualizar estado del PR

Marcar: `- [x] Tareas generadas`

Añadir fila:
```
| Tareas generadas | YYYY-MM-DD | tasks.md + issues creados |
```

```bash
gh pr edit --body "<body-actualizado>"
```

### 8. Retro de fase

Invocar `/speckit.retro` con contexto: "after tasks phase".

**Esperar a que `speckit.retro` termine antes de continuar.**
Si devuelve estado **Blocked**: no mostrar el informe final hasta que el usuario resuelva los bloqueantes.

### 9. Informe final

```
✅ Tareas generadas

📋 tasks.md creado
🎫 Issues creados en GitHub

─────────────────────────────────────────
➡️  SIGUIENTE PASO
─────────────────────────────────────────
OPCIONAL: Si quieres validar la calidad
de los requirements antes de implementar:
  /checklist

Cuando estés listo para implementar:
  /implement
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
