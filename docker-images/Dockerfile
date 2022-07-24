FROM ubuntu:latest

RUN apt update && apt install -y bzip2 dbus gcc-10 systemd python3 iputils-ping git git-man iproute2 less sudo vim unzip

COPY container-entrypoint.sh /bin/

ENTRYPOINT ["/bin/container-entrypoint.sh"]
