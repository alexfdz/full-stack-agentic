---
description: "UTILIDAD — Muestra cuánta memoria le queda a Claude en esta sesión."
---

## Ejecución

### 1. Leer contexto real de la sesión

Estimar el porcentaje de contexto usado basándose en la longitud y complejidad del historial de conversación actual. Considerar: número de mensajes, longitud de los mensajes, uso de herramientas, archivos leídos, outputs de comandos, etc.

- Conversación vacía o muy corta → ~2–5%
- Conversación corta (pocos intercambios) → ~5–15%
- Conversación media (trabajo activo) → ~20–50%
- Conversación larga con muchas herramientas → ~50–80%
- Conversación muy larga con outputs grandes → ~80–95%

### 2. Determinar nivel

| % usado | Nivel | Emoji |
|---------|-------|-------|
| < 50%   | Puedes continuar | 🟢 |
| 50–79%  | Termina el paso actual | 🟡 |
| 80–89%  | Ejecuta /clear pronto | 🟠 |
| ≥ 90%   | Ejecuta /clear YA | 🔴 |

### 3. Mostrar informe

Mostrar SOLO: la barra visual, el porcentaje y la recomendación. Ejemplo para 🟠:

```
[████████████████░░░░]  83% usado

🟠  Ejecuta /clear pronto para liberar contexto
```

La recomendación es obligatoria y se muestra siempre debajo de la barra.

### 4. Mostrar siguiente paso

Mostrar el siguiente paso pendiente del flujo (igual que `/status`) para que tras un `/clear` el usuario sepa exactamente qué ejecutar.
