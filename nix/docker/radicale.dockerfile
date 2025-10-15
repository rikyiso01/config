FROM docker.io/python:3.13-slim@sha256:914bf5c12ea40a97a78b2bff97fbdb766cc36ec903bfb4358faf2b74d73b555b

RUN pip install 'radicale==3.0.0' 'radicale-storage-decsync==2.1.0' 'setuptools==75.8.0'
COPY ./radicale.ini /config/config.ini
CMD ["python3","-m","radicale","--config","/config/config.ini"]
