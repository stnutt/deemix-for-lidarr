FROM --platform=$TARGETPLATFORM docker.io/library/node:16-alpine

ARG TARGETPLATFORM
ARG BUILDPLATFORM

ARG S6_OVERLAY_VERSION=3.1.6.2
RUN wget -O - https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz | tar -Jxp
RUN wget -O - https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz | tar -Jxp

RUN echo "Building for TARGETPLATFORM=$TARGETPLATFORM | BUILDPLATFORM=$BUILDPLATFORM"
RUN apk add --no-cache git jq python3 make gcc musl-dev g++ && \
    rm -rf /var/lib/apt/lists/*
RUN git clone --recurse-submodules https://gitlab.com/RemixDev/deemix-gui.git && \
    cd deemix-gui && \
    case "$TARGETPLATFORM" in \
        "linux/amd64") \
            jq '.pkg.targets = ["node16-alpine-x64"]' ./server/package.json > tmp-json ;; \
        "linux/arm64") \
            jq '.pkg.targets = ["node16-alpine-arm64"]' ./server/package.json > tmp-json ;; \
        *) \
            echo "Platform $TARGETPLATFORM not supported" && exit 1 ;; \
    esac && \
    mv tmp-json /deemix-gui/server/package.json && \
    yarn install-all && \
    sed -i 's/const channelData = await dz.gw.get_page(channelName)/let channelData; try { channelData = await dz.gw.get_page(channelName); } catch (error) { console.error(`Caught error ${error}`); return [];}/' ./server/src/routes/api/get/newReleases.ts && \
    yarn dist-server && \
    mv /deemix-gui/dist/deemix-server /deemix-server && \
    rm -rf /deemix-gui /root/.[^.]* /usr/local/share/.cache /tmp/*

RUN chmod +x /deemix-server

COPY deemix-server.sh /
RUN chmod +x /deemix-server.sh

ENV PUID=99
ENV PGID=100
ENV UMASK=0022

VOLUME ["/config", "/downloads"]
EXPOSE 6595
ENTRYPOINT /deemix-server.sh
