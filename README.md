# rvc-webui-rmvpe

**rvc-webui-rmvpe** is a **public-grade, stable RVC WebUI template** designed for high-fidelity voice cloning using **RVC (48kHz, v2)** with **RMVPE pitch extraction**.

This project exists because most existing RVC WebUI templates either:
- do not support RMVPE reliably during training, or
- crash during feature extraction due to unsafe defaults and memory mismanagement.

This repository fixes those issues while preserving a **fully functional WebUI experience**, making it suitable for **RunPod templates and general public use**.

---

## 🎯 Goals

- ✅ Fully functional **WebUI** (no “CLI-only” requirement for users)
- ✅ **RMVPE-first** training pipeline (mandatory for high-quality pitch accuracy)
- ✅ Stable feature extraction (no random GPU OOMs)
- ✅ Reproducible environment with **strict dependency pinning**
- ✅ Suitable for **public RunPod deployment**
- ✅ No local machine required

---

## 🧠 Key Design Decisions

### 1. RMVPE as a Hard Requirement
RMVPE provides significantly better pitch tracking than Harvest/DIO, especially for:
- tonal nuances
- vowel length
- non-English languages (e.g., Malayalam)

This template **does not compromise** on F0 quality.

---

### 2. WebUI + Headless Orchestrator
The WebUI remains fully usable, but all heavy operations (feature extraction, RMVPE, training) are executed via a **hardened backend orchestrator** that enforces:

- safe thread/process limits
- GPU memory safety (`PYTORCH_CUDA_ALLOC_CONF`)
- single-flight execution (prevents double-click crashes)
- resumable stages
- clear logging

This removes the common failure modes seen in stock RVC WebUI deployments.

---

### 3. Public-Grade Stability
This template is built for **single-tenant use** (one user per container), which matches how RunPod templates are typically used.

It intentionally avoids:
- experimental IDE tooling
- auto-scaling multi-user assumptions
- fragile WebUI-only execution paths

---

## 📦 What This Template Includes

- RVC WebUI (Gradio)
- RMVPE support for training
- TensorBoard
- FileBrowser
- CLI-backed orchestration for stability
- Persistent volume support for:
  - datasets
  - models
  - logs
  - checkpoints

---

## 🚫 What This Template Does NOT Try to Do

- ❌ Multi-user concurrency
- ❌ Fix Gradio internals
- ❌ Replace RVC with a custom framework
- ❌ Sacrifice stability for convenience

---

## 🚀 Intended Usage

- RunPod templates
- Cloud GPU pods
- Researchers / creators who want **RVC WebUI that actually works**
- Users who want RMVPE without manual script juggling

---

## ⚠️ Disclaimer

This project builds on community RVC work and is intended for **educational and research purposes**.
Users are responsible for ensuring they have the right to use any voice data or models they train.

---

## 🧭 Project Status

🚧 Actively being hardened and documented.  
Initial public template release coming soon.
