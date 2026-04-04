Core Components
1. API Layer

The API layer provides a lightweight interface for external agents and evaluation scripts.

Supported endpoints:

POST /reset
POST /step
GET /state
GET /tasks
GET /score
GET /health

This allows TRIAGE-X to be used both interactively and programmatically.

2. Task Loader

Tasks are defined as JSON scenario files and loaded at episode reset.

Each task includes:

service topology,
initial health metrics,
alerts,
hidden root cause,
success conditions,
optional traps or structured variants.

This design makes tasks easy to extend while keeping the engine logic consistent.

3. State Manager

The environment state is maintained in-memory during each episode.

Tracked state includes:

service health,
latency,
error rate,
queue depth,
active alerts,
customer impact,
remaining budget,
action history,
task metadata.

The state manager is designed to keep the environment deterministic and fully serializable.

4. Observation Builder

The observation builder creates the agent-facing state.

Important internal fields such as:

hidden root cause,
noisy alert labels,
trap metadata,
grading internals,

are intentionally hidden from the agent.

This ensures the benchmark remains a reasoning task rather than a direct lookup problem.

5. Action Handler

The action handler applies deterministic action effects such as:

restart service,
rollback deploy,
scale service,
reroute traffic,
throttle queue,
inspect service,
inspect dependency,
silence alert,
noop.

Each action has:

a budget cost,
service-level effects,
possible side effects,
reward implications.

This creates meaningful action trade-offs instead of trivial one-step recovery.

6. Progression Engine

After every action, the environment advances one step.

The progression engine simulates:

passive degradation,
unresolved incident persistence,
downstream propagation,
queue growth,
latency escalation,
customer impact drift.

This ensures the environment behaves like a dynamic operational system rather than a static puzzle.

7. Reward Engine

The reward engine scores each step using multiple signals:

useful diagnosis,
health improvement,
customer impact reduction,
root-cause progress,
harmful actions,
repeated action penalties,
wasted budget penalties.

This discourages naive brute-force policies and encourages efficient recovery.

8. Final Grader

At the end of each episode, TRIAGE-X computes a final score in the range [0, 1].

The grader evaluates:

system stability,
customer harm reduction,
root cause resolution,
action efficiency,
budget utilisation,
harmful action avoidance.

This creates a richer benchmark than simple “success / fail” environments.

Design Philosophy

TRIAGE-X is designed around the idea that strong agents should not simply react to visible failures.

Instead, they should:

infer likely root causes,
reason over dependencies,
ignore misleading signals,
act efficiently under constraints,
stop when the system is sufficiently stable.

That makes TRIAGE-X a better fit for realistic agent evaluation than toy single-step control tasks.