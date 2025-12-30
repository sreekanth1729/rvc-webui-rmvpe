# ==========================================================
# rvc-webui-rmvpe (Public-grade) - Multi-stage build
# - Builder stage compiles patched fairseq into a wheel
# - Final stage installs wheel (no runtime compilation)
# ==========================================================

# 1) Builder stage: build fairseq wheel
FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel AS builder

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    cmake \
    ninja-build \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Pin build tooling to avoid setuptools 70+ breaking fairseq builds
RUN pip install --upgrade pip \
    setuptools==69.5.1 \
    wheel \
    cython==0.29.36

# Build patched fairseq fork into a wheel
RUN mkdir -p /wheels \
    && pip wheel git+https://github.com/One-sixth/fairseq.git -w /wheels


# 2) Final stage: runtime image (stable, no compilation)
FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

# Torch memory stability (helps prevent fragmentation-related OOM)
ENV PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:128

# System deps for audio tooling + convenience
RUN apt-get update && apt-get install -y \
    git \
    ffmpeg \
    sox \
    wget \
    curl \
    unzip \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

# Install the prebuilt fairseq wheel (instant, no compilation)
COPY --from=builder /wheels /wheels
RUN pip install /wheels/*.whl

# Core deps (pinned). Keep these in the final image for one-stop behavior.
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

# Workspace layout
WORKDIR /app
RUN mkdir -p /app/logs /app/dataset /app/audio /app/models /app/scripts

# Clone the base UI repo (we’ll pin commit later)
RUN git clone https://github.com/pinkfloyd1213/RVC-AIO.git /app/rvc
WORKDIR /app/rvc

EXPOSE 7865 6006 8080
CMD ["bash"]
