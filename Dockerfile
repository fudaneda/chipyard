FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    CONDA_DIR=/opt/conda \
    PATH=/opt/conda/bin:$PATH \
    CYDIR=/root/chipyard

# Base Dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        git curl sudo nano build-essential cmake ninja-build \
        clang-15 llvm-15-dev kmod util-linux mount \
        ca-certificates bash-completion xz-utils unzip bzip2 git-lfs && \
    rm -rf /var/lib/apt/lists/*
# Miniforge
RUN curl -fsSL https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -o /tmp/miniforge.sh && \
    bash /tmp/miniforge.sh -b -p ${CONDA_DIR} && rm /tmp/miniforge.sh && \
    ln -s ${CONDA_DIR}/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo '. /opt/conda/etc/profile.d/conda.sh' >> /etc/bash.bashrc && \
    echo 'conda activate base' >> /etc/bash.bashrc && \
    bash -lc "conda activate base && conda install -y -n base -c conda-forge conda-lock=1.4" && \
    /opt/conda/bin/conda clean -afy

# Install OSS CAD Suite
ENV OSSCAD_RELEASE_VERSION=2025-10-11 \
    OSSCAD_VERSION=20251011 \
    OSSCAD_DIR=/opt/oss-cad-suite

RUN curl -L https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${OSSCAD_RELEASE_VERSION}/oss-cad-suite-linux-x64-${OSSCAD_VERSION}.tgz \
    -o /tmp/oss-cad-suite.tgz && \
    mkdir -p ${OSSCAD_DIR} && \
    tar -xzf /tmp/oss-cad-suite.tgz -C ${OSSCAD_DIR} --strip 1 && \
    rm /tmp/oss-cad-suite.tgz && \
    echo "export PATH=${OSSCAD_DIR}/bin:\$PATH" >> /etc/bash.bashrc

# clone chipyard
RUN git clone https://github.com/fudaneda/chipyard.git ${CYDIR} -b fgra

RUN bash -lc "cd ${CYDIR} && \
    source /opt/conda/etc/profile.d/conda.sh && conda activate base && \
    ./build-setup.sh riscv-tools -f \
      -s 2 -s 3 -s 4 -s 5 -s 6 -s 7 -s 8 -s 9 -s 10"

RUN bash -lc "cd ${CYDIR} && \
    source ${CYDIR}/.conda-env/etc/profile.d/conda.sh && \
    conda activate ${CYDIR}/.conda-env && \
    conda install -y -c conda-forge \
      networkx nlohmann_json spdlog openjdk=17 && pip install pulp"

RUN bash -lc "cd ${CYDIR} && \
    source ${CYDIR}/.conda-env/etc/profile.d/conda.sh && \
    conda activate ${CYDIR}/.conda-env && \
    RISCV=${CYDIR}/.conda-env/riscv-tools \
    ./build-setup.sh riscv-tools -f \
      -s 1 -s 3 -s 4 -s 5 -s 6 -s 7 -s 8 -s 9 -s 10"

RUN bash -lc "cd ${CYDIR} && \
    source ${CYDIR}/.conda-env/etc/profile.d/conda.sh && \
    conda activate ${CYDIR}/.conda-env && \
    RISCV=${CYDIR}/.conda-env/riscv-tools \
    ./build-setup.sh riscv-tools -f \
      -s 1 -s 2 -s 4 -s 5 -s 6 -s 7 -s 8 -s 9 -s 10"

RUN bash -lc "cd ${CYDIR} && \
    source ${CYDIR}/.conda-env/etc/profile.d/conda.sh && \
    conda activate ${CYDIR}/.conda-env && \
    RISCV=${CYDIR}/.conda-env/riscv-tools \
    ./build-setup.sh riscv-tools -f \
      -s 1 -s 2 -s 3 -s 5 -s 6 -s 7 -s 8 -s 9 -s 10"

RUN bash -lc "cd ${CYDIR} && \
    source ${CYDIR}/.conda-env/etc/profile.d/conda.sh && \
    conda activate ${CYDIR}/.conda-env && \
    RISCV=${CYDIR}/.conda-env/riscv-tools \
    ./build-setup.sh riscv-tools -f \
      -s 1 -s 2 -s 3 -s 4 -s 6 -s 7 -s 8 -s 9 -s 10"

RUN bash -lc "cd ${CYDIR} && \
    source ${CYDIR}/.conda-env/etc/profile.d/conda.sh && \
    conda activate ${CYDIR}/.conda-env && \
    RISCV=${CYDIR}/.conda-env/riscv-tools \
    ./build-setup.sh riscv-tools -f \
      -s 1 -s 2 -s 3 -s 4 -s 5 -s 6 -s 7 -s 9 -s 10"

RUN bash -lc "cd ${CYDIR} && \
    source ${CYDIR}/.conda-env/etc/profile.d/conda.sh && \
    conda activate ${CYDIR}/.conda-env && \
    RISCV=${CYDIR}/.conda-env/riscv-tools \
    ./build-setup.sh riscv-tools -f \
      -s 1 -s 2 -s 3 -s 4 -s 5 -s 6 -s 7 -s 9 -s 10"

RUN bash -lc "cd ${CYDIR} && \
    source ${CYDIR}/.conda-env/etc/profile.d/conda.sh && \
    conda activate ${CYDIR}/.conda-env && \
    RISCV=${CYDIR}/.conda-env/riscv-tools \
    ./build-setup.sh riscv-tools -f \
      -s 1 -s 2 -s 3 -s 4 -s 5 -s 6 -s 7 -s 8 -s 10"

RUN bash -lc "cd ${CYDIR} && \
    source ${CYDIR}/.conda-env/etc/profile.d/conda.sh && \
    conda activate ${CYDIR}/.conda-env && \
    RISCV=${CYDIR}/.conda-env/riscv-tools \
    ./build-setup.sh riscv-tools -f \
      -s 1 -s 2 -s 3 -s 4 -s 5 -s 6 -s 7 -s 8 -s 9"

WORKDIR ${CYDIR}
CMD ["bash"]      
# How to build a docker image
#   docker build -t chipyard-fgra:ready .
#   docker run -it --rm --cap-add=SYS_ADMIN \
#     --device=/dev/loop-control --device=/dev/loop0 \
#     --security-opt apparmor:unconfined chipyard-fgra:ready bash
