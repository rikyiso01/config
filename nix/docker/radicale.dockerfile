FROM docker.io/python:3.13-slim

RUN pip install 'radicale==3.0.0' 'radicale-storage-decsync==2.1.0' 'setuptools==75.8.0'
COPY ./radicale.ini /config/config.ini
CMD ["python3","-m","radicale","--config","/config/config.ini"]
