FROM alpine AS host

RUN apk update && \
	apk upgrade && \
	apk add busybox

FROM frrouting/frr AS router

RUN apk update && \
	apk upgrade && \
	apk add busybox

COPY config/daemons /etc/frr/daemons
COPY config/vtysh.conf /etc/frr/vtysh.conf
