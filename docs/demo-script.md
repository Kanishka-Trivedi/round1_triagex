# TRIAGE-X Demo Script

## Goal

This demo is designed to quickly communicate what TRIAGE-X is, why it matters, and how an autonomous agent interacts with it.

Ideal demo length: **2–4 minutes**

---

## 1. Opening

> TRIAGE-X is a benchmark-style incident response environment for autonomous agents.
> It simulates backend service outages, noisy alerts, dependency failures, and budget-constrained recovery decisions.

---

## 2. Show the Environment API

Open the backend and show:

- `/health`
- `/tasks`
- `/reset`

Suggested narration:

> The environment exposes a clean REST interface, so any external policy or agent can interact with it in a reproducible way.

---

## 3. Reset a Task

Use:

```bash
curl -X POST http://localhost:5050/reset \
  -H "Content-Type: application/json" \
  -d '{"task_name":"easy_signal_noise"}'