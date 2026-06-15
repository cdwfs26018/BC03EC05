#!/bin/sh
set -eu

user="${INSTANCE_USERNAME:-ubuntu}"
password="${INSTANCE_PASSWORD:-ubuntu}"
public_key="${INSTANCE_PUBLIC_KEY:-}"

if ! id -u "$user" >/dev/null 2>&1; then
  useradd -m -s /bin/bash "$user"
fi

echo "$user:$password" | chpasswd
mkdir -p "/home/$user/.ssh"

if [ -n "$public_key" ]; then
  printf '%s\n' "$public_key" >"/home/$user/.ssh/authorized_keys"
fi

chown -R "$user:$user" "/home/$user/.ssh"
chmod 700 "/home/$user/.ssh"
if [ -f "/home/$user/.ssh/authorized_keys" ]; then
  chmod 600 "/home/$user/.ssh/authorized_keys"
fi

exec /usr/sbin/sshd -D -e
