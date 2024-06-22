FROM ubuntu:latest

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    wget \
    git \
    python3 \ 
    python3-pip \ 
    python3-venv \
    gcc \
    zlib1g-dev \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*

# Venv
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# VUnit
RUN pip3 install vunit_hdl==4.7.0 \
 && rm -rf ~/.cache

# Install OSS CAD suite (includes GHDL, Yosys etc)
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