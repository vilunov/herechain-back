FROM python:3.7

EXPOSE 80

WORKDIR /app

RUN pip install uwsgi
COPY ./requirements.txt .
RUN pip install -r requirements.txt --no-cache-dir
COPY . .

CMD uwsgi --ini uwsgi.ini
