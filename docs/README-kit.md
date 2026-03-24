# Spec-Driven Kit — Estructura del repositorio

Este kit está diseñado para que PMs y diseñadoras puedan contribuir código con Claude Code sin necesitar conocimientos de git.

## Comandos disponibles

### Flujo PM (comandos de cara al usuario)

```
.claude/commands/
├── start.md              ← /start          Inicia una nueva feature
├── continue.md           ← /continue       Avanza al siguiente paso (repetible)
├── build.md              ← /build          Genera el código cuando el plan esté aprobado
├── submit.md             ← /submit         Comparte el código para revisión del equipo
├── deploy-to-stage.md    ← /deploy-to-stage Publica a staging con squash merge
├── status.md             ← /status         Muestra en qué punto del flujo estás
└── context.md            ← /context        Muestra cuánta memoria le queda a Claude
```

### Comandos internos (no usar directamente)

```
.claude/commands/
├── consolidate-spec.md   ← /consolidate-spec  (invocado por /continue)
├── plan.md               ← /plan              (invocado por /continue)
├── tasks.md              ← /tasks             (invocado por /build)
├── implement.md          ← /implement         (invocado por /build)
└── checklist.md          ← /checklist         (opcional, validación de requirements)
```

### SpecKit (motor interno)

```
.claude/commands/
├── speckit.specify.md
├── speckit.clarify.md
├── speckit.plan.md
├── speckit.tasks.md
├── speckit.implement.md
├── speckit.taskstoissues.md
├── speckit.retro.md
├── speckit.checklist.md
├── speckit.analyze.md
└── speckit.constitution.md
```

## Artefactos por feature

```
specs/
└── NNN-nombre-feature/
    ├── spec.md           ← Especificación funcional
    ├── research.md       ← Investigación técnica
    ├── data-model.md     ← Modelo de datos
    ├── plan.md           ← Plan de implementación
    ├── tasks.md          ← Tareas ordenadas por dependencias
    ├── contracts/        ← Contratos de interfaz
    └── lessons-learned.md
```

## Setup inicial (solo el equipo de desarrollo)

1. Asegúrate de tener `gh` (GitHub CLI) instalado y autenticado:
   ```bash
   gh auth login
   ```

2. Crea la rama `staging` si no existe:
   ```bash
   git checkout -b staging && git push origin staging
   git checkout main
   ```

3. Comparte `docs/onboarding.md` con el equipo de PMs y diseñadoras.

### Instalar la barra de estado (una vez por máquina, cada persona del equipo)

Requiere `jq` instalado (`brew install jq` en macOS).

```bash
# Copiar el script
mkdir -p ~/.claude
cp statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh

# Activar en Claude Code
cp settings.json ~/.claude/settings.json
```

Si ya tienes un `~/.claude/settings.json`, añade solo la entrada `statusLine` manualmente:
```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh"
  }
}
```

Reinicia Claude Code. Verás la barra en la parte inferior del terminal:
```
 [Claude Sonnet 4.6]  📁 mi-proyecto  🌿 feat/001-login
 ████████░░░░░░░░░░░░ 38% │ $0.12 │ ⏱ 8m 22s
```

**Colores del contexto:**
- Verde `< 50%` → puedes continuar
- Amarillo `50–79%` → termina el paso y abre sesión nueva
- Naranja `80–89%` → abre sesión nueva al terminar lo que estás haciendo
- Rojo `≥ 90%` → abre sesión nueva ahora

## Onboarding de PMs y diseñadoras

Comparte `docs/onboarding.md` con ellas y haz una sesión de 30 minutos donde ejecuten `/start` juntas por primera vez.

Los únicos comandos que necesitan recordar son:
- `/start` — empezar algo nuevo
- `/continue` — avanzar al siguiente paso
- `/build` — generar el código
- `/submit` — compartir su trabajo
- `/deploy-to-stage` — publicar a staging

El resto aparece de forma natural en el flujo.
