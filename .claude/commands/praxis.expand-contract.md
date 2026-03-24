---
description: >
  Plan and execute a zero-downtime breaking change using the Expand-Contract pattern.
  Use when renaming DB columns, changing API field names/types, replacing a service,
  or any change that would break existing clients or data if done in a single step.
---

## User Input

```text
$ARGUMENTS
```

Describe the breaking change you need to make (e.g., "rename the `email` column to
`email_address`", "change the `/users` response field `name` to `full_name`"). If no
argument is provided, ask: "What breaking change do you need to make?"

---

## Expand-Contract Pattern

This pattern makes breaking changes safely in three sequential phases, with verification
gates between each phase. **Never skip a phase. Never rush the Contract phase.**

---

## Phase 1 — EXPAND

**Goal:** Add the new implementation alongside the old. Zero disruption to existing
consumers.

### Steps

1. **Identify all write paths** — every place that writes to the old column/field/endpoint
2. **Add the new alongside the old:**
   - DB column: `ALTER TABLE ... ADD COLUMN new_name type`
   - API field: add `new_field` to response while keeping `old_field`
   - Service: deploy new service while keeping old service running
3. **Implement dual-write** — every write goes to both old and new simultaneously
4. **Add monitoring** — track usage of both old and new paths independently
5. **Deploy and verify** — confirm dual-write is working in production logs

### Expand Checklist (must pass before Phase 2)

- [ ] New column/field/service exists alongside old
- [ ] Dual-write is confirmed working (data flowing to both paths)
- [ ] Monitoring shows both paths receiving writes
- [ ] No existing consumers broken
- [ ] Rollback plan documented: drop new column / remove new field / stop new service

---

## Phase 2 — MIGRATE

**Goal:** Gradually shift readers/consumers to the new path. Old path still receives
writes as safety net.

### Steps

1. **Update readers one by one:**
   - Update internal consumers (other services, background jobs, reports)
   - Update the API response to prefer the new field
   - Update frontend/clients to read from the new path
2. **Use feature flags or canary deployment** for incremental rollout if risk is high
3. **Backfill historical data** if the new column needs data from before the Expand phase:
   ```sql
   UPDATE table SET new_name = old_name WHERE new_name IS NULL;
   ```
4. **Monitor old path usage** — wait until old path reads drop to zero

### Migrate Checklist (must pass before Phase 3)

- [ ] All readers/consumers updated to use new path
- [ ] Historical data backfilled (if applicable)
- [ ] Monitoring confirms old path has ZERO read traffic
- [ ] Dual-write still active (both paths still receive writes)
- [ ] System healthy under new path for at least [24h for low-risk / 1 week for high-risk]

---

## Phase 3 — CONTRACT

**Goal:** Remove the old implementation. Only after verified zero usage.

### Steps

1. **Verify zero usage** — confirm in logs/metrics that old path has received zero reads
   for the required observation window
2. **Stop dual-write** — update write paths to write only to new path
3. **Remove old implementation:**
   - DB column: `ALTER TABLE ... DROP COLUMN old_name`
   - API field: remove `old_field` from response schema
   - Service: decommission old service, remove infrastructure
4. **Remove monitoring for old path** — clean up dashboards and alerts
5. **Update documentation** — update API docs, data model docs, `plan.md` if applicable

### Contract Checklist

- [ ] Old path zero-usage confirmed in monitoring for required observation window
- [ ] Dual-write stopped — writes going only to new path
- [ ] Old column/field/service removed
- [ ] Schema migration applied (if DB)
- [ ] API docs updated
- [ ] No dead code remaining

---

## Anti-Patterns to Avoid

| Anti-pattern | Why it fails |
|---|---|
| Big-bang migration | One deployment breaks all consumers simultaneously |
| Removing old code before zero-usage verified | Silent data loss if stragglers still reading old path |
| Skipping dual-write | New path missing data written during migration window |
| No monitoring before Phase 3 | Can't prove old path is truly unused |
| Merging all three phases into one PR | Impossible to roll back safely if issues arise |

---

## Output Format

Produce a **migration plan** with:

1. **Change summary** — what is changing and why
2. **Risk assessment** — Low / Medium / High based on: number of consumers, data
   volume, rollback complexity
3. **Phase 1 tasks** — specific code changes needed for Expand (with file paths)
4. **Phase 2 tasks** — specific consumer updates and backfill queries needed
5. **Phase 3 tasks** — specific removal steps
6. **Observation windows** — recommended time to wait between phases given risk level
7. **Rollback procedure** — what to do if Phase 2 or Phase 3 goes wrong

If the change is low-risk (internal API, no external clients, small data volume),
note where phases can be accelerated.

---

**Attribution:** Adapted from Praxis by Antonio Acuña (https://github.com/acunap/praxis), MIT License.
