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

RUN apk add --no-cache libusb py-pip
COPY --from=build-env /rtl-sdr/build/install /

RUN pip install pyrtlsdr
COPY server.py ./

EXPOSE 1234
ENTRYPOINT python server.py
