# ==========================================================
# rvc-webui-rmvpe (Public-grade) - Multi-stage build
# Space-safe: use nvidia/cuda base (smaller than pytorch/pytorch)
# - Builder: install torch wheels + build fairseq wheel from patched fork
# - Final: install torch wheels + install fairseq wheel (no compilation)
# ==========================================================

# 1) Builder stage: build fairseq wheel
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y \
    python3.10 python3-pip python3-venv python3.10-dev \
    git build-essential cmake ninja-build pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/bin/python3.10 /usr/bin/python
RUN python -m pip install --upgrade pip

# Install pinned Torch wheels (CUDA 11.8) in builder so fairseq builds against them
RUN pip install \
    torch==2.0.1+cu118 \
    torchvision==0.15.2+cu118 \
    torchaudio==2.0.2+cu118 \
    --extra-index-url https://download.pytorch.org/whl/cu118

# Pin build tooling (avoid setuptools 70+)
RUN pip install \
    setuptools==69.5.1 \
    wheel \
    cython==0.29.36

# Build patched fairseq fork into a wheel
RUN mkdir -p /wheels \
    && pip wheel --no-build-isolation --no-deps git+https://github.com/One-sixth/fairseq.git -w /wheels


# 2) Final stage: runtime image
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

# Torch memory stability
ENV PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:128

RUN apt-get update && apt-get install -y \
    python3.10 python3-pip python3-venv \
    git ffmpeg sox wget curl unzip \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/bin/python3.10 /usr/bin/python
RUN python -m pip install --upgrade pip

# Install pinned Torch wheels (CUDA 11.8)
RUN pip install \
    torch==2.0.1+cu118 \
    torchvision==0.15.2+cu118 \
    torchaudio==2.0.2+cu118 \
    --extra-index-url https://download.pytorch.org/whl/cu118

# Install the prebuilt fairseq wheel (instant, no compilation)
COPY --from=builder /wheels /wheels
RUN pip install /wheels/*.whl

# Core deps (pinned)
RUN pip install \
    numpy==1.23.5 \
    scipy==1.10.1 \
    librosa==0.9.2 \
    soundfile==0.12.1 \
    praat-parselmouth==0.4.3 \
    pyworld==0.3.4 \
    tensorboard==2.13.0 \
    gradio==3.41.2 \
    fastapi==0.95.2 \
    uvicorn==0.22.0

# FileBrowser
RUN wget -q https://github.com/filebrowser/filebrowser/releases/latest/download/linux-amd64-filebrowser.tar.gz \
    && tar -xzf linux-amd64-filebrowser.tar.gz \
    && mv filebrowser /usr/local/bin/filebrowser \
    && rm linux-amd64-filebrowser.tar.gz

WORKDIR /app
RUN mkdir -p /app/logs /app/dataset /app/audio /app/models /app/scripts

# Clone base UI (pin later)
RUN git clone --depth 1 https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI.git /app/rvc
WORKDIR /app/rvc

EXPOSE 7865 6006 8080
CMD ["bash"]

# --- RunPod orchestrator ---
COPY rvc_start.sh /rvc_start.sh
RUN chmod +x /rvc_start.sh && mkdir -p /var/log /workspace/logs

EXPOSE 7865 6006 8080

ENTRYPOINT ["/bin/bash", "-lc"]
CMD ["/rvc_start.sh"]
