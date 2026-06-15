FROM ubuntu:latest

RUN if ! id -u ubuntu >/dev/null 2>&1; then useradd -m -s /bin/bash ubuntu; fi \
    && mkdir -p /home/ubuntu/.ssh

COPY authorized_keys /home/ubuntu/.ssh/authorized_keys

RUN chown -R ubuntu:ubuntu /home/ubuntu/.ssh \
    && chmod 700 /home/ubuntu/.ssh \
    && chmod 600 /home/ubuntu/.ssh/authorized_keys

CMD ["sleep", "infinity"]
