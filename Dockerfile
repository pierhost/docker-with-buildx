ARG BUILDX_VERSION=0.5.1
ARG DOCKER_VERSION=latest

FROM alpine AS fetcher

RUN apk add curl

ARG BUILDX_VERSION
# replace / by - in 
#ARG BUILDX_ARCH=${TARGETPLATFORM//\//-}
ARG BUILDX_ARCH=linux-arm-v7
RUN curl -L \
      --output /docker-buildx \
      "https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.${BUILDX_ARCH}"

RUN chmod a+x /docker-buildx

ARG DOCKER_VERSION
FROM docker:${DOCKER_VERSION}

COPY --from=fetcher /docker-buildx /usr/lib/docker/cli-plugins/docker-buildx
RUN mkdir -p /etc/docker && echo '{"experimental": true}' > /usr/lib/docker/config.json
