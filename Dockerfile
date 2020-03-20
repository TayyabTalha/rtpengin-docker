FROM debian:buster
MAINTAINER Igor Olhovskiy <igorolhovskiy@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV RTPENGINE_VERSION mr8.0
ENV BCG729_VERSION 1.0.4

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git \
                dpkg-dev \
                cmake \
                unzip \
                wget \
                debhelper-compat \
                default-libmysqlclient-dev \
                gperf \
                iptables-dev \
                libavcodec-dev \
                libavfilter-dev \
                libavformat-dev \
                libavutil-dev \
                libbencode-perl \
                libcrypt-openssl-rsa-perl \
                libcrypt-rijndael-perl \
                libcurl4-openssl-dev \
                libdigest-crc-perl \
                libdigest-hmac-perl \
                libevent-dev libglib2.0-dev \
                libhiredis-dev libio-multiplex-perl \
                libio-socket-inet6-perl libiptc-dev \
                libjson-glib-dev libnet-interface-perl \
                libpcap0.8-dev \
                libpcre3-dev \
                libsocket6-perl \
                libspandsp-dev \
                libssl-dev \
                libswresample-dev \
                libsystemd-dev \
                libxmlrpc-core-c3-dev \
                markdown \
                curl \
                wget \
                zlib1g-dev && \
    cd /usr/src && \
    curl https://codeload.github.com/BelledonneCommunications/bcg729/tar.gz/$BCG729_VERSION > bcg729_$BCG729_VERSION.orig.tar.gz && \
    tar zxf bcg729_$BCG729_VERSION.orig.tar.gz && \
    cd bcg729-$BCG729_VERSION && \
    git clone https://github.com/ossobv/bcg729-deb.git debian && \
    dpkg-buildpackage -us -uc -sa && \
    cd /usr/src && \
    dpkg -i *.deb && \
    cd /usr/src && \
    git clone -b $RTPENGINE_VERSION https://github.com/sipwise/rtpengine.git && \
    cd rtpengine && \
    dpkg-buildpackage && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/deb && \
    mv /usr/src/*.deb /opt/deb

VOLUME ["/opt/deb"]

FROM debian:buster

RUN mkdir -p /opt/deb

COPY --from=0 /opt/deb /opt/deb
WORKDIR /opt/deb

RUN apt-get update && apt-get install -y \
    gpg \
    wget \
    curl \
    libbencode-perl \
    libcrypt-rijndael-perl \
    libdigest-hmac-perl \
    libio-socket-inet6-perl \
    libsocket6-perl \
    iptables \
    libavcodec58 \
    libavfilter7 \
    libavformat58 \
    libavutil56 \
    libevent-2.1-6 \
    libevent-pthreads-2.1-6 \
    libglib2.0-0 \
    libhiredis0.14 \
    libjson-glib-1.0-0 \
    libmariadb3 \
    libpcap0.8 \
    libspandsp2 \
    libswresample3 \
    libxmlrpc-core-c3 \
    nfs-common \
    netcat \
    lsb-release \
    dkms \
    && apt-get clean && rm -rf /var/lib/apt/

RUN dpkg -i libbcg729-0*.deb && \
	dpkg -i ngcp-rtpengine-daemon_*.deb && \
	apt-get install -f && \
	dpkg -i ngcp-rtpengine-recording-daemon_*.deb && \
	apt-get install -f && \
	dpkg -i ngcp-rtpengine-utils_*.deb && \
	apt-get install -f && \
	dpkg -i ngcp-rtpengine-iptables_*.deb && \
	apt-get install -f && \
	dpkg -i ngcp-rtpengine-kernel-dkms_*.deb && \
	dpkg -i ngcp-rtpengine_*.deb

ENV RUN_RTPENGINE=yes
ENV LISTEN_TCP=25060
ENV LISTEN_UDP=12222
ENV LISTEN_NG=22222
ENV LISTEN_CLI=9900
ENV TIMEOUT=60
ENV SILENT_TIMEOUT=3600
ENV PIDFILE=/var/run/ngcp-rtpengine-daemon.pid
ENV FORK=no
ENV TABLE=0
ENV PORT_MIN=16384
ENV PORT_MAX=16485
ENV LOG_LEVEL=7

COPY run.sh /run.sh
RUN chmod 755 /run.sh

CMD /run.sh
