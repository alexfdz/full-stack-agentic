---
description: "Genera el código de la feature. Ejecutar cuando el equipo haya aprobado el plan."
---

## Ejecución

### 1. Verificar rama y PR

```bash
git branch --show-current
gh pr view --json number,state,url,body
```

- Si la rama es `main` o `master`: ERROR "No hay ninguna feature activa. Usa /start para iniciar una nueva."
- Si no hay PR: ERROR "No hay PR abierto. ¿Ejecutaste /start?"

### 2. Gate: plan aprobado

Verificar en el body del PR:
- `- [x] Plan aprobado por el equipo de desarrollo` ✓

Si no está marcado:

```
🚫 El plan todavía no ha sido aprobado por el equipo.

Comparte el PR con el equipo y espera su aprobación.
Cuando lo aprueben, vuelve a ejecutar /build.

🔗 PR: <url>
```

**PARAR.**

Verificar también que no quedan decisiones técnicas sin respuesta: leer los comentarios del PR buscando los que contengan "Sin resolver — requiere input del equipo de desarrollo" y comprobar que para cada uno existe un comentario posterior que empiece con `Respuesta:`.

```bash
gh pr view --json comments -q '.comments[].body'
```

Si alguna decisión técnica no tiene respuesta del equipo:

```
🚫 Hay preguntas técnicas pendientes de respuesta.

El equipo de desarrollo debe responder antes de poder construir:

[listar las preguntas sin respuesta]

Para responder, el equipo debe comentar en el PR con:
  Respuesta: [letra o respuesta]
```

**PARAR.**

### 3. Informar al PM

```
📍 Estado actual: Plan aprobado · Listo para construir

🔜 Voy a hacer:
   1. Descomponer el plan en tareas de desarrollo
   2. Generar el código de la feature

Esto puede tardar varios minutos.

Iniciando...
```

### 4. Generar tareas

Invocar `/tasks`.

`/tasks` se encarga de:
- Generar `tasks.md` con tareas ordenadas por dependencias
- Crear los issues en GitHub
- Registrar decisiones técnicas en el PR

**Esperar a que `/tasks` termine completamente antes de continuar.**
Si produce ERROR: propagar y parar.

### 5. Implementar

Invocar `/implement`.

`/implement` se encarga de:
- Leer spec, plan, data-model, contracts y tasks
- Implementar las tareas en el orden correcto
- Respetar las dependencias definidas en tasks.md

**Esperar a que `/implement` termine completamente antes de continuar.**
Si produce ERROR: propagar y parar.

### 6. Informe final

```
✅ Feature construida

─────────────────────────────────────────
➡️  SIGUIENTE PASO
─────────────────────────────────────────
Ejecuta: /submit

Guardará el código y lo dejará listo
para revisión del equipo de desarrollo.
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
