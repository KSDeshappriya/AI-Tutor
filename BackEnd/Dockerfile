FROM python:3.12-slim-bookworm

# The installer requires curl (and certificates) to download the release archive
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates && rm -rf /var/lib/apt/lists/*

# Download the latest installer
ADD https://astral.sh/uv/install.sh /uv-installer.sh

# Run the installer then remove it
RUN sh /uv-installer.sh && rm /uv-installer.sh

# Ensure the installed binary is on the PATH
ENV PATH="/root/.local/bin/:$PATH"

WORKDIR /app

# Copy requirements files first
COPY uv.lock ./
COPY pyproject.toml ./

# Install dependencies using uv
RUN uv --version
RUN uv sync

# Create upload directory
RUN mkdir -p uploads

# Copy the rest of the application
COPY . .

ENV PYTHONPATH=/app
ENV PORT=8000
ENV HOST=0.0.0.0
ENV GOOGLE_API_KEY="AIzaSyBru4lgqGpms81Jcx7pD4VKNSqqyQj_Dxw"
ENV model_name="gemini-2.0-flash-exp"

EXPOSE 8000

# Use uv run to execute with the virtual environment
CMD ["uv", "run", "python", "main.py"]