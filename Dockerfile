# Stage 1: build dependencies
FROM cgr.dev/chainguard/python:latest-dev AS builder

WORKDIR /app
COPY app/requirements.txt .
RUN pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

# Stage 2: minimal runtime
FROM cgr.dev/chainguard/python:latest

WORKDIR /app
COPY --from=builder /wheels /wheels
RUN pip install --no-cache-dir --no-index --find-links=/wheels /wheels/*

COPY app/ .

USER nonroot
EXPOSE 8080

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
