FROM ubuntu:22.04

ARG UNAME=developer
ARG UID=1000
ARG GID=1000

ARG UHOME=/home/$UNAME
RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

RUN apt-get update
RUN apt-get -y install --no-install-recommends \
    git \
    curl \
    make \
    python3 \
    python3-pip \
    wget

RUN pip3 install -U setuptools wheel

# Install latest VUnit
RUN git clone https://github.com/VUnit/vunit.git --recurse-submodules
RUN pip install -e vunit
RUN rm -rf vunit

# Install OSS cad suite (includes GHDL, Yosys etc)
ENV OSS_RELEASE_YEAR=2024
ENV OSS_RELEASE_MONTH=06
ENV OSS_RELEASE_DAY=20
ENV OSS_RELEASE=${OSS_RELEASE_YEAR}${OSS_RELEASE_MONTH}${OSS_RELEASE_DAY}
ENV OSS_RELEASE_HYPHEN=${OSS_RELEASE_YEAR}-${OSS_RELEASE_MONTH}-${OSS_RELEASE_DAY}
RUN wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${OSS_RELEASE_HYPHEN}/oss-cad-suite-linux-x64-${OSS_RELEASE}.tgz
RUN mkdir -p /tools
RUN tar -xf oss-cad-suite-linux-x64-${OSS_RELEASE}.tgz -C tools
RUN rm oss-cad-suite-linux-x64-${OSS_RELEASE}.tgz
ENV PATH="${PATH}:/tools/oss-cad-suite/bin"