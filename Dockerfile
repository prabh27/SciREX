FROM python:3.7.3-stretch

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENV PATH /usr/local/nvidia/bin/:$PATH
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# Tell nvidia-docker the driver spec that we need as well as to
# use all available devices, which are mounted at /usr/local/nvidia.
# The LABEL supports an older version of nvidia-docker, the env
# variables a newer one.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
LABEL com.nvidia.volumes.needed="nvidia_driver"

# Install base packages.
RUN apt-get update --fix-missing && apt-get install -y \
    bzip2 \
    ca-certificates \
    curl \
    gcc \
    git \
    libc-dev \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    wget \
    libevent-dev \
    build-essential \
    openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /work

COPY scibert/ scibert/

COPY requirements.txt .
RUN pip install -r requirements.txt

ENV PYTHONPATH /work
ENV BERT_BASE_FOLDER scibert/
ENV CUDA_DEVICE 0
ENV OUTPUT_DIR /output

COPY model_data/ model_data/
COPY scripts/ scripts/
COPY dygie/ dygie/

CMD ["/bin/bash"]