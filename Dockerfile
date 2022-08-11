FROM alpine:3.16.2

ARG VERSION

ENV PUID=1000
ENV GUID=1000
ENV SERVER_PATH=/mindustry

RUN echo "=== Install Java 8 ===" && \
    apk add --no-cache openjdk8-jre && \
    echo "=== Create server directory ===" && \
    mkdir -p ${SERVER_PATH} && \
    echo "=== Download game ===" && \
    wget https://github.com/Anuken/Mindustry/releases/download/${VERSION}/server-release.jar -O ${SERVER_PATH}/server-release.jar

USER ${PUID}:${GUID}

VOLUME ${SERVER_PATH}/config
WORKDIR ${SERVER_PATH}

ENTRYPOINT ["/usr/bin/java", "-jar", "server-release.jar"]

EXPOSE 6567/tcp 6567/udp
