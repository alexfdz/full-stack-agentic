---
description: "PASO 2 — Integra el feedback del equipo en el spec. Ejecutar después de que hayan comentado en el PR. Repetible."
---

## Ejecución

### 1. Verificar rama y PR

```bash
git branch --show-current
gh pr view --json number,state,url,body
```

- Si la rama es `main` o `master`: ERROR "No estás en una rama de feature. Ejecuta /status."
- Si no hay PR: ERROR "No hay PR abierto. ¿Ejecutaste /start?"

### 2. Gate: spec creado

Verificar en el body del PR: `- [x] Spec creado`

Si no está marcado: ERROR "El spec no existe todavía. Ejecuta /start primero."

### 3. Verificar comentarios y recoger correcciones del equipo

```bash
gh pr view --json comments -q '.comments[].body'
```

Si no hay comentarios: ERROR "No hay comentarios en el PR todavía. Comparte el PR con el equipo y espera su feedback."

Buscar también comentarios del equipo que sean correcciones o respuestas a decisiones técnicas previas (comentarios que empiecen con `Corrección:` o `Respuesta:`). Si los hay, registrarlos internamente — serán incorporados como contexto adicional en el paso 4 al invocar `speckit.clarify`.

### 4. Delegar en speckit.clarify

Invocar `/speckit.clarify` con el contexto de los comentarios del PR, aplicando las siguientes reglas de gestión de preguntas:

**Clasificación de preguntas** — antes de presentar cada pregunta, clasificarla:

- **No técnica** (hacerla al PM): intención de negocio, prioridades, flujo de usuario, terminología, alcance funcional.
- **Técnica** (resolver autónomamente): arquitectura, rendimiento, seguridad, integraciones, modelo de datos, restricciones de infraestructura, patrones de implementación.

**Para preguntas técnicas**, NO preguntar al PM. En su lugar:
1. Intentar responderlas usando el contexto del proyecto: código existente, `.agents/rules/base.md`, stack del proyecto (Python/FastAPI + TypeScript/Node 22), patrones de arquitectura detectados.
2. Si hay información suficiente para responder con confianza: tomar la decisión y registrarla internamente como **Decisión propuesta por IA**.
3. Si no hay información suficiente: registrarla internamente como **Pregunta sin resolver** y continuar.

Guardar internamente la lista de todas las decisiones técnicas (respondidas y no respondidas) para el paso siguiente.

`speckit.clarify` se encarga de:
- Leer el spec actual
- Procesar las clarificaciones necesarias
- Actualizar `spec.md` con las decisiones tomadas

**Esperar a que `speckit.clarify` termine completamente antes de continuar.**
Si produce ERROR: propagar y parar.

### 5. Registrar decisiones técnicas en el PR

Si durante el paso anterior hubo preguntas técnicas, añadir **un comentario individual por cada pregunta** al PR.

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

### 6. Commit del spec actualizado

```bash
git add specs/
git commit -m "docs: actualizar spec con feedback del equipo"
git push origin HEAD
```

### 7. Actualizar historial del PR

Añadir fila a la tabla:
```
| Spec revisado | YYYY-MM-DD | Feedback integrado vía speckit.clarify |
```

```bash
gh pr edit --body "<body-actualizado>"
```

### 8. Retro de fase

Invocar `/speckit.retro` con contexto: "after clarify phase".

**Esperar a que `speckit.retro` termine antes de continuar.**
Si devuelve estado **Blocked**: no mostrar el informe final hasta que el usuario resuelva los bloqueantes.

### 9. Informe final

```
✅ Spec actualizado

─────────────────────────────────────────
➡️  SIGUIENTE PASO
─────────────────────────────────────────
Si hay más rondas de feedback:
  Vuelve a ejecutar /consolidate-spec

Si el spec está listo para aprobación:
  Pide al equipo que apruebe el spec en el PR.
  Cuando lo hagan, ejecuta: /plan
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
