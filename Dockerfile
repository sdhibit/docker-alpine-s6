FROM alpine:3.7
LABEL maintainer="Steve Hibit <sdhibit@gmail.com>"

# set version for s6 overlay
ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' \
    APP_PATH='/app' \
    CONFIG_PATH='/config' \
    S6_KEEP_ENV=1

ARG OVERLAY_VERSION="v1.21.4.0"
ARG OVERLAY_URL="https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-amd64.tar.gz"

# Install base packages
RUN apk --update upgrade \
 && apk --no-cache add \
  --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
  ca-certificates \
  curl \
  shadow \
  tzdata \
 && curl -sSL ${OVERLAY_URL} | tar xfz - -C / \
# Create app user
 && addgroup -g 666 -S appuser \
 && adduser -u 666 -SHG appuser appuser

WORKDIR ${APP_PATH}

# add local files
COPY root /

RUN chmod +x /etc/cont-init.d/*

ENTRYPOINT [ "/init" ]
CMD []
