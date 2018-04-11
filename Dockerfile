FROM amd64/alpine:3.7

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

ENV PATH "$PATH:/usr/src/app"

RUN apk update \
    && apk add --no-cache bash \
    && apk add --no-cache curl \
    && apk add --no-cache unzip \
    && apk add --no-cache jq \
    && curl -L -O https://github.com/ericchiang/pup/releases/download/v0.4.0/pup_v0.4.0_linux_amd64.zip \
    && unzip pup_v0.4.0_linux_amd64.zip

COPY verkkaaja.sh /usr/src/app/

ENTRYPOINT ["/usr/src/app/verkkaaja.sh"]
