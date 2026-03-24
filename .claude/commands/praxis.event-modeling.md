---
description: >
  Design system behavior using Event Modeling — vertical slices that are independently
  implementable and testable. Use during speckit.specify or speckit.plan for features
  with complex domain logic, multi-step flows, or asynchronous processing.
---

## User Input

```text
$ARGUMENTS
```

If the user describes a feature or domain, model that. If no argument is provided,
ask: "What feature or domain area should I model with Event Modeling?"

---

## Event Modeling

Structure system behavior as vertical slices using business language throughout.
No infrastructure terms. No technical jargon. Every name must be understandable
by a domain expert who doesn't write code.

---

## Core Slice Types

Every behavior in the system fits one of three slice types:

### STATE_CHANGE
A user takes an action that changes system state.

```
Screen → Command → Event(s)
```

- **Screen**: what the user sees / what triggers the action
- **Command**: the intent expressed as an imperative ("Register Owner", "Place Order")
- **Event(s)**: what happened as a result ("OwnerRegistered", "OrderPlaced")
- Include error paths: what events are emitted when the command fails validation

### STATE_VIEW
The system displays information to a user.

```
Event(s) → Read Model → Screen
```

- **Event(s)**: which domain events contribute to this view
- **Read Model**: the projected data structure (name it as a noun: "OwnerProfile", "OrderSummary")
- **Screen**: what the user sees

### AUTOMATION
The system reacts to an event without user involvement.

```
Event → Processor → Command → Event
```

- **Event**: the trigger
- **Processor**: the automation logic (name it as an agent: "OrderConfirmationSender")
- **Command + Event**: what it does and what results

---

## Design Workflow

### Step 1 — Domain Discovery

Identify:
- **Actors**: who interacts with the system (user roles, external systems)
- **Aggregates**: the core domain objects (name as nouns: `Owner`, `Order`, `Payment`)
- **Use cases**: the key things actors need to accomplish (3-10 per aggregate)

List these before modeling any slices.

### Step 2 — High-Level Model

Create a slice inventory — a table of all slices without yet defining their internals:

| Slice | Type | Actor | Aggregate |
|---|---|---|---|
| Register Owner | STATE_CHANGE | New user | Owner |
| View Owner Profile | STATE_VIEW | Owner | Owner |
| Send Welcome Email | AUTOMATION | System | Owner |

Aim for completeness. Missing a STATE_VIEW for every STATE_CHANGE is a common gap.

### Step 3 — Slice Detail

For each slice, define:

**STATE_CHANGE:**
```
Slice: [Name]
Actor: [who triggers it]
Screen: [what they see / what input they provide]
Command: [CommandName]
  Fields:
    - field_name: type — example value
Preconditions: [what must be true for the command to succeed]
Events (success): [EventName]
  Fields:
    - field_name: type — example value
Events (failure): [ErrorEventName] — when [condition]
Business rules:
  - [rule 1]
  - [rule 2]
```

**STATE_VIEW:**
```
Slice: [Name]
Actor: [who sees it]
Trigger events: [list of events that update this view]
Read Model: [ModelName]
  Fields:
    - field_name: type — example value
Screen: [what the user sees / how data is presented]
```

**AUTOMATION:**
```
Slice: [Name]
Trigger event: [EventName]
Processor: [ProcessorName]
Command issued: [CommandName]
Result events: [EventName(s)]
Failure handling: [what happens if the command fails]
```

### Step 4 — Given/When/Then Specifications

For each STATE_CHANGE slice, write acceptance scenarios:

```
Scenario: [Slice name] — success
  Given: [preconditions / existing events]
  When: [Command is issued with fields]
  Then: [Event is emitted with fields]

Scenario: [Slice name] — [failure case]
  Given: [preconditions]
  When: [Command is issued]
  Then: [ErrorEvent is emitted / validation error returned]
```

These map directly to pytest tests in `backend/tests/` and BDD tests.

---

## Common Mistakes

- Using technical names: `insertOwnerRecord` → use `RegisterOwner`
- Missing STATE_VIEW slices — every data entry needs a corresponding display
- Circular dependencies between aggregates — keep slices pointing one direction
- Bundling multiple commands into one STATE_CHANGE — one command per slice
- Writing specifications for trivial validation before understanding the domain
- Treating AUTOMATION slices as optional — they often carry critical business logic

---

## Output Format

Produce the model as a markdown document structured as:

```markdown
# Event Model: [Feature Name]

## Actors
- [Actor 1]: [description]

## Aggregates
- [Aggregate 1]: [description]

## Slice Inventory
[table]

## Slice Definitions
[one section per slice using the templates above]

## Acceptance Scenarios
[Given/When/Then per STATE_CHANGE slice]
```

Save to `specs/<feature-id>/event-model.md` unless the user specifies otherwise.

After producing the model, ask: "Should I use this as input to `/speckit.plan`?"

---

**Attribution:** Adapted from Praxis by Antonio Acuña (https://github.com/acunap/praxis), MIT License.
