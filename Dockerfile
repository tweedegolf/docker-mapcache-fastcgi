FROM debian:jessie

ENV MAPCACHE_VERSION="1.4.1" \
    MAPCACHE_CONFIG_FILE="/usr/local/etc/mapcache.xml"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        wget \
        cmake \
        spawn-fcgi \
        build-essential \
        libapr1-dev \
        libaprutil1-dev \
        libpng12-dev \
        libjpeg62-turbo-dev \
        libcurl4-openssl-dev \
        libpcre3-dev \
        libpixman-1-dev \
        libfcgi-dev \
        libgdal1-dev \
        libgeos-dev \
        libsqlite3-dev \
        libgeotiff-dev \
        libtiff5-dev
RUN wget -O /tmp/mapcache-${MAPCACHE_VERSION}.tar.gz http://download.osgeo.org/mapserver/mapcache-${MAPCACHE_VERSION}.tar.gz \
    && cd /tmp \
    && tar xvfz /tmp/mapcache-${MAPCACHE_VERSION}.tar.gz \
    && mkdir /tmp/mapcache-${MAPCACHE_VERSION}/build \
    && cd /tmp/mapcache-${MAPCACHE_VERSION}/build \
    && cmake .. \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DCMAKE_BUILD_TYPE=Release \
        -DWITH_APACHE=0 \
        -DWITH_PIXMAN=ON \
        -DWITH_SQLITE=ON \
        -DWITH_TIFF=ON \
        -DWITH_GEOTIFF=ON \
        -DWITH_PCRE=ON \
        -DWITH_GEOS=ON \
        -DWITH_OGR=ON \
        -DWITH_CGI=ON \
        -DWITH_FCGI=ON \
        -DWITH_VERSION_STRING=ON \
    && make -j$(nproc) \
    && make install \
    && cd /tmp \
    && rm -rf /tmp/mapcache-${MAPCACHE_VERSION} \
    && ldconfig
