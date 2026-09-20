FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg fonts-dejavu-core unzip && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY GIRO_SITE_V10_RENDER_GROQ.zip /tmp/site.zip

RUN unzip /tmp/site.zip -d /app && rm /tmp/site.zip

RUN pip install --no-cache-dir -r requirements.txt

ENV PORT=10000

EXPOSE 10000

CMD ["gunicorn","-w","1","-k","gthread","--threads","4","--timeout","1200","-b","0.0.0.0:10000","server:app"]
