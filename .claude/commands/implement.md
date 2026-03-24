---
description: "PASO 5 — Genera el código. Ejecutar cuando las tareas estén generadas y el equipo esté listo para implementar."
---

## Ejecución

### 1. Verificar rama y PR

```bash
git branch --show-current
gh pr view --json number,state,url,body
```

- Si la rama es `main` o `master`: ERROR "No estás en una rama de feature. Ejecuta /status."
- Si no hay PR: ERROR "No hay PR abierto. ¿Ejecutaste /start?"

### 2. Gate: tareas generadas y correcciones técnicas aplicadas

Verificar en el body del PR:
- `- [x] Spec creado` ✓
- `- [x] Spec aprobado por el equipo de desarrollo` ✓
- `- [x] Plan generado` ✓
- `- [x] Plan aprobado por el equipo de desarrollo` ✓
- `- [x] Tareas generadas` ✓

Además, leer los comentarios del PR buscando correcciones o respuestas del equipo a decisiones técnicas previas (comentarios que empiecen con `Corrección:` o `Respuesta:`):

```bash
gh pr view --json comments -q '.comments[].body'
```

Si hay correcciones: aplicarlas en `tasks.md` o en los artefactos afectados antes de delegar en `speckit.implement`. Si hay respuestas a preguntas sin resolver: incorporarlas como contexto adicional en la delegación.

Si las tareas no están generadas:

```
🚫 BLOQUEADO

Las tareas no han sido generadas todavía.
Ejecuta /tasks primero.
```

**PARAR.**

Verificar que no quedan decisiones técnicas sin respuesta: entre los comentarios del PR, identificar todos los que contengan "Sin resolver — requiere input del equipo de desarrollo" y comprobar que para cada uno existe un comentario posterior que empiece con `Respuesta:`.

Si alguna decisión técnica no tiene respuesta del equipo:

```
🚫 BLOQUEADO — Decisiones técnicas sin responder

Las siguientes preguntas técnicas deben ser respondidas antes de implementar:

[listar las preguntas sin respuesta]

El equipo debe responder en el PR con:
  Respuesta: [letra o respuesta]
```

**PARAR.**

### 3. Verificar estado limpio del repo

```bash
git status --porcelain
```

Si hay cambios sin commitear: ERROR "Hay cambios sin guardar. Haz commit antes de implementar."

### 4. Sync con main

```bash
git fetch origin
git rebase origin/main
```

Si hay conflictos: ERROR "Hay conflictos con main. El equipo de desarrollo debe resolverlos antes de continuar."

### 5. Delegar en speckit.implement

Invocar `/speckit.implement`.

`speckit.implement` se encarga de:
- Leer spec, plan, data-model, contracts y tasks
- Implementar las tareas en el orden correcto
- Respetar las dependencias definidas en tasks.md

**Esperar a que `speckit.implement` termine completamente antes de continuar.**
Si produce ERROR: propagar y parar.

### 6. Actualizar estado del PR

Marcar: `- [x] Código generado`

Añadir fila:
```
| Código generado | YYYY-MM-DD | speckit.implement completado |
```

```bash
gh pr edit --body "<body-actualizado>"
```

### 7. Retro de fase

Invocar `/speckit.retro` con contexto: "after implement phase".

**Esperar a que `speckit.retro` termine antes de continuar.**
Si devuelve estado **Blocked**: no mostrar el informe final hasta que el usuario resuelva los bloqueantes.

### 8. Informe final

```
✅ Código generado

─────────────────────────────────────────
➡️  SIGUIENTE PASO
─────────────────────────────────────────
Ejecuta: /submit

Guardará el código y lo dejará listo
para revisión del equipo de desarrollo.
─────────────────────────────────────────
```

### Cierre de sesión

Ejecutar la lógica de `/check-and-clear` para verificar el contexto y guiar al usuario si necesita limpiar la sesión.

- **🟢 / 🟡**: No mostrar nada.
- **🟠**: Mostrar al final del informe:
  ```
  🟠 El contexto está alto. Abre una sesión nueva antes del siguiente comando.
  ```
- **🔴**: Mostrar antes del informe final e interrumpir si el usuario intenta continuar:
  ```
  🔴 Contexto crítico. Abre una sesión nueva AHORA antes de continuar.
  ```
