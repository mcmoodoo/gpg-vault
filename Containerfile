FROM archlinux:latest

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        git \
        curl \
        vim \
        jq \
        pass \
        tree && \
    pacman -Scc --noconfirm

RUN mkdir -p /workspace && \
    chmod 777 /workspace && \
    echo 'alias ll="ls -al"' >> /etc/bash.bashrc && \
    echo 'set -o vi' >> /etc/bash.bashrc

WORKDIR /workspace

CMD ["/bin/bash"]
