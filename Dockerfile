FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip \
    && rm -rf /var/lib/apt/lists/*

# The repository stores the original project as 99999.zip.
# Extract its "extracted/" folder into the application root.
COPY 99999.zip /tmp/spirit.zip
RUN unzip -q /tmp/spirit.zip -d /tmp/spirit \
    && cp -a /tmp/spirit/extracted/. /app/ \
    && rm -rf /tmp/spirit /tmp/spirit.zip

RUN pip install --no-cache-dir "Flask>=3.0,<4.0" "gunicorn>=22.0,<24.0"

EXPOSE 10000
CMD ["sh", "-c", "python -c \"from app import init_db; init_db()\" && exec gunicorn app:app --bind 0.0.0.0:${PORT:-10000} --workers 1 --threads 4 --timeout 120"]
