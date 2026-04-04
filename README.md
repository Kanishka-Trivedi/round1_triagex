# TRIAGE-X: NOC Incident Response Environment

**TRIAGE-X** is a deterministic, real-world DevOps/SRE incident response simulator designed specifically for the OpenEnv reinforcement learning benchmark. In this environment, an Autonomous AI Agent plays the role of a Site Reliability Engineer (SRE). Its objective is to diagnose and stabilize complex microservice failures across an API Gateway, Database, Payment microservice, and Caching layers to prevent customer impact and save the on-call budget.

---

## 🎯 Benchmark Alignment
This repository is 100% strictly compliant with the **OpenEnv Specification**:
- **Real-World Task:** AI agents perform distributed microservice debugging and root-cause analysis (no toy environments).
- **Standard HTTP API:** Strictly implements `POST /reset`, `POST /step`, `GET /state`, `GET /tasks`, `GET /score`, and `GET /health` with deterministic endpoints.
- **Progressive Reward Function:** The `rewardEngine.js` provides granular shaping signals ranging strictly from `-1.0` to `+1.0` by rewarding isolated symptom discovery and penalizing reckless reboots.
- **Docker & Deployment:** Pre-configured with a dual-stage `Dockerfile` native to Hugging Face Spaces.
- **Observable Dashboard:** Includes a minimalist `React/Vite` frontend for human observability.

---

## 🧩 Active Scenarios (Tasks)

The environment ships with 3 distinct grading difficulties producing a normalized final episode score between `0.0` and `1.0`:

1. **`easy_signal_noise`**: A simple queue bottleneck scenario. The AI must scale or throttle the correct service without rebooting healthy components.
2. **`medium_hidden_dependency`**: A cascading failure where the database latency negatively impacts the front-facing API Gateway. The AI must ignore the superficial API symptom and target the core Database issue.
3. **`hard_multi_incident`**: Concurrent cascading anomalies affecting multiple clusters simultaneously, requiring extensive resource and budget management to hit a high benchmark threshold. 

---

## 🔎 Environment State Space

The observation space returned mathematically by `GET /state` contains:
- **`system_health` (Float 0.0-1.0):** Overall cluster health parameter.
- **`customer_impact` (Float 0.0-100.0):** Downstream severity score.
- **`remaining_budget` (Integer):** Abstract cost of infrastructure and engineering hours.
- **`services` (List[Object]):** The active topology, containing parameters:
  - `name`: Service ID (e.g. `api_gateway`, `database_replica`)
  - `health`: Component operational status (0.0-1.0)
  - `error_rate`: 0.0-1.0 probability of failed payloads
  - `queue_depth`: Current load queue backpressure integer.
  - `latency`: Current ping latency in `ms`.
  - `inspected`: Boolean flag showing if the agent has gathered intel.
- **`active_alerts` (List[Object]):** Triggered simulants from CloudWatch/Datadog.

---

## 🎮 Action Space

When submitting a JSON payload to `POST /step`, agents must specify an `action` string and an optional `target` parameter:

| Action | Target Required? | Description |
| :--- | :---: | :--- |
| `noop` | No | Perform no action (Tick the clock forward). |
| `inspect_service` | Yes | Reveal hidden telemetry for a given architecture component. |
| `inspect_dependency` | Yes | Trace downstream routing to find invisible relationships. |
| `restart_service` | Yes | Hard cycle a component (costs budget, restores health). |
| `throttle_queue` | Yes | Drop traffic to a given service to let backpressure clear. |
| `rollback_deploy` | Yes | Revert a faulty deployment signature. |
| `scale_service` | Yes | Spin up lateral instances to handle queue depth. |

*Example Payload:*
```json
{
  "action": "inspect_service",
  "target": "api_gateway"
}
```

---

## 🚀 Setup & Execution

### 1. Local Development Frontend & Backend
You can run the environment natively using NPM:
```bash
# Terminal 1: Boot the API Engine (Port 7860)
cd server
npm install
npm run start

# Terminal 2: Boot the Observability NOC (Port 5173)
cd client
npm install
npm run dev
```
Navigate to `http://localhost:5173` to manually interact with the environment via the minimalist web dashboard.

### 2. Direct Container Deployment (Hugging Face Spaces)
The root directory includes a `Dockerfile` for single-click deployment:
```bash
docker build -t openenv-triagex .
docker run -p 7860:7860 openenv-triagex
```

### 3. Agent Inference Logic
To validate the environment compliance locally against an automated AI loop, run the provided evaluation script using the `openai` Python SDK (Default Target: `gpt-4o-mini`):

```bash
# Set your environment variables in .env
# API_BASE_URL=https://api.openai.com/v1
# OPENAI_API_KEY=sk-...

python3 -m venv venv
source venv/bin/activate
pip install openai python-dotenv
python3 inference.py
```
*(The inference script is fully configured to emit required stdout chunks: `[START]`, `[STEP]`, and `[END]`)*.
