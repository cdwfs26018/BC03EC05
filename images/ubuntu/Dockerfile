FROM ubuntu:latest

ARG DEFAULT_USERNAME=ubuntu
ARG DEFAULT_PASSWORD=ubuntu

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openssh-server \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/sshd \
    && if ! id -u "${DEFAULT_USERNAME}" >/dev/null 2>&1; then useradd -m -s /bin/bash "${DEFAULT_USERNAME}"; fi \
    && mkdir -p "/home/${DEFAULT_USERNAME}/.ssh" \
    && echo "${DEFAULT_USERNAME}:${DEFAULT_PASSWORD}" | chpasswd

COPY authorized_keys /tmp/authorized_keys
COPY start-ssh.sh /usr/local/bin/start-ssh.sh

RUN cp /tmp/authorized_keys "/home/${DEFAULT_USERNAME}/.ssh/authorized_keys" \
    && chown -R "${DEFAULT_USERNAME}:${DEFAULT_USERNAME}" "/home/${DEFAULT_USERNAME}/.ssh" \
    && chmod 700 "/home/${DEFAULT_USERNAME}/.ssh" \
    && chmod 600 "/home/${DEFAULT_USERNAME}/.ssh/authorized_keys" \
    && chmod 755 /usr/local/bin/start-ssh.sh \
    && rm /tmp/authorized_keys \
    && sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#\?KbdInteractiveAuthentication .*/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config \
    && printf '\nUsePAM yes\n' >> /etc/ssh/sshd_config

CMD ["/usr/local/bin/start-ssh.sh"]
