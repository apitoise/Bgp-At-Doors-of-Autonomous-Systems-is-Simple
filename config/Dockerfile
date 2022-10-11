# For P1

FROM alpine AS host

RUN apk update && \
	apk upgrade

# For P2
COPY utils/ip_config.sh ip_config.sh

# FOR P1
FROM frrouting/frr AS router

RUN apk update && \
	apk upgrade && \
	rm -rf /etc/frr/daemons

COPY utils/daemons /etc/frr/daemons
COPY utils/vtysh.conf /etc/frr/vtysh.conf
COPY utils/start.sh start.sh

# For P2

COPY utils/static_vxlan.sh static_vxlan.sh
COPY utils/dyn_vxlan.sh dyn_vxlan.sh

CMD ./start.sh
