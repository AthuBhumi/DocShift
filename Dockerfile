# syntax=docker/dockerfile:1.4

ARG PYTHON_VERSION=3.9.14
FROM python:${PYTHON_VERSION}-slim as base

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        gcc \
        g++ \
        make \
        libgl1 \
        # Added this line to fix libgthread-2.0.so.0 error
        libglib2.0-0 \
        libffi-dev \
        libssl-dev \
        libatlas-base-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
# Optional: Add non-root user (can skip if not required on Railway)
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

# Copy requirements first to leverage cache
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade -r requirements.txt

# Copy full project code
COPY . .

# Optional: Switch to non-root user
# USER appuser

EXPOSE 8000

# Start your app
CMD gunicorn 'app:app' --bind=0.0.0.0:8000
