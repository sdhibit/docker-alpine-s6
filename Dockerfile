FROM alpine:3.6
MAINTAINER Steve Hibit <sdhibit@gmail.com>

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' \
    APP_PATH='/app' \
    CONFIG_PATH='/config'

# set version for s6 overlay
ARG OVERLAY_VERSION="v1.20.0.0"
ARG OVERLAY_ARCH="amd64"
ARG OVERLAY_URL="https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}.tar.gz"

# Install helpful packages
RUN apk --update upgrade \
 && apk --no-cache add \
  --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
  ca-certificates \
  curl \
  shadow \
  su-exec \
  tzdata \

#Install s6 overlay
 && curl -kL ${OVERLAY_URL} | tar -xz -C / \

# Create app user
 && addgroup -g 666 -S appuser \
 && adduser -u 666 -SHG appuser appuser

# add local files
COPY root/ /

ENTRYPOINT ["/init"]