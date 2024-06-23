FROM hdlc/ghdl:yosys

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    git \
    python3 \ 
    python3-pip \ 
    python3-venv \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*

# Venv
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# VUnit
RUN pip3 install vunit_hdl==4.7.0 \
 && rm -rf ~/.cache