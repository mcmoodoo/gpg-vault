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
    pacman -S --needed rustup && rustup default stable && \
    pacman -Scc --noconfirm

RUN mkdir -p /home/claudeuser/ && \
    touch /home/claudeuser/.bashrc && \
    echo 'alias ll="ls -al"' >> /home/claudeuser/.bashrc

RUN groupadd -g ${GROUP_ID} claudeuser && \
    useradd -u ${USER_ID} -g ${GROUP_ID} -m -s /bin/bash claudeuser && \
    echo 'claudeuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /workspace

USER claudeuser

CMD ["/bin/bash"]
