FROM alpine:latest

MAINTAINER migelalfa

ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

RUN mkdir ./app
WORKDIR ./app
COPY ./app/* .
EXPOSE 8090
CMD ["python3", "listener.py"]