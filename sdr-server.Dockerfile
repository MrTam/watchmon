FROM alpine:3.6 AS build-env

RUN apk add --no-cache musl-dev gcc make cmake pkgconf git libusb-dev

RUN git clone git://git.osmocom.org/rtl-sdr.git

RUN cd rtl-sdr && \
    mkdir build && \
    cd build && \
    mkdir install && \
    cmake ../ -DCMAKE_INSTALL_PREFIX=/rtl-sdr/build/install -DINSTALL_UDEV_RULES=ON && \
    make install

FROM alpine:3.6

RUN apk add --no-cache libusb

COPY --from=build-env /rtl-sdr/build/install /

ENV FREQUENCY=433920000
ENV SAMPLERATE=250000

EXPOSE 1234

ENTRYPOINT rtl_tcp -a "0.0.0.0" -f $FREQUENCY -s $SAMPLERATE
