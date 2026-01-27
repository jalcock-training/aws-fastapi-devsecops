# Stage 1: build wheels
FROM cgr.dev/chainguard/python:latest-dev AS builder

WORKDIR /app
COPY app/requirements.txt .
RUN pip wheel --no-cache-dir --wheel-dir /app/wheels -r requirements.txt


# Stage 2: install wheels into a venv
FROM cgr.dev/chainguard/python:latest-dev AS installer

WORKDIR /app
COPY --from=builder /app/wheels /app/wheels
RUN python -m venv /app/venv
RUN /app/venv/bin/pip install --no-cache-dir --no-index --find-links=/app/wheels fastapi uvicorn


# Stage 3: minimal runtime (distroless)
FROM cgr.dev/chainguard/python:latest

WORKDIR /app

# Copy the fully installed venv
COPY --from=installer /app/venv /app/venv

# Copy your application
COPY app/ .

ENV PATH="/app/venv/bin:${PATH}"

USER nonroot
EXPOSE 8080

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
