FROM archlinux:latest

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        git \
        curl \
        vim \
        jq \
        tree && \
    pacman -S --noconfirm --needed rustup && \
    rustup default stable && \
    rustup component add cargo rustfmt clippy && \
    pacman -Scc --noconfirm

ENV RUSTUP_HOME=/usr/local/rustup
ENV CARGO_HOME=/usr/local/cargo
ENV PATH=/usr/local/cargo/bin:$PATH

RUN mkdir -p /workspace && \
    chmod 777 /workspace

WORKDIR /workspace

CMD ["/bin/bash"]
