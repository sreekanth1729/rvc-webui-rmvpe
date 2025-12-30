FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

# Torch memory stability (helps prevent fragmentation-related OOM)
ENV PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:128

RUN apt-get update && apt-get install -y \
    python3.10 python3-pip python3-venv python3.10-dev \
    git ffmpeg sox wget curl unzip \
    build-essential cmake ninja-build pkg-config \
    libsndfile1 libsndfile1-dev \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/bin/python3.10 /usr/bin/python
RUN python -m pip install --upgrade pip setuptools wheel

# Pinned Torch CUDA 11.8
RUN pip install \
    torch==2.0.1+cu118 torchvision==0.15.2+cu118 torchaudio==2.0.2+cu118 \
    --extra-index-url https://download.pytorch.org/whl/cu118

# Pinned core deps (split for reliability/debuggability)
# Build helper (native extensions)
RUN pip install cython==0.29.36

# Numeric/audio stack
RUN pip install \
    numpy==1.23.5 \
    scipy==1.10.1 \
    librosa==0.9.2 \
    soundfile==0.12.1

# Native extensions (require build tools)
RUN pip install \
    praat-parselmouth==0.4.3 \
    pyworld==0.3.4

# fairseq (isolate due to version sensitivity)
RUN pip install fairseq==0.12.2

# Web stack + monitoring
RUN pip install \
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

# Clone the base UI repo (we’ll pin commit later)
RUN git clone https://github.com/pinkfloyd1213/RVC-AIO.git /app/rvc
WORKDIR /app/rvc

EXPOSE 7865 6006 8080

CMD ["bash"]
