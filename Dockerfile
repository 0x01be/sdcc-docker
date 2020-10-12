FROM arm32v6/alpine as builder

RUN apk --no-cache add --virtual sdcc-build-dependencies \
    git \
    build-base \
    bison \
    flex \
    boost-dev \
    libusb-dev \
    zlib-dev

ENV SDCC_REVISION master
RUN git clone --depth 1 --branch ${SDCC_REVISION} https://github.com/swegener/sdcc.git /sdcc

WORKDIR /sdcc

RUN ./configure \
    --prefix=/opt/sdcc \
    --disable-ucsim \
    --disable-pic14-port \
    --disable-pic16-port
RUN make install

FROM arm32v6/alpine

COPY --from=builder /opt/sdcc/ /opt/sdcc/

ENV PATH $PATH:/opt/sdcc/bin/

