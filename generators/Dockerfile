FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    CONDA_DIR=/opt/conda \
    PATH=/opt/conda/bin:$PATH \
    CYDIR=/workspaces/chipyard

# 基础依赖 + Miniforge
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        git curl sudo nano build-essential cmake ninja-build \
        clang-15 llvm-15-dev kmod util-linux mount \
        ca-certificates bash-completion xz-utils unzip bzip2 git-lfs && \
    rm -rf /var/lib/apt/lists/* && \
    curl -fsSL https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -o /tmp/miniforge.sh && \
    bash /tmp/miniforge.sh -b -p ${CONDA_DIR} && rm /tmp/miniforge.sh && \
    ln -s ${CONDA_DIR}/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo '. /opt/conda/etc/profile.d/conda.sh' >> /etc/bash.bashrc && \
    echo 'conda activate base' >> /etc/bash.bashrc

# conda-lock + 克隆 fudaneda/chipyard 的 fgra 分支
RUN bash -lc "conda activate base && \
    conda install -y -n base -c conda-forge conda-lock=1.4 && \
    git clone https://github.com/fudaneda/chipyard.git ${CYDIR} -b fgra"

# 安装 OSS CAD Suite
ENV OSSCAD_VERSION=2025-10-11 \
    OSSCAD_DIR=/opt/oss-cad-suite

RUN curl -L https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${OSSCAD_VERSION}/oss-cad-suite-linux-x64-${OSSCAD_VERSION}.tgz \
    -o /tmp/oss-cad-suite.tgz && \
    mkdir -p ${OSSCAD_DIR} && \
    tar -xzf /tmp/oss-cad-suite.tgz -C ${OSSCAD_DIR} --strip 1 && \
    rm /tmp/oss-cad-suite.tgz && \
    echo "export PATH=${OSSCAD_DIR}/bin:\$PATH" >> /etc/bash.bashrc

WORKDIR ${CYDIR}
CMD ["bash"]

#  docker build -t chipyard-fgra:base .
#  docker run -it --name chipyard-fgra-init --cap-add=SYS_ADMIN --device=/dev/loop-control --device=/dev/loop0 --security-opt apparmor:unconfined chipyard-fgra:base bash
#  ./build-setup.sh riscv-tools -f -s 6 -s 7
#  exit
#  docker commit chipyard-fgra-init chipyard-fgra:ready