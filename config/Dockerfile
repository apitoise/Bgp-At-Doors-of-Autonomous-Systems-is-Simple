FROM alpine AS host

RUN apk update && \
	apk upgrade

FROM frrouting/frr AS router

RUN apk update && \
	apk upgrade && \
	rm -rf /etc/frr/daemons

COPY utils/daemons /etc/frr/daemons
COPY utils/vtysh.conf /etc/frr/vtysh.conf
COPY utils/start.sh start.sh

CMD ./start.sh
