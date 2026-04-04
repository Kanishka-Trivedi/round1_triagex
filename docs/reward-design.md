# TRIAGE-X Reward Design

## Overview

TRIAGE-X uses a shaped reward system rather than a binary reward.

This is important because incident response is not a one-step success/fail problem.

A good agent should be rewarded not only for final recovery, but also for:
- useful diagnosis,
- efficient intervention,
- correct prioritisation,
- avoiding harmful behavior.

---

## Why Reward Shaping Is Necessary

If the environment only rewarded final success, then:

- useful diagnosis would appear valueless,
- intermediate recovery would not be recognized,
- budget efficiency would be weakly incentivized,
- poor-but-lucky strategies could score too well.

TRIAGE-X instead rewards meaningful progress while still preserving a strong final score signal.

---

## Reward Components

### 1. Diagnostic Value

Useful inspection actions receive positive reward when they help reveal likely root causes.

Examples:
- inspecting the true bottleneck,
- checking an upstream dependency before acting.

This encourages evidence-based intervention instead of blind action.

---

### 2. Health Improvement

When service health improves meaningfully after an action, reward is assigned proportionally.

This ensures agents are rewarded for actual stabilization rather than action count.

---

### 3. Customer Impact Reduction

If customer-facing harm decreases, the agent receives positive reward.

This keeps the benchmark aligned with operational reality:
the real goal is not just fixing internals, but reducing user-visible damage.

---

### 4. Root Cause Progress

High-value actions that directly address the true failure path receive strong reward.

Examples:
- rollback on a bad deployment,
- stabilizing the true upstream bottleneck.

This helps distinguish:
- symptom treatment,
- root-cause resolution.

---

### 5. Penalties

Negative reward is assigned for harmful or wasteful behavior, including:

- no-op spam,
- repeated low-value actions,
- wasting budget,
- masking symptoms without solving the issue,
- silencing meaningful alerts.

This prevents agents from gaming the environment with trivial loops.

---

## Final Score vs Step Reward

TRIAGE-X separates:

### Step Reward
Used during the episode to encourage good decision-making.

### Final Score
Used at episode end to evaluate overall policy quality.

This separation is intentional.

A policy can earn some positive intermediate reward while still performing poorly overall if it:
- overspends,
- delays too long,
- fails to stabilize the environment.

Likewise, a policy that takes a clean, efficient recovery path should score highly even with only a few actions.

---

## Design Philosophy

The reward system is designed to encourage agents that are:

- selective,
- causal,
- efficient,
- operationally grounded.

It is explicitly designed to discourage:
- brute-force intervention,
- random action exploration,
- noisy action spam,
- “fix everything” behavior.

---

## Why This Matters for Benchmarking

Many toy environments reward simple local improvements.

TRIAGE-X instead rewards something closer to real operational competence:

> making the right intervention, at the right time, for the right reason.

That is what makes it a meaningful benchmark rather than a simple simulator.