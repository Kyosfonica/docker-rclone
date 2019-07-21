FROM alpine:3.10.1
MAINTAINER kyos <kyos@kyos.es>

# s6 environment settings
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_KEEP_ENV=1

# global environment settings
ENV RCLONE_VERSION="v1.48.0"
ENV RCLONE_ARCH="amd64"

# install packages
RUN \
 apk update && \
 apk add --no-cache \
 ca-certificates

# install build packages
RUN \
 apk add --no-cache --virtual=build-dependencies \
		wget \
		curl \
		unzip && \
# add s6 overlay
 OVERLAY_VERSION=$(curl -sX GET "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]') && \
 curl -o \
	/tmp/s6-overlay.tar.gz -L \
	"https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${RCLONE_ARCH}.tar.gz" && \
 tar xfz \
	/tmp/s6-overlay.tar.gz -C / && \
 cd tmp && \
 wget -q https://downloads.rclone.org/${RCLONE_VERSION}/rclone-${RCLONE_VERSION}-linux-${RCLONE_ARCH}.zip && \
 unzip /tmp/rclone-${RCLONE_VERSION}-linux-${RCLONE_ARCH}.zip && \
 mv /tmp/rclone-*-linux-${RCLONE_ARCH}/rclone /usr/bin && \
 apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/community \
	shadow && \
# cleanup
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/* \
	/var/tmp/* \
	/var/cache/apk/*

VOLUME ["/config", "/cronlist"]

# create dummy user
RUN \
	groupmod -g 1000 users && \
	useradd -u 911 -U -d /config -s /bin/false dummy && \
	usermod -G users dummy && \
# create needed files and folders
	mkdir -p /config /app /cronlist /data && \
	touch /var/lock/rclone.lock

# add local files
COPY root/ /

ENTRYPOINT ["/init"]