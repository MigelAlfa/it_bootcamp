FROM alpine:latest

LABEL maintainer="migelalfa@gmail.com"


RUN apk update \
    && apk upgrade \
    && apk add --no-cache python3 \
    && apk add --no-cache py3-pip \
    && mkdir /www

COPY apitest.py /www/apitest.py

CMD ["python3", "/www/apitest.py"]

EXPOSE 8080