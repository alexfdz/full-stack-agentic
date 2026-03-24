---
description: "UTILIDAD — Muestra en qué punto del flujo estás ahora mismo."
---

## Ejecución

### 0. Verificar dependencias

Comprobar que `gh` está instalado y autenticado:

```bash
which gh 2>/dev/null || echo "GH_NOT_FOUND"
gh auth status 2>/dev/null || echo "GH_NOT_AUTHENTICATED"
```

Si el resultado contiene `GH_NOT_FOUND`, detener la ejecución y mostrar:

```
⚠️  GitHub CLI (`gh`) no está instalado. Es necesario para consultar el estado del PR.

Instálalo con:
  brew install gh        # macOS

Luego autentícate:
  gh auth login

Durante el login:
  1. Selecciona "GitHub.com"
  2. Selecciona "HTTPS"
  3. Elige "Login with a web browser"
  4. Copia el código que aparece en la terminal
  5. Se abrirá el navegador — pega el código y pulsa Continue

Luego vuelve a ejecutar /status.
```

Si el resultado contiene `GH_NOT_AUTHENTICATED`, detener la ejecución y mostrar:

```
⚠️  GitHub CLI está instalado pero no autenticado.

Ejecuta en tu terminal:
  gh auth login

Durante el login:
  1. Selecciona "GitHub.com"
  2. Selecciona "HTTPS"
  3. Elige "Login with a web browser"
  4. Copia el código que aparece en la terminal
  5. Se abrirá el navegador — pega el código y pulsa Continue

Luego vuelve a ejecutar /status.
```

### 1. Recopilar estado

```bash
git branch --show-current
git status --porcelain
gh pr view --json number,title,state,isDraft,url,body,reviewDecision 2>/dev/null || echo "NO_PR"
```

### 2. Interpretar y mostrar

**Caso: en main sin feature activa**
```
📍 Estás en la rama principal, sin ninguna feature activa.

Para iniciar una feature:
  /start <descripción>
```

**Caso: en rama de feature con PR**

Leer checkboxes del PR y determinar el último paso completado.
Para cada paso, determinar su estado según esta lógica:
- ✅ si el checkbox está marcado
- ▶️  si es el siguiente ejecutable ahora mismo (pasos anteriores completos)
- ⏳ si está pendiente de una acción externa (aprobación del equipo)
- 🔒 si está bloqueado porque pasos anteriores no están completos

```
📍 Feature activa: <BRANCH_NAME>
🔗 PR: <PR_URL>

PROGRESO:
  ✅ Spec creado
  ✅ Spec aprobado
  ✅ Plan generado
  ⏳ Plan aprobado por el equipo      ← el equipo debe aprobar en GitHub
  🔒 Tareas generadas
  🔒 Código generado
  🔒 En revisión de código
  🔒 Publicado

➡️  SIGUIENTE
    Cuando el equipo apruebe el plan en GitHub, ejecuta:
    /build
```

### 3. Cambios sin guardar

Si `git status --porcelain` devuelve cambios:
```
⚠️  Hay cambios sin guardar en tu rama.
    Se guardarán en el próximo /submit.
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
