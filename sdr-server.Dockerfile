FROM alpine:3.6 AS build-env

RUN apk add --no-cache musl-dev gcc make cmake pkgconf git libusb-dev

RUN git clone git://git.osmocom.org/rtl-sdr.git && \
    git clone https://github.com/merbanan/rtl_433.git && \
    mkdir output

RUN cd /rtl-sdr && \
    mkdir build && \
    cd build && \
    cmake ../ -DCMAKE_INSTALL_PREFIX=/output -DINSTALL_UDEV_RULES=ON && \
    make install

RUN cd /rtl_433 && \
    mkdir build && \
    cd build && \
    cmake ../ -DCMAKE_INSTALL_PREFIX=/output && \
    make install

FROM alpine:3.6

RUN apk add --no-cache libusb

COPY --from=build-env /output /

ENV INFLUX_HOST=127.0.0.1 
ENV INFLUX_PORT=8086
ENV INFLUX_DB=watchman
ENV INFLUX_USER=watchman
ENV INFLUX_PASSWORD=watchman

ENTRYPOINT rtl_433 -R 43 -F "influx://$INFLUX_HOST:$INFLUX_PORT/write?db=$INFLUX_DB&p=$INFLUX_PASSWORD&u=$INFLUX_USER"
