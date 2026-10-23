FROM docker.io/library/python:3.12-alpine
RUN adduser -D -u 10001 smoke
WORKDIR /app
COPY server.py .
USER 10001
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/healthz || exit 1
CMD ["python", "-u", "server.py"]
