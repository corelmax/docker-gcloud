FROM golang:alpine as builder

RUN apk add --no-cache \
    curl \
    git \
    make

# install dep
RUN OUTPUT_BIN=/usr/local/go/bin/dep \
    && curl --connect-timeout 60 -sSLo $OUTPUT_BIN https://github.com/golang/dep/releases/download/v0.5.1/dep-linux-amd64 \
    && chmod 755 $OUTPUT_BIN
RUN wget -O - https://github.com/corelmax/hum/archive/0.0.2.tar.gz | tar xvzf -
RUN mkdir /bin-hum
RUN cd hum* \
    && export GOPATH=$GOPATH:$PWD \
    && make \
    && cp ./bin/* /bin-hum/

FROM docker:stable

RUN apk add --update make ca-certificates openssl python
RUN update-ca-certificates
RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz
RUN tar zxvf google-cloud-sdk.tar.gz && ./google-cloud-sdk/install.sh --usage-reporting=false --path-update=true
RUN google-cloud-sdk/bin/gcloud --quiet components update
RUN google-cloud-sdk/bin/gcloud components install kubectl
COPY --from=builder /bin-hum/ /