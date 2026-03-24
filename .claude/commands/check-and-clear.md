---
description: "UTILIDAD — Comprueba el contexto y, si está alto, limpia automáticamente."
---

## Ejecución

### 1. Estimar contexto actual

Usar la misma lógica que `/context` para calcular el porcentaje usado.

### 2. Rama según nivel

#### Si < 50% (🟢)

Mostrar solo:

```
[████░░░░░░░░░░░░░░░░]  22% usado

🟢  Todo bien, puedes continuar.
```

Fin. No hacer nada más.

#### Si 50–89% (🟡 / 🟠)

Mostrar estado y aviso:

```
[████████████░░░░░░░░]  65% usado

🟡  Contexto moderado. Termina el paso actual antes de continuar.
```

Fin. No ejecutar nada.

#### Si ≥ 90% (🔴) — AUTO-CLEAR

**Paso A — Mostrar estado:**

```
ANTES
[████████████████████]  92% usado

🔴  Contexto crítico. Ejecutando /clear automáticamente...
```

**Paso B — Ejecutar el script de auto-clear:**

Ejecutar via Bash:
```
bash .claude/scripts/auto-clear.sh
```

Si el script falla (socket no encontrado), mostrar:
```
⚠️  No se pudo ejecutar /clear automáticamente.
Ejecuta manualmente: /clear
```

**Paso C — Confirmación:**

```
DESPUÉS
[░░░░░░░░░░░░░░░░░░░░]   ~2% usado

✓ /clear ejecutado. Al retomar, Claude mostrará automáticamente el estado del flujo.
```
