FROM debian:bookworm

RUN apt update && apt install -y cron wget curl

WORKDIR /scripts

CMD ["cron", "-f"]
