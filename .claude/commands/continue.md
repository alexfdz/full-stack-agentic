---
description: "Avanza al siguiente paso del flujo. Detecta el estado actual y ejecuta lo que toca."
---

## Ejecución

### 1. Verificar rama y PR

```bash
git branch --show-current
gh pr view --json number,state,url,body
```

- Si la rama es `main` o `master`: ERROR "No hay ninguna feature activa. Usa /start para iniciar una nueva."
- Si no hay PR: ERROR "No hay PR abierto. ¿Ejecutaste /start?"

### 2. Leer estado del PR

```bash
gh pr view --json body -q '.body'
```

Identificar qué checkboxes están marcados (`- [x]`) y cuáles no (`- [ ]`):

- `Spec creado`
- `Spec aprobado por el equipo de desarrollo`
- `Plan generado`
- `Plan aprobado por el equipo de desarrollo`
- `Tareas generadas`
- `Código generado`

### 3. Determinar siguiente acción

Evaluar en orden:

| Condición | Acción |
|-----------|--------|
| Spec creado ✓ · Spec aprobado ✗ · hay comentarios en el PR | Consolidar feedback en el spec |
| Spec aprobado ✓ · Plan generado ✗ | Generar plan técnico |
| Spec aprobado ✓ · Plan generado ✓ · Plan aprobado ✗ · hay comentarios en el PR | Consolidar feedback en el plan |
| Plan aprobado ✓ · Código generado ✗ | Indicar al PM que ejecute /build |
| Sin comentarios nuevos y el siguiente paso requiere aprobación del equipo | Mostrar estado de espera (ver paso 4) |

### 4. Informar al PM qué va a pasar

Antes de ejecutar nada, mostrar:

```
📍 Estado actual: <resumen del estado en lenguaje claro>

🔜 Voy a hacer:
   <descripción de la acción en lenguaje natural>
   <si hay varias acciones encadenadas, listarlas numeradas>

Iniciando...
```

Ejemplos:

```
📍 Estado actual: Spec creado · Esperando aprobación del equipo

⏳ No hay nada que hacer todavía.
   El equipo de desarrollo debe revisar y aprobar el spec en el PR.
   Cuando lo hagan, vuelve a ejecutar /continue.

🔗 PR: <url>
```

```
📍 Estado actual: Spec aprobado · Plan pendiente

🔜 Voy a hacer:
   Generar el plan técnico a partir del spec aprobado.

Iniciando...
```

```
📍 Estado actual: Feedback del equipo pendiente · Spec aprobado

🔜 Voy a hacer:
   1. Integrar el feedback del equipo en el spec
   2. Generar el plan técnico (el spec ya está aprobado)

Iniciando...
```

Si el estado es de espera: **PARAR** después de mostrar el mensaje.

### 5. Ejecutar la acción correspondiente

**Si hay feedback pendiente y spec no aprobado:**
Invocar `/consolidate-spec`.
Esperar a que termine completamente. Si produce ERROR: propagar y parar.

**Si spec aprobado y plan no generado:**
Invocar `/plan`.
Esperar a que termine completamente. Si produce ERROR: propagar y parar.

**Si plan aprobado y código no generado:**

```
📍 Estado actual: Plan aprobado · Listo para construir

✅ El plan ha sido aprobado. Ya puedes construir la feature.

─────────────────────────────────────────
➡️  SIGUIENTE PASO
─────────────────────────────────────────
Ejecuta: /build
─────────────────────────────────────────
```

**PARAR.**

### 6. Informe final

```
✅ Listo

─────────────────────────────────────────
➡️  SIGUIENTE PASO
─────────────────────────────────────────
<indicación contextual según el estado resultante>
─────────────────────────────────────────
```

Indicaciones contextuales:

- Tras consolidar spec sin aprobación aún:
  ```
  Comparte el PR con el equipo para que aprueben el spec.
  Cuando lo hagan, ejecuta: /continue
  ```
- Tras generar plan:
  ```
  Comparte el PR con el equipo para que revisen el plan.
  Cuando lo aprueben, ejecuta: /continue
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
