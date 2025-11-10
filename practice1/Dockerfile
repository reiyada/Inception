FROM debian:bookworm
RUN apt-get update && apt-get install -y curl
COPY app.sh /usr/local/bin/app.sh
RUN chmod +x /usr/local/bin/app.sh
CMD ["bash", "/usr/local/bin/app.sh"]
