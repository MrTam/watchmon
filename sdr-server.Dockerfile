FROM alpine:3.6

RUN apk add --no-cache musl-dev gcc make cmake pkgconf git libusb-dev

RUN git clone git://git.osmocom.org/rtl-sdr.git

RUN cd rtl-sdr && \
    mkdir build && \
    cd build && \
    cmake ../ -DINSTALL_UDEV_RULES=ON && \
    make && \
    make install && \
    cd / && \
    rm -rf rtl-sdr

ENV FREQUENCY=433920000
ENV SAMPLERATE=250000

ENTRYPOINT rtl_tcp -a "0.0.0.0" -f $FREQUENCY -s $SAMPLERATE
