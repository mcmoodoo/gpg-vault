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
    pacman -S --noconfirm --needed rustup && rustup default stable && \
    pacman -Scc --noconfirm

RUN mkdir -p /home/mcmoodoo/ && \
    touch /home/mcmoodoo/.bashrc && \
    echo 'alias ll="ls -al"' >> /home/mcmoodoo/.bashrc && \
    chmod -R 777 /home/mcmoodoo

RUN mkdir -p /workspace && \
    chmod 777 /workspace

WORKDIR /workspace

CMD ["/bin/bash"]
