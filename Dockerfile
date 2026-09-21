FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg fonts-dejavu-core unzip && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY GIRO_SITE*.zip /tmp/

RUN latest=$(find /tmp -maxdepth 1 -type f -name 'GIRO_SITE*.zip' | sort -V | tail -n1) && \
    echo "Usando pacote: $latest" && \
    unzip "$latest" -d /app && \
    rm -f /tmp/GIRO_SITE*.zip

RUN pip install --no-cache-dir -r requirements.txt

ENV PORT=10000

EXPOSE 10000

CMD ["gunicorn","-w","1","-k","gthread","--threads","4","--timeout","1200","-b","0.0.0.0:10000","server:app"]
