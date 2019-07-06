FROM debian:stretch as builder

ENV RISCV_VERSION v20180629

# LABEL \
#       com.github.lerwys.docker.dockerfile="Dockerfile" \
#       com.github.lerwys.vcs-type="Git" \
#       com.github.lerwys.vcs-url="https://github.com/lerwys/docker-riscv-tools.git"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
        automake \
        autoconf \
        build-essential \
        gawk \
        curl  \
        bison \
        flex \
        texinfo \
        libmpc-dev \
        libmpfr-dev \
        libgmp-dev \
        libtool \
        libz-dev \
        libexpat1-dev \
        git \
	ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /
RUN git clone --recurse-submodules https://github.com/riscv/riscv-gnu-toolchain
WORKDIR /riscv-gnu-toolchain
RUN ./configure --prefix=/opt/riscv32im --with-arch=rv32im && \
    make -j all && \
    make install

FROM debian:stretch

COPY --from=builder /opt/riscv32im /opt/riscv32im

ENV PATH "/opt/riscv32im/bin:$PATH"
VOLUME /opt/riscv32im
